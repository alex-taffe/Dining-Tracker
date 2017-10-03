//
//  PriceGroup.h
//  Dining Tracker Watch Extension
//
//  Created by Alex Taffe on 9/20/17.
//  Copyright © 2017 Alex Taffe. All rights reserved.
//

@import WatchKit;

@interface PriceGroup : NSObject
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *valueLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *titleLabel;

@end
