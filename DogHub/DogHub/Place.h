//
//  Place.h
//  DogHub
//
//  Created by Emil Iliev on 2/3/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Place : PFObject<PFSubclassing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) PFFile *img;

+ (NSString *)parseClassName;

+ (Place *) placeWithName: (NSString *) name
       andWithDescription: (NSString *) desc
          andWithCategory: (NSString *) category
             andWithImage: (PFFile *) img;

@end
