//
//  LocationTableViewController.m
//  playingWithMapsPresentation
//
//  Created by Thomas Prezioso on 9/17/15.
//  Copyright (c) 2015 Thomas Prezioso. All rights reserved.
//

#import "LocationTableViewController.h"
#import "MapViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import <CoreData/CoreData.h>
@interface LocationTableViewController () <locationNames>

//@property (strong, nonatomic)TPAnnotation *pins;
@end

@implementation LocationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editedPin:) name:@"editedPin" object:nil];

    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];
    TPAnnotation *pins = self.locations[indexPath.row];
    cell.textLabel.text = pins.title;
    return cell;
}

- (void)editedPin:(NSNotification *)pinNotification
{
    NSString *editedPin = [pinNotification.userInfo objectForKey:@"pinTitle"];
    NSString *editedPinsubtitle = [pinNotification.userInfo objectForKey:@"pinsSubtitle"];
    UIImage *editedImage = [pinNotification.userInfo objectForKey:@"pinImage"];
    TPAnnotation *pin = (TPAnnotation*)[pinNotification.userInfo objectForKey:@"pin"];
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    TPAnnotation *locationPin = self.locations[ip.row];
    locationPin.title = editedPin;
    locationPin.subtitle = editedPinsubtitle;
    locationPin.image = editedImage;
    [self.tableView reloadData];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    NSMutableArray *pinArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSError *error = nil;
    for (NSInteger i = 0; i < [pinArray count]; i++) {
        if (pin.coordinate.latitude == [[pinArray[i] valueForKey:@"coordinateLat"] doubleValue]){
            [pinArray[i] setValue:editedPin forKey:@"title"];
            [pinArray[i] setValue:editedPinsubtitle forKey:@"subtitle"];
            NSData *imageData = UIImagePNGRepresentation(editedImage);
            [pinArray[i] setValue:imageData forKey:@"images"];
            NSLog(@"<<<<<<<<<<<saved location from core data >>>>>>>>>>");
        }
    }

    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *removedPin = [[NSMutableDictionary alloc] init];
        removedPin [@"pin"] = [self.locations objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removePin" object:nil userInfo:removedPin];

       // [self.locations removeObjectAtIndex:indexPath.row];
               [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailVCFromTable"]) {
    DetailViewController *detailedVC = segue.destinationViewController;
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    detailedVC.detailLocations = self.locations[selectedIndexPath.row];
    }
}

@end
