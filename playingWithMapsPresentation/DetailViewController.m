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
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UITextField *detailTitleTextField;
@property (strong, nonatomic) IBOutlet UIButton *editImageButtonPressed;
@property (strong, nonatomic) UIBarButtonItem *editBarButton;
@property (nonatomic) BOOL isEditing;
- (IBAction)editImageButton:(id)sender;

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
        self.editImageButtonPressed.enabled = YES;
    } else {
        self.editBarButton.title = @"Edit";
        self.detailTextView.editable = NO;
        self.detailTitleTextField.enabled = NO;
        self.editImageButtonPressed.enabled = NO;
    }
}

- (IBAction)editImageButton:(id)sender
{
    if (self.isEditing == YES) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.detailImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
