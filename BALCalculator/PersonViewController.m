//
//  Person.m
//  SaltyGiraffe
//
//  Created by Benjamin Martin on 6/6/13.
//  Copyright (c) 2013 Benjamin Martin. All rights reserved.
//

#import "PersonViewController.h"
#import "UIView+subviewRecursion.h"
#import "UITextField+minMaxValues.h"

@interface Person()

@property (nonatomic, strong) NSArray *jumpArray;

@end

@implementation Person

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
    
    [self.view addGestureRecognizer:dismissKeyboard];

    // Set delegates of the text fields.
    self.weight.delegate = self;
    self.numberOfDrinks.delegate = self;
    self.drinkingDuration.delegate = self;
    self.gender.delegate = self;
    
    self.weight.minValue = [NSNumber numberWithInt:80];
    self.weight.maxValue = [NSNumber numberWithInt:300];
    
    self.numberOfDrinks.minValue = [NSNumber numberWithInt:1];
    self.numberOfDrinks.maxValue = [NSNumber numberWithInt:10];
    
    self.drinkingDuration.minValue = [NSNumber numberWithInt:0];
    self.drinkingDuration.maxValue = [NSNumber numberWithInt:24];
    

    // Allocate, initialize, and set the delegate/data source of the gender picker.
    // showSelectionIndicator highlights the current selection in a picker view. Hard to know what you're selecting without it.
    self.genderPicker = [[UIPickerView alloc]init];
    self.genderPicker.delegate = self;
    self.genderPicker.dataSource = self;
    self.genderPicker.showsSelectionIndicator = YES;
    
    // The array with the data for the picker view. It populates the picker in the picker delegate method - (NSString *)pickerView...
    self.genderArray = [[NSArray alloc] initWithObjects:@"Male", @"Female",nil];
    
    // Set the size of the scroll view to an arbitrarily large size to make sure it actually scrolls.
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    
    // Make the keyboard of the gender text field to instead be a picker view.
    self.gender.inputView = self.genderPicker;
    
    [self startLocationManager];
    
}




#pragma mark - keyboard manipulation methods

- (void) cancelKeyboard
{
    // Undo any changes that were made and dismiss the keyboard.
    self.activeTextField.text = self.currentFieldData;
    [self.activeTextField resignFirstResponder];
}

- (void) doneWithKeyboard: (UITextField *) textField {
    
    // Added a category of UITextField that implemented the hasCorrectInput method.
    if ([self.activeTextField hasCorrectInput:self.activeTextField.text.intValue]) {
        NSLog(@"%@", @"hi");
    
    }
    
    else {
        
        NSString * alertString = [NSString stringWithFormat:@"Please enter a value between %@ and %@", self.activeTextField.minValue, self.activeTextField.maxValue];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [alert show];
        
        self.activeTextField.text = @"";

    }
    
        

    // A check for the gender text field. This text field is the only one whose inputView property was set.
    if ([self.activeTextField.inputView description] != nil) {
        
        // Set the text of the gender text field.
        NSInteger row = [self.genderPicker selectedRowInComponent:0];
        self.activeTextField.text = [self.genderArray objectAtIndex:row];
    }

    // A more abstracted way of saying [self.activeTextField resignFirstResponder] - this is a message sent to the view rather than to the active text field within the view.
    [self.view endEditing:TRUE];
}

// UITextField Delegate Method
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    // Set the active text field and the content within that text field for
    // manipulation within cancelKeyboard and doneWithKeyboard.
    self.activeTextField  = textField;
    self.currentFieldData = textField.text;
    
    self.jumpArray = @[self.weight, self.numberOfDrinks, self.drinkingDuration, self.gender];
    
    // Create the toolbar with "cancel" and "done" buttons to be used as an inputAccessoryView.
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle   = UIBarStyleBlackTranslucent;
    doneToolbar.items      = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelKeyboard)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyboard:)],
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextTextField)],
                         nil];
    
    // Make sure the toolbar fits properly and set it as an accessory view.
    [doneToolbar sizeToFit];
    textField.inputAccessoryView = doneToolbar;
}

- (void) nextTextField
{
    self.activeTextField = [self.jumpArray objectAtIndex:(self.activeTextField.tag+1)%4];
    
    [self.activeTextField becomeFirstResponder];
}






# pragma mark - IBAction

