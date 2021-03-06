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
    self.mapView.delegate = self;
    self.mapImageView.layer.cornerRadius = self.mapImageView.frame.size.width / 2;
    self.mapView.mapType = MKMapTypeHybrid;
    self.mapImageView.clipsToBounds = YES;
    [self.descriptionView setHidden:YES];
    [self setUpMap];
    [self addPresetPins];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removepinFromMap:) name:@"removePin" object:nil];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.mapView addAnnotations: self.devices];
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
//    TPAnnotation *testPin = [[TPAnnotation alloc] init];
//    testPin.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"pinTitle"];
//    testPin.subtitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"pinsubtitle"];
//    double lat = [[NSUserDefaults standardUserDefaults] doubleForKey:@"pinLatCoordinate"];
//    double lon = [[NSUserDefaults standardUserDefaults] doubleForKey:@"pinLonCoordinate"];
//    testPin.coordinate = CLLocationCoordinate2DMake(lat, lon);
//    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"pinImage"];
//    testPin.image = [UIImage imageWithData:imageData];
//    [self.locationsArray addObject:testPin];
    [self.mapView addAnnotations:self.locationsArray];
    self.locationsNames = @[[[pins presetPins][0]title], [[pins presetPins][1]title]].mutableCopy;
//    [self.locationsNames addObject:testPin.title];
}

- (void)removepinFromMap:(NSNotification *)pinNotification
{
    TPAnnotation *pinToRemove = (TPAnnotation*)[pinNotification.userInfo objectForKey:@"pin"];
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

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:toAdd.title forKey:@"pinTitle"];
    [defaults setObject:toAdd.subtitle forKey:@"pinsubtitle"];
    [defaults setDouble:toAdd.coordinate.latitude forKey:@"pinLatCoordinate"];
    [defaults setDouble:toAdd.coordinate.longitude forKey:@"pinLonCoordinate"];
    [defaults setObject:UIImagePNGRepresentation(toAdd.image) forKey:@"pinImage"];
    [defaults synchronize];
    //NSLog(@"%f, %f",touchMapCoordinate.latitude, touchMapCoordinate.longitude);
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Locations" inManagedObjectContext:context];
    [newDevice setValue:toAdd.title forKey:@"title"];
    [newDevice setValue:toAdd.subtitle forKey:@"subtitle"];
    [newDevice setValue:[NSNumber numberWithDouble:toAdd.coordinate.latitude] forKey:@"coordinateLat"];
    [newDevice setValue:[NSNumber numberWithDouble:toAdd.coordinate.longitude] forKey:@"coordinateLon"];

    NSError *error = nil;
    // Save the object to persistent store
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

- (void)savePins
{
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
