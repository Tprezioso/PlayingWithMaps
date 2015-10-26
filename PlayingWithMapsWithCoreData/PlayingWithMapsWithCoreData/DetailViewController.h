//
//  DetailViewController.h
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 9/23/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPAnnotation.h"

@interface DetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationBarDelegate>

@property (strong, nonatomic) TPAnnotation *detailLocations;

@end
