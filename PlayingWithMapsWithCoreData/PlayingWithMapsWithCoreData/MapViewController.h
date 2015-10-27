//
//  ViewController.h
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 3/13/15.
//  Copyright (c) 2015 Thomas Prezioso. All rights reserved.
//

#import "TPAnnotation.h"
#import "TPLocationDataStore.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic)TPLocationDataStore *store;


@end