- (IBAction)calculateBAL:(id)sender {
 
    // Ensure all text fields have been filled out.
    for (UIView *subview in [self.view returnAllSubviews]) {

        if ([subview isKindOfClass:[UITextField class]]) {
            
            if ([(UITextField *)subview text].length == 0) {
                
                self.BALDisplay.text = @"Please fill out all of the above fields.";
                
                [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.frame.size.height/2, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
                
                return;
            }
        }
    }
    
    // Also do error checking for the fields. You'll want to check this when a field is left. (firstResponder didResign)
    
    // If the gender field contains "Male", make the Widmark constant 0.55. Else the field contains "Female", and make the constant 0.68. For a given male and female of the same weight, a female will generally have to drink less to achieve the same BAL. This is because women tend to have higher body fat percentages and alcohol cannot be stored in fat. The alcohol is therefore concentrated more heavily in the blood.
    float widmarkConstant = ([self.gender.text isEqualToString:@"Male"]) ? 0.55 : 0.68;
    
    // Widmark formula for calculating BAL.
    float bloodAlcoholContent = (self.numberOfDrinks.text.intValue * 6 * (1.055/self.weight.text.intValue)*widmarkConstant) - (0.015 * self.drinkingDuration.text.intValue);
    
    // Ensure a negative BAL is never displayed.
    if (bloodAlcoholContent < 0) {
        self.BALDisplay.text = @"Congrats! You have been drinking long enough that all alcohol has cleared from your system.";
    }
    else {
        
        [self compareBAL:bloodAlcoholContent];
        
        
        if ([self.currentCountry isEqualToString:@"United States"]) {
            self.currentCountry = @"the United States";
        }
        
        
        if (bloodAlcoholContent > self.BALforCountry) {
            self.BALDisplay.text = [NSString stringWithFormat:@"Your blood alcohol level is %.03f. You are over the legal limit of %.02f for %@.", bloodAlcoholContent, self.BALforCountry, self.currentCountry];
        }
        
        else {
        
            self.BALDisplay.text = [NSString stringWithFormat:@"Your blood alcohol level is %.03f. You are under the legal limit of %.03f for %@.", bloodAlcoholContent, self.BALforCountry, self.currentCountry];
            
        }
        
        
        if ([self.currentCountry isEqualToString:@"the United States"]) {
            self.currentCountry = @"United States";
        }
    }
    
    // Scroll down to where the BAL is displayed when the "Calculate BAL" button is pressed.
    [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.frame.size.height/2, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
   

    
}

#pragma mark - UIPickerView Delegate Methods for genderPicker

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.genderArray objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.genderArray count];
}


// Customize the text in the genderPicker UIPickerView (mainly used for centering the text).
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
    label.text = [self.genderArray objectAtIndex:row];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - Location Manager

- (void) startLocationManager {
 
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.distanceFilter = 1000;
        self.locationManager.purpose = @"We would like to determine the blood alcohol limit of your country.";
        self.locationManager.delegate = self;
    }
    
    [self.locationManager startMonitoringSignificantLocationChanges];
    
    
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *obj = [locations lastObject];
    
//    NSLog(@"Latitude %+.6f, longitude%+.6f accuracy %1.2f time %d", obj.coordinate.latitude, obj.coordinate.latitude, obj.horizontalAccuracy, abs([obj.timestamp timeIntervalSinceNow]));
    
    [self reverseGeocode:obj];

    NSTimeInterval locationAge = -[obj.timestamp timeIntervalSinceNow];
    if (locationAge < 10) return;
    
    if ( obj.horizontalAccuracy < 0 ) return;
    
    if ( self.currentLocation == nil && obj.horizontalAccuracy <= self.locationManager.desiredAccuracy ) {
        
        self.currentLocation = obj;
        
        [self stopLocationManager];
        
    }
    
    
    
    
}

// If they reject using location, then ask them what country they are in from a picker and send that data to compareBAL method.
- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    
    if ( [error code] != kCLErrorLocationUnknown)
        [self stopLocationManager];
    
}

- (void) stopLocationManager {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Reverse Geocoding

- (void) reverseGeocode: (CLLocation *) location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
       
        if ( error ) {
            NSLog(@"Reverse geocode failed with %@", error);
        }
        if ( placemarks ) {
            CLPlacemark * placemark = [placemarks lastObject];
            
                self.currentCountry = [NSString stringWithFormat:@"%@", placemark.country];
            
            
        }
        
    }];
}

- (void) compareBAL: (float) BAL {
    
    NSLog(@"%f", BAL);
    
    if ( !self.BALByCountry ) {
        self.BALByCountry = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"0.08",  @"United States",
                             @"0.08",         @"Canada",
                             @"0.04",         @"Mexico",
                             @"0.08",        @"England",
                             @"0.05",        @"Germany",
                             @"0.05",         @"France",
                             @"0.05",          @"Spain",
                             @"0.08",    @"Puerto Rico",
                             @"0.05",      @"Argentina",
                             @"0.02",         @"Sweden",
                             @"0.00",         @"Brazil",
                             nil];
    }
    
//    NSLog(@"%@, ....., %@, ...., %d", [self.BALByCountry objectForKey:@"United States"], [[self.BALByCountry objectForKey:@"United States" ] class], self.BALByCountry.count);

//    for (id key in self.BALByCountry) {
//        NSLog(@"key: %@, value: %@", key, [self.BALByCountry objectForKey:key]);
//    }
    
    self.BALforCountry = [[self.BALByCountry objectForKey:self.currentCountry] floatValue];
    
//    NSLog(@"Object for current country: %@", [self.BALByCountry objectForKey:self.currentCountry]);

    
//    NSArray *arr = [self.BALByCountry objectForKey:@"0.08"];
//    
//    NSLog(@"%@,   %@", arr[0], arr[1]);
    
}


@end
