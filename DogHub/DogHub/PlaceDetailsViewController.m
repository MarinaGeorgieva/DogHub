//
//  PlaceDetailsViewController.m
//  DogHub
//
//  Created by Emil Iliev on 2/4/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "PlaceDetailsViewController.h"

@interface PlaceDetailsViewController()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation PlaceDetailsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.nameLabel.text = self.place.name;
    self.descriptionLabel.text = self.place.desc;
    self.categoryLabel.text = self.place.category;
}

@end
