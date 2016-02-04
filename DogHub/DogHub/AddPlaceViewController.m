//
//  AddPlaceViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/4/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import <Parse/Parse.h>
#import "AddPlaceViewController.h"
#import "PlacesViewController.h"
#import "Place.h"

@interface AddPlaceViewController()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@end

@implementation AddPlaceViewController

- (IBAction)add:(id)sender {
    NSString *name = self.nameTextField.text;
    NSString *desc = self.descriptionTextField.text;
    NSString *category = self.categoryTextField.text;
    Place *place = [Place placeWithName:name andWithDescription:desc andWithCategory:category];
    [place saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSString *storyboardId = @"allPlacesScene";
            PlacesViewController *placesViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
            [self.navigationController pushViewController:placesViewController animated:YES];
        }
    }];
}

@end
