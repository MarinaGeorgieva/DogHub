//
//  HomewViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/3/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "AddPlaceViewController.h"
#import "PlacesTableViewController.h"
#import "PlaceDetailsViewController.h"
#import "Place.h"
#import "PlaceCell.h"
#import <Parse/Parse.h>

@interface PlacesTableViewController()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation PlacesTableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self getAllPlaces];
    
    self.searchBar.delegate = self;
    
    UIImage *img = [UIImage imageNamed:@"doghub_logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [imgView setImage:img];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imgView;
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAdd)];
    self.navigationItem.rightBarButtonItem = addBarButton;
    
}

- (void)getAllPlaces {
    PFQuery *query = [Place query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            self.places = [NSMutableArray arrayWithArray:objects];
            self.filteredPlaces = [NSMutableArray arrayWithArray:self.places];
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"PlaceCell";
    
    PlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlaceCell" owner:self options:nil] objectAtIndex:0];
    }
    
    PFFile *imageFile = [[self.filteredPlaces objectAtIndex:indexPath.row] img];
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            
            UIImage *image = [UIImage imageWithData:imageData];
            cell.imgView.image = image;
        }
    }];

    cell.imgView.layer.cornerRadius = 20;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.layer.borderColor = [UIColor redColor].CGColor;
    cell.nameLabel.text = [[self.filteredPlaces objectAtIndex:indexPath.row] name];
    cell.categoryLabel.text = [[self.filteredPlaces objectAtIndex:indexPath.row] category];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Place *place = [self.filteredPlaces objectAtIndex:indexPath.row];
    NSString *storyboardId = @"detailsScene";
    
    PlaceDetailsViewController *detailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
    detailsViewController.place = place;
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length] == 0) {
        self.filteredPlaces = self.places;
    }
    else {
        //[self.filteredPlaces removeAllObjects];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
        self.filteredPlaces = [NSMutableArray arrayWithArray:[self.places filteredArrayUsingPredicate:filterPredicate]];
    }
    
    [self.tableView reloadData];
}

- (void)showAdd{
    NSString *storyboardId = @"addPlaceScene";
    
    AddPlaceViewController *addPlaceViewController = [self.storyboard instantiateViewControllerWithIdentifier:storyboardId];
    [self.navigationController pushViewController:addPlaceViewController animated:YES];
}

@end
