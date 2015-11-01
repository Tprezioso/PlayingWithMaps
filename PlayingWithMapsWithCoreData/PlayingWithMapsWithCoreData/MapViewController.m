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
#import <CoreData/CoreData.h>
#import "TPAnnotation.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) TPAnnotation *pin;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mapImageView;
@property (strong, nonatomic) NSMutableArray *locationsArray;
@property (strong, nonatomic) NSMutableArray *locationsNames;
@property (strong, nonatomic) NSMutableArray *devices;


@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removepinFromMap:) name:@"removePin" object:nil];
    self.mapView.delegate = self;
    self.mapImageView.layer.cornerRadius = self.mapImageView.frame.size.width / 2;
    self.mapImageView.clipsToBounds = YES;
    [self.descriptionView setHidden:YES];
    [self setUpMap];
    [self addPresetPins];
    [self setUpSavedPins];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
 //  [self setUpSavedPins];
}

- (void)setUpSavedPins
{
    [self.mapView removeAnnotations:self.locationsArray];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSInteger i = 0; i < [self.devices count]; i++) {
        NSString *names = @"";
        names = [self.devices[i]title];
        [self.locationsNames addObject:names];
        TPAnnotation *newPin = [TPAnnotation new];
        newPin.title = [self.devices[i]title];
        newPin.subtitle = [self.devices[i]subtitle];
        newPin.coordinate = CLLocationCoordinate2DMake([[self.devices[i] valueForKey:@"coordinateLat"] doubleValue], [[self.devices[i] valueForKey:@"coordinateLon"]doubleValue]);
         [self.locationsArray addObject:newPin];
    }
    [self.mapView addAnnotations: self.locationsArray];
 }

- (void)setUpMap
{
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
}

- (void)addPresetPins
{
    TPAnnotation *pins = [[TPAnnotation alloc] init];
    self.locationsArray = [pins presetPins];
    [self.mapView addAnnotations:self.locationsArray];
    self.locationsNames = @[[[pins presetPins][0]title], [[pins presetPins][1]title]].mutableCopy;
}

- (void)removepinFromMap:(NSNotification *)pinNotification
{
    TPAnnotation *pinToRemove = (TPAnnotation*)[pinNotification.userInfo objectForKey:@"pin"];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
   // NSMutableArray *fetchSavedData = [[NSMutableArray alloc] init];
    self.devices = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSInteger i = 0; i < [self.devices count]; i++) {
        NSLog(@"%f", [[self.devices[i] valueForKey:@"coordinateLat"]doubleValue]);
        NSLog(@"%f", pinToRemove.coordinate.latitude);
        NSLog(@"%@",self.devices);
        if (pinToRemove.coordinate.latitude == [[self.devices[i] valueForKey:@"coordinateLat"] doubleValue]){
            [context deleteObject:self.devices[i]];
            NSLog(@"removed location from core data >>>>>>>>>>");
        }
    }
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    [self.mapView removeAnnotation:pinToRemove];
    self.descriptionView.hidden = YES;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"annotation selected");
    [self.descriptionView setHidden:NO];
    id<MKAnnotation> annSelected = view.annotation;
    
    if ([annSelected isKindOfClass:[TPAnnotation class]]) {
        TPAnnotation *dm = (TPAnnotation *)annSelected;
        if (dm.title) {
            self.titleLabel.text = dm.title;
            self.descriptionLabel.text = dm.subtitle;
            self.mapImageView.image = dm.image;
            self.pin = dm;
            NSLog(@"Pin touched: title = %@", dm.title);
        }
    } else {
        [self.descriptionView setHidden:YES];
    }
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    view.rightCalloutAccessoryView = infoButton;
    infoButton.hidden = YES;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"detailView" sender:self];
}

- (void)addGestureRecogniserToMapView
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addPinToMap:)];
    longPress.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:longPress];
}

- (void)addPinToMap:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    TPAnnotation *toAdd = [[TPAnnotation alloc] init];
    toAdd.coordinate = touchMapCoordinate;
    toAdd.subtitle = @"Tap Here";
    toAdd.title = @"Edit Your Pin";
    toAdd.image = [UIImage imageNamed:@"placeholderImage.png"];
    self.titleLabel.text = toAdd.title;
    self.descriptionLabel.text = toAdd.subtitle;
    [self.locationsArray addObject:toAdd];
    [self.locationsNames addObject:toAdd.title];
    [self.mapView addAnnotation:toAdd];

    // Create a new managed object
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
    [newDevice setValue:toAdd.title forKey:@"title"];
    [newDevice setValue:toAdd.subtitle forKey:@"subtitle"];
    [newDevice setValue:[NSNumber numberWithDouble:toAdd.coordinate.latitude] forKey:@"coordinateLat"];
    [newDevice setValue:[NSNumber numberWithDouble:toAdd.coordinate.longitude] forKey:@"coordinateLon"];
    
    // Save the object to persistent store
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    if (touch.view != self.descriptionView) {
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

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

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
