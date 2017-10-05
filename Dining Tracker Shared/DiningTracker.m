//
//  DiningTracker.m
//  Dining Tracker
//
//  Created by Alex Taffe on 9/19/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

#import "DiningTracker.h"

@interface DiningTracker()
@property (strong, nonatomic) NSDate *semesterBeginDate;
@property (strong, nonatomic) NSDate *semesterEndDate;

@property (nonatomic) long currentDays;
@property (nonatomic) long totalDays;

@property (nonatomic, strong) NSUserDefaults *preferences;
@end

@implementation DiningTracker

#pragma mark: Class methods
///converts an index into a mealplan
+(MealPlanOption)getMealPlanFromIndex:(int)index{
    switch (index) {
        case 0:
            return MealPlanOptionTiger20;
            break;
        case 1:
            return MealPlanOptionTiger14;
            break;
        case 2:
            return MealPlanOptionTiger10;
            break;
        case 3:
            return MealPlanOptionTiger5;
            break;
        case 4:
            return MealPlanOptionOrange;
            break;
        case 5:
            return MealPlanOptionGold;
            break;
        case 6:
            return MealPlanOptionSilver;
            break;
        case 7:
            return MealPlanOptionBronze;
            break;
        case 8:
            return MealPlanOptionBrown;
            break;
        case 9:
            return MealPlanOptionCustom;
            break;
        default:
            return MealPlanOptionUnknown;
            break;
    }
}

///converts a mealplan into an index
+(int)indexOfMealPlan:(MealPlanOption)plan{
    switch (plan) {
        case MealPlanOptionTiger20:
            return 0;
            break;
        case MealPlanOptionTiger14:
            return 1;
            break;
        case MealPlanOptionTiger10:
            return 2;
            break;
        case MealPlanOptionTiger5:
            return 3;
            break;
        case MealPlanOptionOrange:
            return 4;
            break;
        case MealPlanOptionGold:
            return 5;
            break;
        case MealPlanOptionSilver:
            return 6;
            break;
        case MealPlanOptionBronze:
            return 7;
            break;
        case MealPlanOptionBrown:
            return 8;
            break;
        case MealPlanOptionCustom:
            return 9;
            break;
        default:
            return (int)NSIntegerMax;
            break;
    }
}

///get a string representation of a passed in meal plan
+(NSString *)getTitleForMealPlan:(MealPlanOption)plan{
    switch (plan) {
        case MealPlanOptionTiger20:
            return @"Tiger 20";
            break;
        case MealPlanOptionTiger14:
            return @"Tiger 14";
            break;
        case MealPlanOptionTiger10:
            return @"Tiger 10";
            break;
        case MealPlanOptionTiger5:
            return @"Tiger 5";
            break;
        case MealPlanOptionOrange:
            return @"Orange";
            break;
        case MealPlanOptionGold:
            return @"Gold";
            break;
        case MealPlanOptionSilver:
            return @"Silver";
            break;
        case MealPlanOptionBronze:
            return @"Bronze";
            break;
        case MealPlanOptionBrown:
            return @"Brown";
            break;
        case MealPlanOptionCustom:
            return @"Custom";
            break;
        case MealPlanOptionUnknown:
            return @"Configuration Error";
            break;
        default:
            return @"Configuration Error";
            break;
    }
}

#pragma mark: Class properties
///returns the list of all possible meal plans
+(NSArray<NSString *> *)MealPlans{
    static NSArray *_MealPlans;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _MealPlans = @[@"Tiger 20", @"Tiger 14", @"Tiger 10", @"Tiger 5", @"Orange", @"Gold", @"Silver", @"Bronze", @"Brown", @"Custom"];
    });
    return _MealPlans;
    
}
#pragma mark: Instance methods

