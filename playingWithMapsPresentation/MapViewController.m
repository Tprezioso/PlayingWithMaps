//
//  ViewController.m
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 3/13/15.
//  Copyright (c) 2015 Thomas Prezioso. All rights reserved.
//

#import "MapViewController.h"
#import "DetailViewController.h"
#import "LocationTableViewController.h"
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
@property (strong, nonatomic) NSArray *locationsArray;

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
    [self addPrestPins];
    

    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   
    self.mapImageView.layer.cornerRadius = self.mapImageView.frame.size.width / 2;
    self.mapImageView.clipsToBounds = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)addPrestPins
{
    TPAnnotation *kissenaPrakPin = [[TPAnnotation alloc]init];
    kissenaPrakPin.coordinate = CLLocationCoordinate2DMake(40.745184, -73.806207);
    kissenaPrakPin.title = @"Kissena Park";
    kissenaPrakPin.subtitle = @"Park in Flushing Queens";
    
    TPAnnotation *flushingMeadowsPark = [[TPAnnotation alloc] init];
    flushingMeadowsPark.coordinate = CLLocationCoordinate2DMake(40.740385, -73.840322);
    flushingMeadowsPark.title = @"Flushing Meadows Park";
    flushingMeadowsPark.subtitle = @"Former loaction of worlds Fair and Loaction formally know as the valley of ashes made famous in the book 'The Grest gatsby'";

    self.locationsArray = @[kissenaPrakPin, flushingMeadowsPark];
    [self.mapView addAnnotations:self.locationsArray];
//    [self.mapView addAnnotation:kissenaPrakPin];
//    [self.mapView addAnnotation:flushingMeadowsPark];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"annotation selected");
    [self.descriptionView setHidden:NO];
    id<MKAnnotation> annSelected = view.annotation;
    
    if ([annSelected isKindOfClass:[TPAnnotation class]])
    {
        TPAnnotation *dm = (TPAnnotation *)annSelected;
        if (dm.title) {
            self.titleLabel.text = dm.title;
            self.descriptionLabel.text = dm.subtitle;
            if ([dm.title isEqualToString:@"Kissena Park"] ) {
                self.mapImageView.image = [UIImage imageNamed:@"kissenaParkExit.jpg"];
            } else {
                self.mapImageView.image = [UIImage imageNamed:@"flsuhingMeadowsPark.jpeg"];
            }
        }
        NSLog(@"Pin touched: title = %@", dm.title);
    } else {
        [self.descriptionView setHidden:YES];
    }

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
    if(touch.view != self.descriptionView){
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
