//
//  FavoritePlace+CoreDataProperties.h
//  
//
//  Created by Emil Iliev on 2/7/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FavoritePlace.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoritePlace (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSData *img;

@end

NS_ASSUME_NONNULL_END
