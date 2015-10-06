//
//  TPAnnotation.h
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 9/10/15.
//  Copyright (c) 2015 Thomas Prezioso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface TPAnnotation : NSObject <MKAnnotation>{
    
    NSString *title;
    NSString *subtitle;
    NSString *note;
    CLLocationCoordinate2D coordinate;
    UIImage *image;
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@property (strong, nonatomic)UIImage *image;

- (instancetype)initWithTitle:(NSString*)pinTitle subtitle:(NSString*)pinSubtitle pinCoordinates:(CLLocationCoordinate2D)pinCoordinate image:(UIImage*)pinImage;
- (NSMutableArray *)presetPins;

@end
