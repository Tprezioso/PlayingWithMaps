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

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mapImageView;
@property (strong, nonatomic) NSMutableArray *locationsArray;
@property (strong, nonatomic) NSMutableArray *locationsNames;
@property (strong, nonatomic) TPAnnotation *pin;

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

    [self addPresetPins];
    self.mapImageView.layer.cornerRadius = self.mapImageView.frame.size.width / 2;
    self.mapImageView.clipsToBounds = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)addPresetPins
{
    TPAnnotation *pins = [[TPAnnotation alloc] init];
    self.locationsArray = [pins presetPins];
    [self.mapView addAnnotations:self.locationsArray];
    self.locationsNames = @[[[pins presetPins][0]title], [[pins presetPins][1]title]].mutableCopy;
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
            self.mapImageView.image = dm.image;
            self.pin = dm;
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
    toAdd.subtitle = @"Tap Here";
    toAdd.title = @"Edit Your Pin";
    toAdd.image = [UIImage imageNamed:@"placeholderImage.png"];
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
        detailVC.detailLocations = self.pin;
    }

    if ([segue.identifier isEqualToString:@"listView"]) {
        LocationTableViewController *listView = segue.destinationViewController;
        listView.locations = self.locationsArray;
        listView.locationsNames = self.locationsNames;
    }
}

@end
