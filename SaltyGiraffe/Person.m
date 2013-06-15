//
//  Person.m
//  SaltyGiraffe
//
//  Created by Benjamin Martin on 6/6/13.
//  Copyright (c) 2013 Benjamin Martin. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set delegates of the text fields.
    self.weight.delegate = self;
    self.numberOfDrinks.delegate = self;
    self.drinkingDuration.delegate = self;
    self.gender.delegate = self;

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
}

#pragma mark - keyboard manipulation methods

- (void) cancelKeyboard: (UITextField *) textField {
    
    // Undo any changes that were made and dismiss the keyboard.
    self.activeTextField.text = self.currentFieldData;
    [self.activeTextField resignFirstResponder];
}

- (void) doneWithKeyboard: (UITextField *) textField {

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
    
    // Create the toolbar with "cancel" and "done" buttons to be used as an inputAccessoryView.
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle   = UIBarStyleBlackTranslucent;
    doneToolbar.items      = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelKeyboard:)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyboard:)],
                         nil];
    
    // Make sure the toolbar fits properly and set it as an accessory view.
    [doneToolbar sizeToFit];
    textField.inputAccessoryView = doneToolbar;
}


- (IBAction)calculateBAL:(id)sender {
 
    // Ensure all text fields have been filled out.
    // Need to get subviews of the scroll view. The scroll view is the only child of the main view. All views within the scroll view are grandchildren or deeper of the main view. [view subviews] only gives children, not grandchildren and deeper.
    for (UIView* subview in [self.scrollView subviews]) {
        if ([subview isKindOfClass:[UITextField class]]) {
            if ([(UITextField *)subview text].length == 0) {
                
                self.BALDisplay.text = @"Please fill out all of the above fields.";
                
                [self.scrollView scrollRectToVisible:CGRectMake(0, self.scrollView.frame.size.height/2, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
                
                return;
            }
        }
    }
    
    // If the gender field contains "Male", make the Widmark constant 0.68. Else the field contains "Female", and make the constant 0.55.
    float widmarkConstant = ([self.gender.text isEqualToString:@"Male"]) ? 0.68 : 0.55;
    
    // Widmark formula for calculating BAL.
    float bloodAlcoholContent = (self.numberOfDrinks.text.intValue * 6 * (1.055/self.weight.text.intValue)*widmarkConstant) - (0.015 * self.drinkingDuration.text.intValue);
    
    // Ensure a negative BAL is never displayed.
    if (bloodAlcoholContent < 0) {
        self.BALDisplay.text = @"Congrats! You have been drinking long enough that all alcohol has cleared from your system.";
    }
    else {
        self.BALDisplay.text = [NSString stringWithFormat:@"Your blood alcohol level is %.03f.", bloodAlcoholContent];
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


@end
