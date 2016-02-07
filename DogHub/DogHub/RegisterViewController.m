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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation RegisterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initCustomFields];
    
    self.navigationController.navigationBar.hidden = NO;
    self.indicator.hidden = YES;
}

- (IBAction)register:(id)sender {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    UIAlertController *alertController = nil;
    UIAlertAction *alertAction = nil;
    
    PFUser *user = [PFUser user];
    
    if ([self.usernameField.textField.text length] >= 5) {
        user.username = self.usernameField.textField.text;
    }
    else {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username must be atleast 5 characters" preferredStyle:UIAlertControllerStyleAlert];
        alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ([self.passwordField.textField.text length] < 5) {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password must be atleast 5 characters" preferredStyle:UIAlertControllerStyleAlert];
        alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];

        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if ([self.passwordField.textField.text isEqualToString:self.confirmPasswordField.textField.text]) {
       user.password = self.passwordField.textField.text;
    }
    else {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password and Confirm Password do not match" preferredStyle:UIAlertControllerStyleAlert];
        alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];

        [self presentViewController:alertController animated:YES completion:nil];
        return;
 
    }
    
    if ([self.emailField.textField.text length] == 0) {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid e-mail" preferredStyle:UIAlertControllerStyleAlert];
        alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];

        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    user.email = self.emailField.textField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        if (!error) {   // Hooray! Let them use the app now.
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
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
