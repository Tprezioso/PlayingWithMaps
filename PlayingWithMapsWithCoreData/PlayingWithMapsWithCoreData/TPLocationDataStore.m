//
//  TPLocationDataStore.m
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 10/20/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "TPLocationDataStore.h"

@implementation TPLocationDataStore

+ (instancetype)sharedLocationsDataStore
{
    static TPLocationDataStore *_sharedLocationsDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationsDataStore = [[TPLocationDataStore alloc] init];
    });
    
    return _sharedLocationsDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locations = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
