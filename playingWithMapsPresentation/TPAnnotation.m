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

- (instancetype)initWithTitle:(NSString*)pinTitle subtitle:(NSString*)pinSubtitle coordinates:(CLLocationCoordinate2D)pinCoordinates
{
    if (self = [super init]) {
        self.title = pinTitle;
        self.subtitle = pinSubtitle;
        self.coordinate = pinCoordinates;
        
    }
    return self;
}

+ (TPAnnotation*)setPreloadedPins
{
    TPAnnotation *addedPinOnLoad = [[TPAnnotation alloc]initWithTitle: @"Kissena Park"
                                                             subtitle:@"Former loaction of worlds Fair and Loaction formally know as the valley of ashes made famous in the book 'The Grest gatsby'"
                                                          coordinates:CLLocationCoordinate2DMake(40.745184, -73.806207)];
    return addedPinOnLoad;
//    addedPinOnLoad.coordinate = CLLocationCoordinate2DMake(40.745184, -73.806207);
//    addedPinOnLoad.title = @"Kissena Park";
//    addedPinOnLoad.subtitle = @"Former loaction of worlds Fair and Loaction formally know as the valley of ashes made famous in the book 'The Grest gatsby'";
}

@end
