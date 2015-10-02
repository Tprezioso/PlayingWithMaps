//
//  DetailViewController.m
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 9/23/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "DetailViewController.h"
#import <MBProgressHUD.h>

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.detailTitleLabel.text = self.detailTitleString;
    self.detailTextView.text = self.detailedInfoString;
    self.detailImageView.image = self.detailImage;
    
    self.detailTitleLabel.text = self.detailLocations.title;
    self.detailTextView.text = self.detailLocations.subtitle;
    self.detailImageView.image = self.detailLocations.image;
    
    [self.detailTitleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.detailTextView setFont:[UIFont systemFontOfSize:17]];
    self.detailImageView.layer.cornerRadius = self.detailImageView.frame.size.height / 2;
    self.detailImageView.layer.masksToBounds = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
