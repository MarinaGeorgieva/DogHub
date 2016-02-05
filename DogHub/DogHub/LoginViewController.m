//
//  ViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/1/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "LoginViewController.h"
#import "PlacesTableViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    [PFUser logInWithUsernameInBackground: username password: password block:^(PFUser *user, NSError *error) {
        if (user) {
            // Do stuff after successful login.
            //PlacesTableViewController *placesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"allPlacesScene"];
            //[self.navigationController pushViewController:placesViewController animated:YES];
        }
        else {
            // The login failed. Check error to see why.
        }
    }];
}

@end
