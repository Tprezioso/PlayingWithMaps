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
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMode)];
//    if ([editBarButton ]) {
//        editBarButton.title = @"Done";
//    }
    self.navigationItem.rightBarButtonItem = editBarButton;
        
    self.detailTitleLabel.text = self.detailLocations.title;
    self.detailTextView.text = self.detailLocations.subtitle;
    self.detailImageView.image = self.detailLocations.image;
    
    [self.detailTitleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.detailTextView setFont:[UIFont systemFontOfSize:13]];
    self.detailImageView.layer.cornerRadius = self.detailImageView.frame.size.height / 2;
    self.detailImageView.layer.masksToBounds = YES;
    
    if (![self.detailTitleLabel.text  isEqual: @"Edit Your Pin"]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }

    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)editMode
{
    self.detailTextView.editable = YES;
}

@end
