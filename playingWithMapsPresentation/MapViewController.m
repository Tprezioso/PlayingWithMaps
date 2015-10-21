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
@property (strong, nonatomic) TPAnnotation *pin;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mapImageView;
@property (strong, nonatomic) NSMutableArray *locationsArray;
@property (strong, nonatomic) NSMutableArray *locationsNames;
@property (strong, nonatomic) NSMutableArray *savedPins;
@property(strong, nonatomic) NSString *filename;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.mapView.delegate = self;
    self.mapImageView.layer.cornerRadius = self.mapImageView.frame.size.width / 2;
    self.mapImageView.clipsToBounds = YES;
    [self.descriptionView setHidden:YES];
    self.store = [TPLocationDataStore sharedLocationsDataStore];
    TPAnnotation *testPin = [[TPAnnotation alloc] initWithTitle:@"yoyo" subtitle:@"This is a test" pinCoordinates:CLLocationCoordinate2DMake(0, 0) image:nil];
    [self.locationsArray addObject:testPin];
    self.store.locations = [NSMutableArray arrayWithArray:self.locationsArray];
    [self.mapView addAnnotations:self.store.locations];
    
    [self setUpMap];
    [self addPresetPins];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removepinFromMap:) name:@"removePin" object:nil];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
   // [self setUpMap];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
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
    
//    if (self.locationsArray != nil) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSData *coordinate = [defaults objectForKey:@"latCoordinate"];
//        TPAnnotation *newPin = [NSKeyedUnarchiver unarchiveObjectWithData:coordinate];
//    
//        [self.mapView addAnnotation:newPin];
//    }
//  TPAnnotation *newPin = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filename];
    
    NSLog(@"%f",userCoordinate.latitude);
    NSLog(@"%f",userCoordinate.longitude);
}

- (void)addPresetPins
{
    TPAnnotation *pins = [[TPAnnotation alloc] init];
    self.locationsArray = [pins presetPins];
   self.store.locations = [NSMutableArray arrayWithArray:self.locationsArray];
    [self.mapView addAnnotations:self.locationsArray];
    self.locationsNames = @[[[pins presetPins][0]title], [[pins presetPins][1]title]].mutableCopy;
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
    [self.locationsArray addObject:toAdd.title];
    [self.locationsNames addObject:toAdd.title];

    [self.mapView addAnnotation:toAdd];
    self.store.locations = [NSMutableArray arrayWithObject:toAdd];
    
//    [self saveData];
//    [self loadData];
    //NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
//    self.filename = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    [NSKeyedArchiver archiveRootObject:toAdd toFile:self.filename];
//    NSLog(@"%@",self.filename);
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:toAdd] forKey:@"newPin"];
//    [defaults synchronize];
//    NSLog(@">>>>>>>>>%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]);

    //NSLog(@"%f, %f",touchMapCoordinate.latitude, touchMapCoordinate.longitude);
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

//- (void) saveData {
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
//    
//    [NSKeyedArchiver archiveRootObject:self.locationsArray toFile:filePath];
//}
//
//- (void) loadData {
//    // look for saved data.
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
//    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        NSData *data = [NSData dataWithContentsOfFile:filePath];
//        NSArray *savedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        self.locationsArray = [[NSMutableArray alloc] initWithArray:savedData];
//    }
//    //[self.mapView addAnnotations:self.locationsArray];
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
