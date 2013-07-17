//
//  UITextField+minMaxValues.m
//  SaltyGiraffe
//
//  Created by Benjamin Martin on 6/24/13.
//  Copyright (c) 2013 Benjamin Martin. All rights reserved.
//

#import "UITextField+minMaxValues.h"
#import <objc/runtime.h>

@implementation UITextField (minMaxValues)

@dynamic minValue;
@dynamic maxValue;

static char minKey;
static char maxKey;

- (BOOL) hasCorrectInput: (NSUInteger) currentValue {

    if (currentValue > self.minValue.intValue && currentValue < self.maxValue.intValue) return YES;
    
    else return NO;
}

- (NSNumber *) minValue {
    return objc_getAssociatedObject(self, &minKey);
}

- (void) setMinValue:(NSNumber *)minValue {
    objc_setAssociatedObject(self, &minKey, minValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *) maxValue {
    return objc_getAssociatedObject(self, &maxKey);
}

- (void) setMaxValue:(NSNumber *)maxValue {
    objc_setAssociatedObject(self, &maxKey, maxValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
