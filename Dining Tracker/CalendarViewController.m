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
@import FSCalendar;
@import MZFormSheetController;

@interface CalendarViewController ()<FSCalendarDelegate, FSCalendarDataSource>
@property (strong, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) DiningTracker *tracker;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tracker = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).tracker;
    // Do any additional setup after loading the view.
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    for(NSDate *date in self.tracker.daysOff)
        [self.calendar selectDate:date];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonPressed:(id)sender {
    [self mz_dismissFormSheetControllerAnimated:true completionHandler:^(MZFormSheetController * _Nonnull formSheetController) {
        
    }];
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
