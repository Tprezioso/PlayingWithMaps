//
//  CoreDataHelper.h
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 10/23/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong,nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSPersistentStore *store;
@property (strong,nonatomic) NSPersistentStoreCoordinator *coordinator;

@end
