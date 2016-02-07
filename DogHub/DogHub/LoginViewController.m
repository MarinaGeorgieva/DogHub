//
//  ViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/1/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "CustomTextField.h"
#import "LoginViewController.h"
#import "PlacesTableViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet CustomTextField *usernameField;
@property (weak, nonatomic) IBOutlet CustomTextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCustomFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    NSString *username = self.usernameField.textField.text;
    NSString *password = self.passwordField.textField.text;
    [PFUser logInWithUsernameInBackground: username password: password block:^(PFUser *user, NSError *error) {
        if (user) {
            // Do stuff after successful login.

            UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
            [self.navigationController pushViewController:tabBarController animated:YES];
            
        }
        else {
            // The login failed. Check error to see why.
        }
    }];
}

-(void) initCustomFields{
    self.usernameField.textField.placeholder = @"Username";
    self.usernameField.iconImageView.image = [UIImage imageNamed:@"userIcon"];
    self.passwordField.textField.placeholder = @"Password";
    self.passwordField.textField.secureTextEntry = YES;
    self.passwordField.iconImageView.image = [UIImage imageNamed:@"passwordIcon"];
}

@end
