//
//  InterfaceController.m
//  Dining Tracker Watch Extension
//
//  Created by Alex Taffe on 9/19/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

#import "InterfaceController.h"
#import "PriceGroup.h"
#import "DiningTracker.h"
@import WatchConnectivity;

@interface InterfaceController ()<WCSessionDelegate>
@property (strong, nonatomic) IBOutlet WKInterfaceTable *tableView;
@property (strong, nonatomic) NSArray<NSString *> *titleLabels;
@property (strong, nonatomic) DiningTracker *tracker;
@property (strong, nonatomic) WCSession *watchSession;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
    self.titleLabels = @[@"Total Spent", @"Should have spent", @"Should have left", @"Under-spent by", @"Left per Day", @"Plan per Day"];
    //apple watch
    if([WCSession isSupported]){
        self.watchSession = [WCSession defaultSession];
        self.watchSession.delegate = self;
        [self.watchSession activateSession];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    
    
    [self.tableView setNumberOfRows:5 withRowType:@"priceRow"];
    for(int i = 0; i < self.tableView.numberOfRows; i++){
        PriceGroup *group = [self.tableView rowControllerAtIndex:i];
        if(i == 0)
            [group.titleLabel setText:[[NSString alloc] initWithFormat:@"$%0.2f", self.tracker.shouldHaveSpent]];
        else
            [group.titleLabel setText:self.titleLabels[i]];
    }
    /*
    for index in 0..<flightsTable.numberOfRows {
        if let controller = flightsTable.rowControllerAtIndex(index) as? FlightRowController {
            controller.flight = flights[index]
        }
    }*/
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext{
    NSString *message = applicationContext[@"Message"];
    NSLog(@"%@",message);
}

- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    
}


@end



