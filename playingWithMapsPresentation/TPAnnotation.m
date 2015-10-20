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
static NSMutableArray *allPins = nil;
static UITableView *tableView;


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
- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.subtitle forKey:@"subtitle"];
   // [encoder encodeObject:[NSValue valueWithMKCoordinate:self.coordinate] forKey:@"coordinate"];
    //    [encoder encodeDouble:self.coordinate.latitude forKey:@"latCoordinate"];
//    [encoder encodeDouble:self.coordinate.longitude forKey:@"longCoorditnate"];
    //[encoder encodeObject:self.subCategoryName forKey:@"subcategory"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self) {
        //decode properties, other class vars
        self.title = [decoder decodeObjectForKey:@"title"];
        self.subtitle = [decoder decodeObjectForKey:@"subtitle"];
       // self.subCategoryName = [decoder decodeObjectForKey:@"subcategory"];
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
+ (void)savePins:(TPAnnotation *)annotation
{
    //[allPins addObject:annotation];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:annotation];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"allPins"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)loadPins
{
    if (allPins == nil) {
        allPins = [NSMutableArray arrayWithArray:@[]];
    }
    NSData *rawData = [[NSUserDefaults standardUserDefaults] dataForKey:@"allPins"];
    if (rawData == nil) {
        return;
    } else {
    NSArray *allData = [NSKeyedUnarchiver unarchiveObjectWithData:rawData];
    allPins = [NSMutableArray arrayWithArray:allData];

    }
}

+ (void)setTable:(UITableView *)table
{
    tableView = table;
}

+ (NSMutableArray *)getAllPins
{
//    TPAnnotation *testPin = [[TPAnnotation alloc] initWithTitle:@"What" subtitle:@"UP BITCHED" pinCoordinates:CLLocationCoordinate2DMake(40.74038, -73.84032) image:nil];
//    [allPins addObject:testPin];
    return allPins;
}

@end
