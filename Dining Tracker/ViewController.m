//
//  ViewController.m
//  Dining Tracker
//
//  Created by Alex Taffe on 9/12/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

#import "ViewController.h"
@import CZPicker;
@import CircleProgressBar;

@interface ViewController () <CZPickerViewDataSource, CZPickerViewDelegate, UITextFieldDelegate>
//storyboard UI
@property (strong, nonatomic) IBOutlet UILabel *planLabel;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UITextField *moneyLeftField;
@property (strong, nonatomic) IBOutlet CircleProgressBar *yearProgress;
@property (strong, nonatomic) IBOutlet CircleProgressBar *planProgress;
@property (strong, nonatomic) IBOutlet UILabel *totalSpentLabel;
@property (strong, nonatomic) IBOutlet UILabel *shouldHaveSpentLabel;
@property (strong, nonatomic) IBOutlet UILabel *shouldHaveLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *overSpentTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *overSpentLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftPerDayLabel;
@property (strong, nonatomic) IBOutlet UILabel *planPerDayLabel;

//other UI
@property (strong, nonatomic) CZPickerView *picker;
//static data
@property (strong, nonatomic) NSArray<NSString *> *plans;
@property (strong, nonatomic) NSArray<NSNumber *> *prices;
@property (nonatomic, strong) NSUserDefaults *preferences;
//instance data
@property (nonatomic) long totalDays;
@property (nonatomic) long currentDays;
@property (nonatomic) int currentPlanSelected;
@property (nonatomic) BOOL hasDisplayedPickerOnce;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.plans = @[@"Tiger 20 - $325", @"Tiger 14 - $525", @"Tiger 10 - $725", @"Tiger 5 - $1325", @"Orange - $2762", @"Gold - $1400", @"Silver - $1000", @"Bronze - $550", @"Brown - $2000"];
    self.prices = @[@325, @525, @725, @1325, @2762, @1400, @1000, @550, @2000];
    self.preferences = [NSUserDefaults standardUserDefaults];
    if([self.preferences objectForKey:@"plan"] == nil)
        [self.preferences setInteger:0 forKey:@"plan"];
    
    self.currentPlanSelected = (int)[self.preferences integerForKey:@"plan"];
    
    if([self.preferences objectForKey:@"value"] == nil)
        [self.preferences setDouble:[self.prices[self.currentPlanSelected] doubleValue] forKey:@"value"];
    
    self.moneyLeftField.text = [[NSString alloc] initWithFormat:@"$%0.2f", [self.preferences doubleForKey:@"value"]];
    
    
    self.picker = [[CZPickerView alloc] initWithHeaderTitle:@"Meal Plans"
                                          cancelButtonTitle:@"Cancel"
                                         confirmButtonTitle:@"Ok"];
    self.picker.headerBackgroundColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00];
    self.picker.confirmButtonBackgroundColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00];
    self.picker.needFooterView = true;
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self.picker setSelectedRows:@[[NSNumber numberWithInt:self.currentPlanSelected]]];
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = UIColor.whiteColor;
    
    self.editButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00];
    self.editButton.tintColor = UIColor.whiteColor;
    self.editButton.layer.cornerRadius = 5;
    
    self.moneyLeftField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

-(void)viewWillAppear:(BOOL)animated{
    [self setupDates];
    [self updateLabels];
}
- (IBAction)editMealPlan:(id)sender {
    [self.picker show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Utility
-(void)setupDates{
    NSString *start = @"2017-08-27";
    NSString *semesterEnd = @"2017-12-19";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [formatter dateFromString:start];
    NSDate *endDate = [NSDate date];
    NSDate *semesterEndDate = [formatter dateFromString:semesterEnd];
    
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
}

-(void)updateLabels{
    double percent = (double)self.currentDays / (double)self.totalDays;
    double valueLeft = [[self.moneyLeftField.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue];
    int planValue = [self.prices[self.currentPlanSelected] intValue];
    double totalSpent = planValue - valueLeft;
    double shouldHaveSpent = planValue * percent;
    double planProgressValue = totalSpent / planValue;
    double overSpent = shouldHaveSpent - totalSpent;
    long daysRemaining = self.totalDays - self.currentDays;
    
    
    self.planLabel.text = [self.plans[self.currentPlanSelected] componentsSeparatedByString:@" - "][0];
    
    [self.yearProgress setProgress:percent animated:true];
    [self.planProgress setProgress:(CGFloat)planProgressValue animated:true];

    
    self.totalSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", totalSpent];
    self.shouldHaveSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", shouldHaveSpent];
    self.shouldHaveLeftLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", planValue - shouldHaveSpent];
    
    if(overSpent > 0){
        self.overSpentTitleLabel.text = @"Underspent by:";
        self.overSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", overSpent];
    }
    else{
        self.overSpentTitleLabel.text = @"Overspent by:";
        self.overSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", -overSpent];
    }
    self.leftPerDayLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", (double)valueLeft / (double)daysRemaining];
    self.planPerDayLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", (double)planValue / (double)self.totalDays];
}


#pragma mark - Picker View

// The number of rows of data
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return self.plans.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row{
    return self.plans[row];
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    NSLog(@"Picked");
    
    self.currentPlanSelected = (int)row;
    [self.preferences setInteger:(int)row forKey:@"plan"];
    [self updateLabels];
}

- (void)czpickerViewDidDismiss:(CZPickerView *)pickerView{
    if(pickerView.selectedRows.count == 0){
        NSLog(@"Morons, you have to keep something selected. Reverting");
        [self.picker setSelectedRows:@[[NSNumber numberWithInt:self.currentPlanSelected]]];
    }
}
#pragma mark - Text field
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.preferences setDouble:[[textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue] forKey:@"value"];
    [textField resignFirstResponder];
    [self updateLabels];
    return false;
}

-(void)dismissKeyboard
{
    [self.preferences setDouble:[[self.moneyLeftField.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue] forKey:@"value"];
    [self.moneyLeftField resignFirstResponder];
    [self updateLabels];
}
// Set the currency symbol if the text field is blank when we start to edit.
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length  == 0)
        textField.text = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    // Make sure that the currency symbol is always at the beginning of the string:
    if (![newText hasPrefix:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]])
        return false;
    //Make sure we are only allowing two decimals
    if([newText containsString:@"."] && [[newText componentsSeparatedByString:@"."][1] length] > 2)
        return false;
    // Default:
    return true;
}

@end
