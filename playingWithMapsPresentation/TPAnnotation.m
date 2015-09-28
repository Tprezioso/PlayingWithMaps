//
//  TPAnnotation.m
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 9/10/15.
//  Copyright (c) 2015 Thomas Prezioso. All rights reserved.
//

#import "TPAnnotation.h"

@implementation TPAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

-(instancetype)init
{
    if (self = [super init]) {
        title = title;
        subtitle = subtitle;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString*)pinTitle subtitle:(NSString*)pinSubtitle pinCoordinates:(CLLocationCoordinate2D)pinCoordinate
{
    if (self = [super init]) {
        pinTitle = title;
        pinSubtitle = subtitle;
        pinCoordinate = coordinate;
    }
    return self;
}

- (void)presetPins
{

}
@end
