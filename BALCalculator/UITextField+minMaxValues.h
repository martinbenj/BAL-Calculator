//
//  UITextField+minMaxValues.h
//  SaltyGiraffe
//
//  Created by Benjamin Martin on 6/24/13.
//  Copyright (c) 2013 Benjamin Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (minMaxValues)

@property (nonatomic) NSNumber *minValue;
@property (nonatomic) NSNumber *maxValue;

- (BOOL) hasCorrectInput : (NSUInteger) currentValue;

- (NSNumber *) minValue;
- (void) setMinValue;

- (NSNumber *) maxValue;
- (void) setMaxValue;

@end
