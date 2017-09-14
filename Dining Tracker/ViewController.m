//
//  ViewController.m
//  Dining Tracker
//
//  Created by Alex Taffe on 9/12/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UILabel *dollarsLabel;
@property (strong, nonatomic) NSArray<NSString *> *plans;
@property (strong, nonatomic) NSArray<NSNumber *> *prices;
@property (nonatomic) long totalDays;
@property (nonatomic) long currentDays;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.plans = @[@"Tiger 20", @"Tiger 14", @"Tiger 10", @"Tiger 5", @"Orange", @"Gold", @"Silver", @"Bronze", @"Brown"];
    self.prices = @[@325, @525, @725, @1325, @2762, @1400, @1000, @550, @2000];
    
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    
    NSString *start = @"2017-08-27";
    NSString *semesterEnd = @"2017-12-19";
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:start];
    NSDate *endDate = [NSDate date];
    NSDate *semesterEndDate = [f dateFromString:semesterEnd];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComponents = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    NSDateComponents *totalComponents = [gregorianCalendar components:NSCalendarUnitDay
                                                               fromDate:startDate
                                                                 toDate:semesterEndDate
                                                                options:0];
    
    
    self.totalDays = [totalComponents day];
    self.currentDays = [currentComponents day];
    
    double percent = (double)self.currentDays / (double)self.totalDays;
    int planValue = [self.prices[0] intValue];
    
    self.dollarsLabel.text = [[NSString alloc] initWithFormat:@"Should have spent: $%.02f\nShould have left: $%.02f", planValue * percent, planValue - planValue * percent];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.plans.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.plans[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    double percent = (double)self.currentDays / (double)self.totalDays;
    int planValue = [self.prices[row] intValue];
    
    self.dollarsLabel.text = [[NSString alloc] initWithFormat:@"Should have spent: $%.02f\nShould have left: $%.02f", planValue * percent, planValue - planValue * percent];
}

@end
