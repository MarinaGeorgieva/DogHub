//
//  PlaceDetailsViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/4/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "FavoritePlace.h"
#import "PlaceDetailsViewController.h"
#import "DogHub-Swift.h"

@interface PlaceDetailsViewController()
{
    BOOL _isFavorite;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation PlaceDetailsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.title = self.place.name;
    self.nameLabel.text = self.place.name;
    self.categoryLabel.text = self.place.category;
    self.descriptionTextView.text = self.place.desc;
    [self.place.img getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageView.image = image;
        }
    }];

    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 160);
    
    _isFavorite = NO;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addToFavorites:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.heartImageView addGestureRecognizer:doubleTap];
}

- (void)addToFavorites:(UILongPressGestureRecognizer *) sender{
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = delegate.managedObjectContext;
    
    NSError *err = nil;

    if (!_isFavorite) {
        _isFavorite = YES;
        self.heartImageView.image = [UIImage imageNamed:@"filledHeart"];
        
        FavoritePlace *favoritePlace = [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace" inManagedObjectContext:managedObjectContext];
        favoritePlace.name = self.place.name;
        favoritePlace.category = self.place.category;
        favoritePlace.desc = self.place.desc;
        favoritePlace.img = UIImagePNGRepresentation(self.imageView.image);
        
        BOOL isOK  = [managedObjectContext save:&err];
        if(!isOK){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[err localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@ added to Favorites", self.place.name] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else {
        _isFavorite = NO;
        self.heartImageView.image = [UIImage imageNamed:@"emptyHeart"];
        
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FavoritePlace"];
        [fetchRequest setFetchLimit:1];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@", self.place.name]];
        NSArray* fetchedPlaces = [managedObjectContext executeFetchRequest:fetchRequest error:&err];
        
        [managedObjectContext deleteObject: [fetchedPlaces objectAtIndex:0]];
        
        BOOL isOK  = [managedObjectContext save:&err];
        if(!isOK){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[err localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@ Removed from Favorites", self.place.name] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PlaceDirectionsViewController *directionsViewController = [segue destinationViewController];
    directionsViewController.pl
}
*/

- (IBAction)getLocation:(id)sender {
    CLLocationCoordinate2D myCoordinate = {self.place.location.latitude, self.place.location.longitude};
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = myCoordinate;
    
    //Drop pin on map
    [self.mapView addAnnotation:point];
}

@end
