//
//  ViewController.m
//  Dining Tracker
//
//  Created by Alex Taffe on 9/12/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//
#import "DiningTracker.h"
#import "AppDelegate.h"
#import "ViewController.h"

@import CZPicker;
@import CircleProgressBar;
@import WatchConnectivity;

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
@property (strong, nonatomic) UIView *statusBar;
//static data
@property (strong, nonatomic) DiningTracker *tracker;
//instance data
@property (nonatomic) BOOL hasDisplayedPickerOnce;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //setup our instance data that is going to be give or take static
    self.tracker = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).tracker;
    
    
    //recover the previous money left value
    self.moneyLeftField.text = [[NSString alloc] initWithFormat:@"$%0.2f", self.tracker.diningBalance];
    
    
    //initialize the meal plan picker
    self.picker = [[CZPickerView alloc] initWithHeaderTitle:@"Meal Plans"
                                          cancelButtonTitle:@"Cancel"
                                         confirmButtonTitle:@"Ok"];
    
    self.picker.headerBackgroundColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00]; //make the header background orange
    self.picker.confirmButtonBackgroundColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00]; //confirm button background color orange
    self.picker.needFooterView = true; //add the footer
    self.picker.delegate = self; //set the delegate
    self.picker.dataSource = self; //set the datasource
    [self.picker setSelectedRows:@[[NSNumber numberWithInt:[DiningTracker indexOfMealPlan:self.tracker.currentMealPlan]]]]; //recover the currently selected plan
    
    //This just makes the status bar white so that it doesn't look awful when scrolling
    self.statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    self.statusBar.backgroundColor = UIColor.whiteColor;
    
    
    //add some style to the edit button
    self.editButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.13 alpha:1.00];
    self.editButton.tintColor = UIColor.whiteColor;
    self.editButton.layer.cornerRadius = 5;
    
    //set the money left delegate
    self.moneyLeftField.delegate = self;
    
    //add a toolbar to the keyboard
    UIToolbar* inputToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    inputToolbar.barStyle = UIBarStyleDefault;
    inputToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)],
                           nil];
    [inputToolbar sizeToFit];
    self.moneyLeftField.inputAccessoryView = inputToolbar;
    
    //add a gesture to make tapping outside the keyboard dismiss it
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

}

//this makes the app update when it appears
//so that even if it stays open in memory for a day
//it doesn't matter. Also called at first open
-(void)viewWillAppear:(BOOL)animated{
    [self.tracker updateDates];
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


//update the UI
-(void)updateLabels{
    //make sure that the value is not negative
    if(self.tracker.diningBalance < 0){
        self.moneyLeftField.text = @"$0.00";
        //alert the user
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You can not have a negative dining balance" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:true completion:nil];
    }
    
    //make sure the user hasn't entered a value that is too high
    if(self.tracker.diningBalance > self.tracker.mealPlanValue){
        //reset all values
        self.moneyLeftField.text = [[NSString alloc] initWithFormat:@"$%0.2f", 2 * self.tracker.mealPlanValue];
        //alert the user
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You can not have a value that exceeds twice your dining plan. Change your plan or reduce the amount." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:true completion:nil];
    }
    
    //update the label for the plan label but chop off the value
    self.planLabel.text = [DiningTracker getTitleForMealPlan:self.tracker.currentMealPlan];
    
    //update our circle graphs
    [self.yearProgress setProgress:self.tracker.semesterPercent animated:true];
    [self.planProgress setProgress:self.tracker.planProgressValue animated:true];

    if(self.tracker.totalSpent < 0)
        self.totalSpentLabel.text = [[NSString alloc] initWithFormat:@"$0.00"]; //update total spent
    else
        self.totalSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", self.tracker.totalSpent ]; //update total spent
    self.shouldHaveSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", self.tracker.shouldHaveSpent]; //should have spent
    self.shouldHaveLeftLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", self.tracker.shouldHaveLeft]; //should have left
    
    //check to see if the user has over or under spent and set accordingly
    if(self.tracker.overSpent > 0){
        self.overSpentTitleLabel.text = @"Underspent by:";
        self.overSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", self.tracker.overSpent];
    }
    else{
        self.overSpentTitleLabel.text = @"Overspent by:";
        self.overSpentLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", -self.tracker.overSpent];
    }
    
    self.leftPerDayLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", self.tracker.leftPerDay]; //how much they actually have left per day
    self.planPerDayLabel.text = [[NSString alloc] initWithFormat:@"$%0.2f", self.tracker.planPerDay]; // how much the plan says to spend per day
}


#pragma mark - Picker View

// The number of plans the user can pick from
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return DiningTracker.MealPlans.count;
}

// return the plan string for each individual row
- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row{
    return [[NSString alloc] initWithFormat:@"%@ - $%i", DiningTracker.MealPlans[row], (int)[DiningTracker getMealPlanFromIndex:(int)row]];
}

//called when a user has made a seleciton
- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    NSLog(@"Picked");
    
    //update current plan and store on the disk
    self.tracker.currentMealPlan = [DiningTracker getMealPlanFromIndex:(int)row];
    
    
    //update our UI
    [self updateLabels];
}


//caled when the picker is about to display
-(void)czpickerViewWillDisplay:(CZPickerView *)pickerView{
    //change the status bar background color to clear to avoid visual glitches with blurring
    [UIView animateWithDuration:0.0 animations:^{
        self.statusBar.backgroundColor = UIColor.clearColor;
    }];
}

//called when the picker is about to disappear
-(void)czpickerViewWillDismiss:(CZPickerView *)pickerView{
    //change the status bar back to white
    [UIView animateWithDuration:1.7 animations:^{
        self.statusBar.backgroundColor = UIColor.whiteColor;
    }];
}

//Check to make sure the user didnt just deselect a plan
//if they did, restore the previous value
- (void)czpickerViewDidDismiss:(CZPickerView *)pickerView{
    if(pickerView.selectedRows.count == 0){
        NSLog(@"Morons, you have to keep something selected. Reverting");
        [self.picker setSelectedRows:@[[NSNumber numberWithInt:[DiningTracker indexOfMealPlan:self.tracker.currentMealPlan]]]];
    }
}
#pragma mark - Text field
//called when return is pressed on the keyboard (not currently used)
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //update stored value on disk
    self.tracker.diningBalance = [[textField.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue]; //we have to remove the $ to get a clean double
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
    self.tracker.diningBalance = [[self.moneyLeftField.text stringByReplacingOccurrencesOfString:@"$" withString:@""] doubleValue]; //we have to remove the $ to get a clean double
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
    // allow backspace
    if (!string.length && textField.text.length > 1)
        return true;

    //characters allowed
    NSCharacterSet *numbersSet = [NSCharacterSet characterSetWithCharactersInString:@"$0123456789."];
    //actual characters
    NSCharacterSet *characterSetFromTextField = [NSCharacterSet characterSetWithCharactersInString:textField.text];
    
    //only let allowed characters occur
    if(![numbersSet isSupersetOfSet:characterSetFromTextField])
        return false;
    
    //make sure there is only 1 dollar sign
    if([[textField.text componentsSeparatedByString:@"$"] count] - 1 > 1)
        return false;
    
    //make sure there is only one decimal sign
    if([[textField.text componentsSeparatedByString:@"."] count] - 1 > 0 && [string isEqualToString:@"."])
        return false;
    
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
