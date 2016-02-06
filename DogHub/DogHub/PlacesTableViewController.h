//
//  HomewViewController.h
//  DogHub
//
//  Created by Emil Iliev on 2/3/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesTableViewController : UITableViewController<UISearchBarDelegate>

@property NSMutableArray *places;
@property NSMutableArray *filteredPlaces;

@end
