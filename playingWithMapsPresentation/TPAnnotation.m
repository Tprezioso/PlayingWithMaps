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
@synthesize image;


- (instancetype)initWithTitle:(NSString*)pinTitle subtitle:(NSString*)pinSubtitle pinCoordinates:(CLLocationCoordinate2D)pinCoordinate image:(UIImage*)pinImage
{
    if (self = [super init]) {
        pinTitle = title;
        pinSubtitle = subtitle;
        pinCoordinate = coordinate;
        pinImage = image;
    }
    return self;
}

- (NSMutableArray *)presetPins
{
    TPAnnotation *kissenaPrakPin = [[TPAnnotation alloc]init];
    kissenaPrakPin.coordinate = CLLocationCoordinate2DMake(40.745184, -73.806207);
    kissenaPrakPin.title = @"Kissena Park";
    kissenaPrakPin.subtitle = @"Park in Flushing Queens";
    kissenaPrakPin.image = [UIImage imageNamed:@"kissenaParkExit.jpg"];
    
    TPAnnotation *flushingMeadowsPark = [[TPAnnotation alloc] init];
    flushingMeadowsPark.coordinate = CLLocationCoordinate2DMake(40.740385, -73.840322);
    flushingMeadowsPark.title = @"Flushing Meadows Park";
    flushingMeadowsPark.subtitle = @"Former location of worlds Fair and Location formally know as the valley of ashes made famous in the book 'The Grest gatsby'";
    flushingMeadowsPark.image = [UIImage imageNamed:@"flushingMeadowsPark.jpeg"];
    
    NSMutableArray *presetPinsArray = [[NSMutableArray alloc]initWithObjects:flushingMeadowsPark, kissenaPrakPin, nil];
    return presetPinsArray;
}

@end
