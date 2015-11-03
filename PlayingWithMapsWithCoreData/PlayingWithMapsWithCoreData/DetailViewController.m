//
//  DetailViewController.m
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 9/23/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UITextField *detailTitleTextField;
@property (strong, nonatomic) IBOutlet UIButton *editImageButtonPressed;
@property (strong, nonatomic) IBOutlet UIButton *segueButton;
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
        if ((self.isEditing) && ([self.editBarButton.title  isEqual: @"Done"])) {
            self.isEditing = NO;
        }
    }
    
    if (self.isEditing) {
        self.editBarButton.title = @"Done";
        self.detailTextView.editable = YES;
        self.detailTitleTextField.enabled = YES;
        self.editImageButtonPressed.enabled = YES;
        self.segueButton.enabled = NO;
    } else {
        self.editBarButton.title = @"Edit";
        self.detailTextView.editable = NO;
        self.detailTitleTextField.enabled = NO;
        self.segueButton.enabled = YES;
        [self saveEdit];
        [self editedDetails];
        [self editLocation];
    }
}

-(void) editedDetails
{
    NSMutableDictionary *editedPin = [[NSMutableDictionary alloc] init];
    editedPin [@"pinTitle"] = self.detailTitleTextField.text;
    editedPin [@"pinsSubtitle"] = self.detailTextView.text;
    editedPin [@"pinImage"] = self.detailImageView.image;
    editedPin [@"pin"] = self.detailLocations;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editedPin" object:nil userInfo:editedPin];
}
- (void)editLocation
{
     self.detailLocations.title = self.detailTitleTextField.text;
     self.detailLocations.subtitle = self.detailTextView.text;
     self.detailLocations.image = self.detailImageView.image;
    NSManagedObjectContext *context= [self managedObjectContext];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

}
- (void)saveEdit
{
    NSManagedObjectContext *context = [self managedObjectContext];
//    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
//    [newDevice setValue:self.detailTitleTextField.text forKey:@"title"];
//    [self.delegate locationName:self.detailTitleTextField.text];

    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (IBAction)editImageButton:(id)sender
{
    if (self.isEditing) {
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"imageView"]) {
        ImageViewController *imageVC = segue.destinationViewController;
        imageVC.detailedImage = self.detailImageView.image;
    }
}

@end
