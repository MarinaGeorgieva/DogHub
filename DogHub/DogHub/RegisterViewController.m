//
//  RegisterViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/3/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "CustomTextField.h"
#import <Parse/Parse.h>

@interface RegisterViewController()

@property (weak, nonatomic) IBOutlet CustomTextField *usernameField;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordField;
@property (weak, nonatomic) IBOutlet CustomTextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet CustomTextField *emailField;

@end

@implementation RegisterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initCustomFields];
}

- (IBAction)register:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameField.textField.text;
    if ([self.passwordField.textField.text isEqualToString:self.confirmPasswordField.textField.text]) {
       user.password = self.passwordField.textField.text;
    }
    user.email = self.emailField.textField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
        }
    }];
}

-(void) initCustomFields{
    
    self.usernameField.textField.placeholder = @"Username";
    self.usernameField.iconImageView.image = [UIImage imageNamed:@"userIcon"];
    self.passwordField.textField.placeholder = @"Password";
    self.passwordField.textField.secureTextEntry = YES;
    self.passwordField.iconImageView.image = [UIImage imageNamed:@"passwordIcon"];
    self.confirmPasswordField.textField.placeholder = @"Confirm Password";
    self.confirmPasswordField.textField.secureTextEntry = YES;
    self.confirmPasswordField.iconImageView.image = [UIImage imageNamed:@"passwordIcon"];
    self.emailField.textField.placeholder = @"E-mail";
    [self.emailField.textField setKeyboardType:UIKeyboardTypeEmailAddress];
    self.emailField.iconImageView.image = [UIImage imageNamed:@"mailIcon"];
}

@end
