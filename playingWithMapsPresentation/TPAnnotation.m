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

- (NSArray *)presetPins
{
    TPAnnotation *kissenaPrakPin = [[TPAnnotation alloc]init];
    kissenaPrakPin.coordinate = CLLocationCoordinate2DMake(40.745184, -73.806207);
    kissenaPrakPin.title = @"Kissena Park";
    kissenaPrakPin.subtitle = @"Park in Flushing Queens";
    
    TPAnnotation *flushingMeadowsPark = [[TPAnnotation alloc] init];
    flushingMeadowsPark.coordinate = CLLocationCoordinate2DMake(40.740385, -73.840322);
    flushingMeadowsPark.title = @"Flushing Meadows Park";
    flushingMeadowsPark.subtitle = @"Former location of worlds Fair and Location formally know as the valley of ashes made famous in the book 'The Grest gatsby'";
    NSArray *presetPinsArray = @[kissenaPrakPin, flushingMeadowsPark];
    return presetPinsArray;

}

@end
