//
//  ViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/1/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "ViewController.h"
#import "HomewViewController.h"
#import <Parse.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    NSString* username = self.username.text;
    NSString* password = self.password.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            // Do stuff after successful login.
            HomewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        } else {
            // The login failed. Check error to see why.
        }
    }];
}

@end
