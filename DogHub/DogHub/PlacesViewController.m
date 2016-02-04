//
//  HomewViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/3/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "AddPlaceViewController.h"
#import "PlacesViewController.h"
#import "PlaceDetailsViewController.h"
#import "Place.h"
#import <Parse/Parse.h>

@implementation PlacesViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self getAllPlaces];
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAdd)];
    self.navigationItem.rightBarButtonItem = addBarButton;
}

- (void)getAllPlaces {
    PFQuery *query = [Place query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.places = [NSArray arrayWithArray:objects];
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"PlaceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell =  [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    
    cell.textLabel.text = [[self.places objectAtIndex:indexPath.row] name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Place *place = [self.places objectAtIndex:indexPath.row];
    NSString *storyboardId = @"detailsScene";
    
    PlaceDetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
    detailsViewController.place = place;
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

- (void) showAdd{
    NSString *storyboardId = @"addPlaceScene";
    
    AddPlaceViewController *addPlaceViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
    [self.navigationController pushViewController:addPlaceViewController animated:YES];
}

@end
