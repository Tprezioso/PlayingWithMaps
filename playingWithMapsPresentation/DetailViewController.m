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
@property (strong, nonatomic) UIBarButtonItem *editBarButton;
@property (strong, nonatomic) IBOutlet UITextField *detailTitleTextField;
- (IBAction)editImageButton:(id)sender;
@property (nonatomic) BOOL isEditing;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editMode)];
    self.navigationItem.rightBarButtonItem = self.editBarButton;
    self.detailTitleTextField.text = self.detailLocations.title;
    self.detailTitleTextField.enabled = NO;
    self.detailTextView.text = self.detailLocations.subtitle;
    self.detailImageView.image = self.detailLocations.image;
    self.detailImageView.layer.cornerRadius = self.detailImageView.frame.size.height / 2;
    self.detailImageView.layer.masksToBounds = YES;
    [self.detailTitleTextField setFont:[UIFont systemFontOfSize:13]];
    [self.detailTextView setFont:[UIFont systemFontOfSize:13]];
    
    if (![self.detailTitleTextField.text  isEqual: @"Edit Your Pin"]) {
        self.editBarButton.enabled = NO;
        self.editBarButton.tintColor = [UIColor clearColor];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)editMode
{
    if (self.editBarButton.target) {
        self.isEditing = YES;
        if ((self.isEditing == YES) && ([self.editBarButton.title  isEqual: @"Done"])) {
            self.isEditing = NO;
        }
    }
    
    if (self.isEditing == YES) {
        self.editBarButton.title = @"Done";
        self.detailTextView.editable = YES;
        self.detailTitleTextField.enabled = YES;
    } else {
        self.editBarButton.title = @"Edit";
        self.detailTextView.editable = NO;
        self.detailTitleTextField.enabled = NO;
    }
}

- (IBAction)editImageButton:(id)sender {
}
@end