///constructor
-(instancetype)initWithSemesterBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate{
    self = [super init];
    self.semesterBeginDate = beginDate;
    self.semesterEndDate = endDate;
    
    self.preferences = [NSUserDefaults standardUserDefaults];
    
    //make sure the plan variable exists and if not, set it
    if([self.preferences objectForKey:@"plan"] == nil)
        [self.preferences setInteger:0 forKey:@"plan"];
    
    //recover the currently selected plan
    self.currentMealPlan = [DiningTracker getMealPlanFromIndex:(int)[self.preferences integerForKey:@"plan"]];
    
    //make sure the value variable exists and if not, set it
    if([self.preferences objectForKey:@"value"] == nil)
        [self.preferences setDouble:self.mealPlanValue forKey:@"value"];
    
    //make sure the custom plan variable exists and if not, set it
    if([self.preferences objectForKey:@"customValue"] == nil)
        [self.preferences setDouble:0 forKey:@"customValue"];
    
    //see if the days off have been set yet. If not, init with default values
    if([self.preferences objectForKey:@"daysOff"] == nil){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //this is horrible, please fix this
        NSArray<NSDate *> *temp = @[[dateFormatter dateFromString:@"2017-08-01"], [dateFormatter dateFromString:@"2017-08-02"], [dateFormatter dateFromString:@"2017-08-03"], [dateFormatter dateFromString:@"2017-08-04"], [dateFormatter dateFromString:@"2017-08-05"], [dateFormatter dateFromString:@"2017-08-06"], [dateFormatter dateFromString:@"2017-08-07"], [dateFormatter dateFromString:@"2017-08-08"], [dateFormatter dateFromString:@"2017-08-09"], [dateFormatter dateFromString:@"2017-08-10"], [dateFormatter dateFromString:@"2017-08-11"], [dateFormatter dateFromString:@"2017-08-12"], [dateFormatter dateFromString:@"2017-08-13"], [dateFormatter dateFromString:@"2017-08-14"], [dateFormatter dateFromString:@"2017-08-15"], [dateFormatter dateFromString:@"2017-08-16"], [dateFormatter dateFromString:@"2017-08-17"], [dateFormatter dateFromString:@"2017-08-18"], [dateFormatter dateFromString:@"2017-08-19"], [dateFormatter dateFromString:@"2017-08-20"], [dateFormatter dateFromString:@"2017-08-21"], [dateFormatter dateFromString:@"2017-08-22"], [dateFormatter dateFromString:@"2017-08-23"], [dateFormatter dateFromString:@"2017-08-24"], [dateFormatter dateFromString:@"2017-08-25"], [dateFormatter dateFromString:@"2017-08-26"], [dateFormatter dateFromString:@"2017-08-27"], [dateFormatter dateFromString:@"2017-11-22"], [dateFormatter dateFromString:@"2017-11-23"], [dateFormatter dateFromString:@"2017-11-24"], [dateFormatter dateFromString:@"2017-11-25"], [dateFormatter dateFromString:@"2017-12-20"], [dateFormatter dateFromString:@"2017-12-21"], [dateFormatter dateFromString:@"2017-12-22"], [dateFormatter dateFromString:@"2017-12-23"], [dateFormatter dateFromString:@"2017-12-24"], [dateFormatter dateFromString:@"2017-12-25"], [dateFormatter dateFromString:@"2017-12-26"], [dateFormatter dateFromString:@"2017-12-27"], [dateFormatter dateFromString:@"2017-12-28"], [dateFormatter dateFromString:@"2017-12-29"], [dateFormatter dateFromString:@"2017-12-30"], [dateFormatter dateFromString:@"2017-12-31"]];
        [self.preferences setObject:temp forKey:@"daysOff"];
    }
    
    return self;
}
///recalculate all of the dates in the object
-(void)updateDates{
    NSDate *currentDate = [NSDate date];
    
    //set up our calendar
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //iterate over the days off the user has specified and figure out how many have passed (this could use some work)
    int i;
    for(i = 0; i < self.daysOff.count; i++){
        if([[gregorianCalendar components:NSCalendarUnitDay
                                          fromDate:self.daysOff[i]
                                            toDate:currentDate
                                           options:0] day] < 0)
            break;
    }
    i--;
    
    
    //get the components
    NSDateComponents *currentDateComponents = [gregorianCalendar components:NSCalendarUnitDay
                                                                   fromDate:self.semesterBeginDate
                                                                     toDate:currentDate
                                                                    options:0];
    NSDateComponents *totalComponents = [gregorianCalendar components:NSCalendarUnitDay
                                                             fromDate:self.semesterBeginDate
                                                               toDate:self.semesterEndDate
                                                              options:0];
    
    //set our instance data
    self.totalDays = [totalComponents day] - self.daysOff.count;
    self.currentDays = [currentDateComponents day] - i;
    //update the UI if possible
    if([self.delegate respondsToSelector:@selector(updateLabels)])
        [self.delegate updateLabels];
}

