//
//  AppDelegate.h
//  Dining Tracker
//
//  Created by Alex Taffe on 9/12/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

