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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCustomFields];
    self.indicator.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    NSString *username = self.usernameField.textField.text;
    NSString *password = self.passwordField.textField.text;
    [PFUser logInWithUsernameInBackground: username password: password block:^(PFUser *user, NSError *error) {
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
        
        if (user) {
            UITabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
            
            [self presentViewController:tabBarController animated:YES completion:nil];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
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

-(IBAction)unwind:(UIStoryboardSegue *)segue{
    
}

@end