///sets the user's custom meal plan value
-(void)setCustomMealPlanValue:(double)value{
    [self.preferences setDouble:value forKey:@"customValue"];
}

#pragma mark: Instance properties

///returns a value between 0 and 1 representing how far into the semester we are
-(double)semesterPercent{
    return (double)self.currentDays / (double)self.totalDays;
}

///sets the user's current meal plan
-(void)setCurrentMealPlan:(MealPlanOption)plan{
    [self.preferences setInteger:[DiningTracker indexOfMealPlan:plan] forKey:@"plan"];
}

///returns the user's current meal plan
-(MealPlanOption)getCurrentMealPlan{
    return [DiningTracker getMealPlanFromIndex:(int)[self.preferences integerForKey:@"plan"]];
}

///sets user's current dining balance
-(void)setCurrentDiningBalance:(double)diningBalance{
    //limit dining balances
    if(diningBalance > 2 * self.mealPlanValue)
        diningBalance = 2 * self.mealPlanValue;
    [self.preferences setDouble:diningBalance forKey:@"value"];
}

///returns the user's current dining balance
-(double)getCurrentDiningBalance{
    return [self.preferences doubleForKey:@"value"];
}

///returns the value of the current meal plan
-(double)mealPlanValue{
    if(self.currentMealPlan == MealPlanOptionCustom)
        return [self.preferences doubleForKey:@"customValue"];
    else
        return self.currentMealPlan;
}

///returns the amount the user has spent
-(double)totalSpent{
    return self.mealPlanValue - self.diningBalance;
}

///returns the amount the user should have spent at this point in the semester
-(double)shouldHaveSpent{
    return self.mealPlanValue * self.semesterPercent;
}

///returns the amount the user should have left at this point in the semester
-(double)shouldHaveLeft{
    return self.mealPlanValue - self.shouldHaveSpent;
}

///returns a value between 0 and 1 representing a percentage of how much the user has spent of their meal plan value
-(double)planProgressValue{
    return self.totalSpent / self.mealPlanValue;
}

///returns a dollar value of how much the user has over or under spent by
-(double)overSpent{
    return self.shouldHaveSpent - self.totalSpent;
}

///returns the number of days remaining in the semester
-(long)daysRemaining{
    return self.totalDays - self.currentDays;
}

///returns a dollar value of how much the user can spend per day for the rest of the semester to still be on track
-(double)leftPerDay{
    return self.diningBalance / (double)self.daysRemaining;
}

///returns a dollar value of how much the user's plan calls for them to spend per day
-(double)planPerDay{
    return self.mealPlanValue / (double)self.totalDays;
}

///return the days off that the user has specified
-(NSArray<NSDate *> *)getDaysOff{
    return (NSArray<NSDate *> *)[self.preferences objectForKey:@"daysOff"];
}

///set the days off that the user has specified
-(void)setDaysOff:(NSArray<NSDate *> *)daysOff{
    [self.preferences setObject:daysOff forKey:@"daysOff"];
    [self updateDates];
}

@end
