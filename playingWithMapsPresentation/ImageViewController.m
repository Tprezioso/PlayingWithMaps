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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pictureImage.image = self.detailedImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
