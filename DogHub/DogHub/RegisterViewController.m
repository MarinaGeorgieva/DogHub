//
//  RegisterViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/3/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation RegisterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)register:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.username.text;
    if ([self.password.text isEqualToString:self.confirmPassword.text]) {
       user.password = self.password.text;
    }
    user.email = self.email.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
        }
    }];
}

@end
