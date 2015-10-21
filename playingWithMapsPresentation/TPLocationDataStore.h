//
//  TPLocationDataStore.h
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 10/20/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPLocationDataStore : NSObject

@property (strong, nonatomic) NSMutableArray *locations;

+ (instancetype)sharedLocationsDataStore;

@end
