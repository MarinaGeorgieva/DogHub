//
//  Place.m
//  DogHub
//
//  Created by Emil Iliev on 2/3/16.
//  Copyright © 2016 Marina Georgieva. All rights reserved.
//

#import "Place.h"

@implementation Place

@dynamic name;
@dynamic desc;
@dynamic category;
@dynamic img;
@dynamic location;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Place";
}

+ (Place *) placeWithName:(NSString *)name
              description:(NSString *)desc
                 category:(NSString *)category
                 location:(PFGeoPoint *)location
                    andImage:(PFFile *)img{
    Place *place = [Place object];
    place.name = name;
    place.desc = desc;
    place.category = category;
    place.location = location;
    place.img = img;
    return place; 
}

@end
