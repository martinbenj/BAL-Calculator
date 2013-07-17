//
//  ViewController.m
//  SaltyGiraffe
//
//  Created by Benjamin Martin on 6/6/13.
//  Copyright (c) 2013 Benjamin Martin. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.BALApp.frame = CGRectMake(100.0, 125.0, 100.0, 100.0);
    
    self.BALApp.layer.cornerRadius = 50;
    
    self.BALApp.layer.borderWidth = 3.0;
    self.BALApp.layer.borderColor = [[UIColor colorWithRed:216.0 green:191.0 blue:216.0 alpha:1.0] CGColor];
    
    
    
    self.BALApp.clipsToBounds = YES;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
