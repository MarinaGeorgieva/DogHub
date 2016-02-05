//
//  PlaceCell.h
//  DogHub
//
//  Created by Emil Iliev on 2/5/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end
