//
//  DiningTracker.h
//  Dining Tracker
//
//  Created by Alex Taffe on 9/19/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

@import Foundation;

//Meal plan options
typedef NS_ENUM(NSUInteger, MealPlanOption) {
    MealPlanOptionTiger20 = 325,
    MealPlanOptionTiger14 = 525,
    MealPlanOptionTiger10 = 725,
    MealPlanOptionTiger5 = 1325,
    MealPlanOptionOrange = 2762,
    MealPlanOptionGold = 1400,
    MealPlanOptionSilver = 1000,
    MealPlanOptionBronze = 550,
    MealPlanOptionBrown = 2000,
    MealPlanOptionUnknown = NSUIntegerMax
};

@interface DiningTracker : NSObject
#pragma mark: Class methods
+(MealPlanOption)getMealPlanFromIndex:(int)index;
+(NSString *)getTitleForMealPlan:(MealPlanOption)plan;
+(int)indexOfMealPlan:(MealPlanOption)plan;

#pragma mark: Class properties
@property (class, nonatomic, assign, readonly) NSArray<NSString *> *MealPlans;

#pragma mark: Instance methods
-(instancetype)initWithSemesterBeginDate:(NSDate *)semesterBeginDate endDate:(NSDate *)endDate;
-(void)updateDates;

#pragma mark: Instance properties

@property (nonatomic, readonly, getter=semesterPercent) double semesterPercent;
@property (nonatomic, readonly, getter=daysRemaining) long daysRemaining;

@property (nonatomic, getter=getCurrentMealPlan, setter=setCurrentMealPlan:) MealPlanOption currentMealPlan;
@property (nonatomic, getter=getCurrentDiningBalance, setter=setCurrentDiningBalance:) double diningBalance;
@property (nonatomic, readonly, getter=mealPlanValue) double mealPlanValue;
@property (nonatomic, readonly, getter=totalSpent) double totalSpent;
@property (nonatomic, readonly, getter=shouldHaveSpent) double shouldHaveSpent;
@property (nonatomic, readonly, getter=shouldHaveLeft) double shouldHaveLeft;
@property (nonatomic, readonly, getter=planProgressValue) double planProgressValue;
@property (nonatomic, readonly, getter=overSpent) double overSpent;
@property (nonatomic, readonly, getter=leftPerDay) double leftPerDay;
@property (nonatomic, readonly, getter=planPerDay) double planPerDay;

@end
