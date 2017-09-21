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
@end

@implementation DiningTracker
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
        default:
            return MealPlanOptionUnknown;
            break;
    }
}

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
        case MealPlanOptionUnknown:
            return (int)NSIntegerMax;
            break;
            
        default:
            return (int)NSIntegerMax;
            break;
    }
}



-(instancetype)initWithSemesterBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate{
    self = [super init];
    self.semesterBeginDate = beginDate;
    self.semesterEndDate = endDate;
    
    return self;
}

-(void)updateDates{
    NSDate *currentDate = [NSDate date];
    
    //set up our calendar
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
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
    self.totalDays = [totalComponents day];
    self.currentDays = [currentDateComponents day];
}

-(double)semesterPercent{
    return (double)self.currentDays / (double)self.totalDays;
}

-(double)mealPlanValue{
    return self.currentMealPlan;
}

-(double)totalSpent{
    return self.mealPlanValue - self.diningBalance;
}

-(double)shouldHaveSpent{
    return self.mealPlanValue * self.semesterPercent;
}

-(double)planProgressValue{
    return self.totalSpent / self.mealPlanValue;
}

-(double)overSpent{
    return self.shouldHaveSpent - self.totalSpent;
}

-(long)daysRemaining{
    return self.totalDays - self.currentDays;
}

@end
