//
//  Person.h
//  SaltyGiraffe
//
//  Created by Benjamin Martin on 6/6/13.
//  Copyright (c) 2013 Benjamin Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Person : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIPickerViewAccessibilityDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *numberOfDrinks;
@property (weak, nonatomic) IBOutlet UITextField *drinkingDuration;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (strong, nonatomic) UIPickerView *genderPicker;
@property (strong, nonatomic) NSArray *genderArray;
@property (strong, nonatomic) UITextField *activeTextField;
@property (strong, nonatomic) NSString *currentFieldData;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSDictionary *BALByCountry;
@property (strong, nonatomic) NSString *currentCountry;

@property (nonatomic) float BALforCountry;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextView *BALDisplay;





@property (nonatomic, strong) UIView *inputAccView;
@property (nonatomic, strong) UITextField *txtActiveField;
@property (nonatomic, strong) UIButton *doneButton;



- (IBAction)calculateBAL:(id)sender;




@end