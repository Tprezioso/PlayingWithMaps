//
//  Locations+CoreDataProperties.h
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 10/23/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Locations.h"

NS_ASSUME_NONNULL_BEGIN

@interface Locations (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *subtitle;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *coordinateLat;
@property (nullable, nonatomic, retain) NSNumber *coordinateLon;

@end

NS_ASSUME_NONNULL_END
