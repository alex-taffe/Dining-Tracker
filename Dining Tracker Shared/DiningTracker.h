//
//  DiningTracker.h
//  Dining Tracker
//
//  Created by Alex Taffe on 9/19/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

@import Foundation;
@import WatchConnectivity;

///Meal plan options
typedef NS_ENUM(NSInteger, MealPlanOption) {
    MealPlanOptionTiger20 = 325,         //Tiger 20
    MealPlanOptionTiger14 = 525,         //Tiger 14
    MealPlanOptionTiger10 = 725,         //Tiger 10
    MealPlanOptionTiger5 = 1325,         //Tiger 5
    MealPlanOptionOrange = 2762,         //Orange
    MealPlanOptionGold = 1400,           //Gold
    MealPlanOptionSilver = 1000,         //Silver
    MealPlanOptionBronze = 550,          //Bronze
    MealPlanOptionBrown = 2000,          //Brown
    MealPlanOptionCustom = -1,           //Custom Meal Plan
    MealPlanOptionUnknown = NSIntegerMax //Something went wrong
};

@protocol DiningTrackerDelegate<NSObject>
///called when labels need to be updated
-(void)updateLabels;
@end

@interface DiningTracker : NSObject
#pragma mark: Class methods
///converts an index into a mealplan
+(MealPlanOption)getMealPlanFromIndex:(int)index;
///get a string representation of a passed in meal plan
+(int)indexOfMealPlan:(MealPlanOption)plan;

#pragma mark: Class properties
///returns the list of all possible meal plans
@property (class, nonatomic, assign, readonly) NSArray<NSString *> *MealPlans;

#pragma mark: Instance methods
///constructor
-(instancetype)initWithSemesterBeginDate:(NSDate *)semesterBeginDate endDate:(NSDate *)endDate;
///recalculate all of the dates in the object
-(void)updateDates;


#pragma mark: Instance properties

///returns the title of the current meal plan
@property (nonatomic, readonly, getter=currentMealPlanTitle) NSString *title;

///returns a value between 0 and 1 representing how far into the semester we are
@property (nonatomic, readonly, getter=semesterPercent) double semesterPercent;
///gets the number of days remaining in the semester
@property (nonatomic, readonly, getter=daysRemaining) long daysRemaining;

///the user's current meal plan
@property (nonatomic, getter=getCurrentMealPlan, setter=setCurrentMealPlan:) MealPlanOption currentMealPlan;
///the user's current dining balance
@property (nonatomic, getter=getCurrentDiningBalance, setter=setCurrentDiningBalance:) double diningBalance;
///returns the value of the current meal plan
@property (nonatomic, readonly, getter=mealPlanValue) double mealPlanValue;
///returns the amount the user has spent
@property (nonatomic, readonly, getter=totalSpent) double totalSpent;
///returns the amount the user should have spent at this point in the semester
@property (nonatomic, readonly, getter=shouldHaveSpent) double shouldHaveSpent;
///returns the amount the user should have left at this point in the semester
@property (nonatomic, readonly, getter=shouldHaveLeft) double shouldHaveLeft;
///returns a value between 0 and 1 representing a percentage of how much the user has spent of their meal plan value
@property (nonatomic, readonly, getter=planProgressValue) double planProgressValue;
///returns a dollar value of how much the user has over or under spent by
@property (nonatomic, readonly, getter=overSpent) double overSpent;
///returns a dollar value of how much the user can spend per day for the rest of the semester to still be on track
@property (nonatomic, readonly, getter=leftPerDay) double leftPerDay;
///returns a dollar value of how much the user's plan calls for them to spend per day
@property (nonatomic, readonly, getter=planPerDay) double planPerDay;
///the days off that the user has specified
@property (strong, nonatomic, getter=getDaysOff, setter=setDaysOff:) NSArray <NSDate *> *daysOff;
///Custom meal plan value
@property (nonatomic, assign, setter=setCustomMealPlanValue:) double customMealPlanValue;

///to be used for the future apple watch app
@property (strong, nonatomic) WCSession *watchSession;

//the delegate class that will be called when labels need to be updated
@property (nonatomic, weak) id<DiningTrackerDelegate> delegate;

@end
