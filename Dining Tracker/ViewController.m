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
    //setup our instance data that is going to be give or take static
    self.plans = @[@"Tiger 20 - $325", @"Tiger 14 - $525", @"Tiger 10 - $725", @"Tiger 5 - $1325", @"Orange - $2762", @"Gold - $1400", @"Silver - $1000", @"Bronze - $550", @"Brown - $2000"];
    self.prices = @[@325, @525, @725, @1325, @2762, @1400, @1000, @550, @2000];
    self.preferences = [NSUserDefaults standardUserDefaults];
    
    //make sure the plan variable exists and if not, set it
    if([self.preferences objectForKey:@"plan"] == nil)
        [self.preferences setInteger:0 forKey:@"plan"];
    
    //recover the currently selected plan
    self.currentPlanSelected = (int)[self.preferences integerForKey:@"plan"];
    
    //make sure the value variable exists and if not, set it
    if([self.preferences objectForKey:@"value"] == nil)
        [self.preferences setDouble:[self.prices[self.currentPlanSelected] doubleValue] forKey:@"value"];
    
    //recover the previous money left value
    self.moneyLeftField.text = [[NSString alloc] initWithFormat:@"$%0.2f", [self.preferences doubleForKey:@"value"]];
    
    
    //initialize the meal plan picker
    self.picker = [[CZPickerView alloc] initWithHeaderTitle:@"Meal Plans"
                                          cancelButtonTitle:@"Cancel"
                                         confirmButtonTitle:@"Ok"];
    
    self.picker.headerBackgroundColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00]; //make the header background orange
    self.picker.confirmButtonBackgroundColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00]; //confirm button background color orange
    self.picker.needFooterView = true; //add the footer
    self.picker.delegate = self; //set the delegate
    self.picker.dataSource = self; //set the datasource
    [self.picker setSelectedRows:@[[NSNumber numberWithInt:self.currentPlanSelected]]]; //recover the currently selected plan
    
    //This just makes the status bar white so that it doesn't look awful when scrolling
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = UIColor.whiteColor;
    
    
    //add some style to the edit button
    self.editButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00];
    self.editButton.tintColor = UIColor.whiteColor;
    self.editButton.layer.cornerRadius = 5;
    
    //set the money left delegate
    self.moneyLeftField.delegate = self;
    
    //add a gesture to make tapping outside the keyboard dismiss it
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

}

//this makes the app update when it appears
//so that even if it stays open in memory for a day
//it doesn't matter. Also called at first open
-(void)viewWillAppear:(BOOL)animated{
    [self setupDates];
    [self updateLabels];
}

//called when the user wants to edit their meal plan selection
- (IBAction)editMealPlan:(id)sender {
    [self.picker show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Utility

//modify the instance data with the current date information
-(void)setupDates{
    //start and end of the semester
    NSString *start = @"2017-08-27";
    NSString *semesterEnd = @"2017-12-19";
    
    //set up a date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //get date objects of the semester start, end, and the current date
    NSDate *startDate = [formatter dateFromString:start];
    NSDate *currentDate = [NSDate date];
    NSDate *semesterEndDate = [formatter dateFromString:semesterEnd];
    
    //set up our calendar
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //get the components
    NSDateComponents *currentDateComponents = [gregorianCalendar components:NSCalendarUnitDay
                                                               fromDate:startDate
                                                                 toDate:currentDate
                                                                options:0];
    NSDateComponents *totalComponents = [gregorianCalendar components:NSCalendarUnitDay
                                                             fromDate:startDate
                                                               toDate:semesterEndDate
                                                              options:0];
    
    //set our instance data
    self.totalDays = [totalComponents day];
    self.currentDays = [currentDateComponents day];
}


//update the UI
-(void)updateLabels{
    //all the variables we need
    double percent = (double)self.currentDays / (double)self.totalDays; //percent of the semester we're into
    double valueLeft = [[self.moneyLeftField.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue]; //get the value left the user has. We have to remove the $ to get a proper double to return
    int planValue = [self.prices[self.currentPlanSelected] intValue]; //get the value of the currently selected plan
    double totalSpent = planValue - valueLeft; //how much they've spent
    double shouldHaveSpent = planValue * percent; //how much they should've spent
    double planProgressValue = totalSpent / planValue; //percentage of what they've spent
    double overSpent = shouldHaveSpent - totalSpent; //how much they have overspent by
    long daysRemaining = self.totalDays - self.currentDays; //how many days left in the semester
    
    //update the label for the plan label but chop off the value
    self.planLabel.text = [self.plans[self.currentPlanSelected] componentsSeparatedByString:@" - "][0];
    
    //update our circle graphs
    [self.yearProgress setProgress:percent animated:true];
    [self.planProgress setProgress:(CGFloat)planProgressValue animated:true];

    
    self.totalSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", totalSpent]; //update total spent
    self.shouldHaveSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", shouldHaveSpent]; //should have spent
    self.shouldHaveLeftLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", planValue - shouldHaveSpent]; //should have left
    
    //check to see if the user has over or under spent and set accordingly
    if(overSpent > 0){
        self.overSpentTitleLabel.text = @"Underspent by:";
        self.overSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", overSpent];
    }
    else{
        self.overSpentTitleLabel.text = @"Overspent by:";
        self.overSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", -overSpent];
    }
    
    self.leftPerDayLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", (double)valueLeft / (double)daysRemaining]; //how much they actually have left per day
    self.planPerDayLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", (double)planValue / (double)self.totalDays]; // how much the plan says to spend per day
}


#pragma mark - Picker View

// The number of plans the user can pick from
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return self.plans.count;
}

// return the plan string for each individual row
- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row{
    return self.plans[row];
}

//called when a user has made a seleciton
- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    NSLog(@"Picked");
    
    //update current plan and store on the disk
    self.currentPlanSelected = (int)row;
    [self.preferences setInteger:(int)row forKey:@"plan"];
    
    //update our UI
    [self updateLabels];
}


//Check to make sure the user didnt just deselect a plan
//if they did, restore the previous value
- (void)czpickerViewDidDismiss:(CZPickerView *)pickerView{
    if(pickerView.selectedRows.count == 0){
        NSLog(@"Morons, you have to keep something selected. Reverting");
        [self.picker setSelectedRows:@[[NSNumber numberWithInt:self.currentPlanSelected]]];
    }
}
#pragma mark - Text field
//called when return is pressed on the keyboard (not currently used)
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //update stored value on disk
    [self.preferences setDouble:[[textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue] forKey:@"value"]; //we have to remove the $ to get a clean double
    //hide the keyboard
    [textField resignFirstResponder];
    //update our UI
    [self updateLabels];
    return false;
}

//called when the user taps outside the text field to dismiss the keyboard
-(void)dismissKeyboard
{
    //update stored value on disk
    [self.preferences setDouble:[[self.moneyLeftField.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue] forKey:@"value"]; //we have to remove the $ to get a clean double
    //hide the keyboard
    [self.moneyLeftField resignFirstResponder];
    //update our UI
    [self updateLabels];
}

// Set the currency symbol if the text field is blank when we start to edit.
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text.length  == 0)
        textField.text = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
}

//called every time the user tries to edit the value remaining
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
