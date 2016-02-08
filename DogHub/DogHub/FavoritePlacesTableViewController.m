//
//  FavoritePlacesTableViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/6/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "FavoritePlace.h"
#import "FavoritePlacesTableViewController.h"
#import "PlaceCell.h"

@interface FavoritePlacesTableViewController ()

@end

@implementation FavoritePlacesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Favorites";
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = delegate.managedObjectContext;
    
    NSError *err = nil;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FavoritePlace"];
    NSArray* fetchedPlaces = [managedObjectContext executeFetchRequest:fetchRequest error:&err];
    
    self.favoritePlaces = [NSMutableArray arrayWithArray:fetchedPlaces];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoritePlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PlaceCell";
    
    PlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PlaceCell" owner:self options:nil] objectAtIndex:0];
    }
    
    PFFile *imageFile = [PFFile fileWithName:@"jdhs.png" data:[[self.favoritePlaces objectAtIndex:indexPath.row] img]];
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.imgView.image = image;
        }
    }];
    
    cell.imgView.layer.cornerRadius = 20;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.layer.borderColor = [UIColor redColor].CGColor;
    cell.nameLabel.text = [[self.favoritePlaces objectAtIndex:indexPath.row] name];
    cell.categoryLabel.text = [[self.favoritePlaces objectAtIndex:indexPath.row] category];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *managedObjectContext = delegate.managedObjectContext;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [managedObjectContext deleteObject:[self.favoritePlaces objectAtIndex:indexPath.row]];
        [tableView reloadData]; // tell table to refresh now
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    UITableView* tableView = self.view.subviews[0];
    [tableView setEditing:editing animated:animated];
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
