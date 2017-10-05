//
//  AppDelegate.h
//  Dining Tracker
//
//  Created by Alex Taffe on 9/12/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DiningTracker.h"
@import WatchConnectivity;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//current window
@property (strong, nonatomic) UIWindow *window;

//data store container
@property (readonly, strong) NSPersistentContainer *persistentContainer;

//the master DiningTracker object for the app
@property (strong, nonatomic) DiningTracker *tracker;

//the master watch session object for the app, not yet used
@property (strong, nonatomic) WCSession *watchSession;

- (void)saveContext;


@end

