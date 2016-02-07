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

@interface PlaceDetailsViewController()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;

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
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addToFavorites:)];
    longPress.minimumPressDuration = 1;
    [self.heartImageView addGestureRecognizer:longPress];
}

/*- (IBAction)addToFavorites:(id)sender {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.favoritePlaces addObject:self.place];
}
*/

- (void)addToFavorites:(UILongPressGestureRecognizer *) sender{
    NSLog(@"Long press");
    self.heartImageView.image = [UIImage imageNamed:@"filledHeart"];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = delegate.managedObjectContext;
    
    FavoritePlace *favoritePlace = [NSEntityDescription insertNewObjectForEntityForName:@"FavoritePlace" inManagedObjectContext:managedObjectContext];
    favoritePlace.name = self.place.name;
    favoritePlace.category = self.place.category;
    favoritePlace.desc = self.place.desc;
    favoritePlace.img = UIImagePNGRepresentation(self.imageView.image);
    
    NSError *err = nil;
    
    BOOL isOK  = [managedObjectContext save:&err];
    if(!isOK){
        
        NSLog(@"%@", [err localizedDescription]);
    }
    else {
        NSLog(@"Saved");
    }
}

@end
