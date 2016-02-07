//
//  PlaceDetailsViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/4/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "AppDelegate.h"
#import "PlaceDetailsViewController.h"

@interface PlaceDetailsViewController()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PlaceDetailsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
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
}

- (IBAction)addToFavorites:(id)sender {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.favoritePlaces addObject:self.place];
}

@end
