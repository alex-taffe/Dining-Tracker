//
//  CalendarViewController.m
//  Dining Tracker
//
//  Created by Alex Taffe on 9/28/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

#import "CalendarViewController.h"
#import "DiningTracker.h"
#import "AppDelegate.h"
#import "Constants.h"

@import FSCalendar;
@import MZFormSheetController;

@interface CalendarViewController ()<FSCalendarDelegate, FSCalendarDataSource>
@property (strong, nonatomic) IBOutlet FSCalendar *calendar; //the actual calendar view
@property (strong, nonatomic) IBOutlet UIButton *doneButton; //this is self explanatory
@property (strong, nonatomic) IBOutlet UIButton *cancelButton; //this is self explanatory
@property (strong, nonatomic) IBOutlet UIView *headerBackgroundView; //this contains the title of the view
@property (strong, nonatomic) DiningTracker *tracker; // the master tracker, set in the delegate, passed from the presenting view controller
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tracker = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).tracker;
    // Do any additional setup after loading the view.
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    //select all the dates that the user has already picked as days off
    for(NSDate *date in self.tracker.daysOff)
        [self.calendar selectDate:date];
    
    //style the cancel button
    self.cancelButton.backgroundColor = [UIColor colorWithRed:0.93 green:0.94 blue:0.95 alpha:1.00];
    self.cancelButton.tintColor = [UIColor colorWithRed:0.24 green:0.28 blue:0.08 alpha:1.00];
    
    //style the done button
    self.doneButton.backgroundColor = ORANGE_COLOR;
    self.doneButton.tintColor = UIColor.whiteColor;
    
    //style the header background
    self.headerBackgroundView.backgroundColor = ORANGE_COLOR;
    
    //return the calendar to the current month
    [self.calendar setCurrentPage:[NSDate date]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//called when user clicks cancel
- (IBAction)cancelButtonPressed:(id)sender {
    //dismiss and do not update days off
    [self mz_dismissFormSheetControllerAnimated:true completionHandler:nil];
}

//called when the user presses done
- (IBAction)doneButtonPressed:(id)sender {
    //update the days off and dismiss
    self.tracker.daysOff = self.calendar.selectedDates;
    [self mz_dismissFormSheetControllerAnimated:true completionHandler:nil];
}


/**
 * Asks the dataSource the minimum date to display.
 */
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:@"2017-08-01"];
}

/**
 * Asks the dataSource the maximum date to display.
 */
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:@"2017-12-31"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
