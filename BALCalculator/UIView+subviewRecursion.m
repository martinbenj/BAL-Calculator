//
//  UIView+subviewRecursion.m
//  SaltyGiraffe
//
//  Created by Benjamin Martin on 6/24/13.
//  Copyright (c) 2013 Benjamin Martin. All rights reserved.
//

#import "UIView+subviewRecursion.h"

@implementation UIView (subviewRecursion)

- (NSMutableArray *) returnAllSubviews {
    
    NSMutableArray *subviews = [[NSMutableArray alloc] init];
    [subviews addObject:self];
    
    for (UIView *subview in self.subviews) {

        [subviews addObjectsFromArray:(NSArray *)[subview returnAllSubviews]];
    }
    
    return subviews;
}


@end
