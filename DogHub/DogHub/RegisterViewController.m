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
{
    UIAlertController *_alertController;
    UIAlertAction *_alertAction;
}

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
    
    self.indicator.hidden = YES;
}

- (IBAction)register:(id)sender {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    PFUser *user = [PFUser user];
    
    NSString *username = [self.usernameField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *confirmPassword = [self.confirmPasswordField.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([username length] >= 5) {
        user.username = username;
    }
    else {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username must be atleast 5 characters" preferredStyle:UIAlertControllerStyleAlert];
        _alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [_alertController addAction:_alertAction];
        [self presentViewController:_alertController animated:YES completion:nil];
        return;
    }
    
    if ([password length] < 5) {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password must be atleast 5 characters" preferredStyle:UIAlertControllerStyleAlert];
        _alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [_alertController addAction:_alertAction];

        [self presentViewController:_alertController animated:YES completion:nil];
        return;
    }
    
    if ([password isEqualToString:confirmPassword]) {
       user.password = password;
    }
    else {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password and Confirm Password do not match" preferredStyle:UIAlertControllerStyleAlert];
        _alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [_alertController addAction:_alertAction];

        [self presentViewController:_alertController animated:YES completion:nil];
        return;
 
    }
    
    if ([self.emailField.textField.text length] == 0) {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid e-mail" preferredStyle:UIAlertControllerStyleAlert];
        _alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [_alertController addAction:_alertAction];

        [self presentViewController:_alertController animated:YES completion:nil];
        return;
    }
    
    user.email = self.emailField.textField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        if (!error) {
            LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginScene"];
            [self presentViewController:loginViewController animated:YES completion:nil];
            // [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            NSString *errorString = [error userInfo][@"error"];
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
