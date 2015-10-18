//
//  ImageViewController.m
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 10/16/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *pictureImage;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pictureImage.image = self.detailedImage;
}

@end
