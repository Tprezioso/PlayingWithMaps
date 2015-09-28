//
//  ViewController.m
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 3/13/15.
//  Copyright (c) 2015 Thomas Prezioso. All rights reserved.
//

#import "MapViewController.h"
#import "DetailViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TPAnnotation.h"
#import <MBProgressHUD.h>

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mapImageView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.descriptionView setHidden:YES];
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    CLLocationCoordinate2D userCoordinate = self.locationManager.location.coordinate;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    MKCoordinateSpan mySpan = MKCoordinateSpanMake(.15, .15);
    MKCoordinateRegion myRegion = MKCoordinateRegionMake(userCoordinate, mySpan);
    [self.mapView setRegion:myRegion animated:YES];
    self.mapView.showsUserLocation = YES;
    [self.mapView setCenterCoordinate:userCoordinate animated:YES];
    [self addGestureRecogniserToMapView];
    NSLog(@"%f",userCoordinate.latitude);
    NSLog(@"%f",userCoordinate.longitude);
    
    //<<<<<<<<Preloaded location (make a method to load all preloaded loactions)>>>>>>>>>>>>>>>>>>>>>>>>>>
    TPAnnotation *addedPinOnLoad = [[TPAnnotation alloc]init];
    addedPinOnLoad.coordinate = CLLocationCoordinate2DMake(40.745184, -73.806207);
    addedPinOnLoad.title = @"Kissena Park";
    addedPinOnLoad.subtitle = @"Former loaction of worlds Fair and Loaction formally know as the valley of ashes made famous in the book 'The Grest gatsby'";
    self.titleLabel.text = addedPinOnLoad.title;
    self.descriptionLabel.text = addedPinOnLoad.subtitle;
    self.mapImageView.image = [UIImage imageNamed:@"kissenaParkExit.jpg"];
    [self.mapView addAnnotation:addedPinOnLoad];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   
    self.mapImageView.layer.cornerRadius = self.mapImageView.frame.size.width / 2;
    self.mapImageView.clipsToBounds = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"annotation selected");
    [self.descriptionView setHidden:NO];
}

- (void)addGestureRecogniserToMapView
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addPinToMap:)];
    longPress.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:longPress];
}

- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    TPAnnotation *toAdd = [[TPAnnotation alloc] init];
    toAdd.coordinate = touchMapCoordinate;
    toAdd.subtitle = @"Here";
    toAdd.title = @"Your Pin";
    self.titleLabel.text = toAdd.title;
    self.descriptionLabel.text = toAdd.subtitle;
    [self.mapView addAnnotation:toAdd];
    //NSLog(@"%f, %f",touchMapCoordinate.latitude, touchMapCoordinate.longitude);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    if(touch.view!= self.descriptionView){
        self.descriptionView.hidden = YES;
    }
}
// Use to add annotation to userLocation
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//    
//    // Add an annotation
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = userLocation.coordinate;
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
//    
//    [self.mapView addAnnotation:point];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailView"]) {
        DetailViewController *detailVC = segue.destinationViewController;
        detailVC.detailTitleString = self.titleLabel.text;
        detailVC.detailedInfoString = self.descriptionLabel.text;
        detailVC.detailImage = self.mapImageView.image;
       // NSLog(@"%@",detailVC.detailTitleLabel.text);
    }
}


@end
