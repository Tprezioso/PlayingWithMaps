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
@interface LocationTableViewController ()

@property (strong, nonatomic)NSMutableArray *devices;
@property (strong, nonatomic)NSString *locationName;
@property (strong, nonatomic)NSMutableArray *locationsTest;
@property (strong, nonatomic)NSMutableArray *locationsArray;



@end

@implementation LocationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    self.devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    for (NSInteger i = 0; i < [self.devices count]; i++) {
//        
//      self.locationName = ;
//    }
    self.locationsArray = self.devices;
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];
    
    for (NSInteger i = 0; i < [self.devices count]; i++) {
       NSString *names = @"";
        names = [self.devices[i]title];
        [self.locationsTest addObject:names];
    }
    cell.textLabel.text = self.locationsTest[indexPath.row];
    
    return cell;
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
        [self.locationsNames removeObjectAtIndex:indexPath.row];
        NSMutableDictionary *removedPin = [[NSMutableDictionary alloc] init];
        removedPin [@"pin"] = [self.locations objectAtIndex:indexPath.row];

//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        NSManagedObjectContext *context = [appDelegate managedObjectContext];
//        MapViewController *map = [[MapViewController alloc]init];
//        [context deleteObject:[map.devices objectAtIndex:indexPath.row]];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"removePin" object:nil userInfo:removedPin];
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
