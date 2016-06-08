//
//  DataTableViewController.m
//  Maps
//
//  Created by Nilay Neeranjun on 6/7/16.
//  Copyright © 2016 Nilay Neeranjun. All rights reserved.
//

#import "DataTableViewController.h"
#import "CoordinatesCustomCell.h"
@import Firebase;
FIRDatabaseQuery*data;
NSArray*locations;

@implementation DataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 CoordinatesCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoordinatesCustomCell" forIndexPath:indexPath];
     
     FIRDatabaseReference *rootRef= [[FIRDatabase database] reference];
     FIRDatabaseQuery*selectedLocations = [rootRef child:@"selected-locations"] ;
     [rootRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot*snapshot){
         locations=snapshot.value;
             }];
     cell.latitude.text = @"SDSDS";
   
     cell.longitude.text =@"SDSD";
     cell.index.text = @"5";
     
 
 // Configure the cell...
 
 return cell;
 }


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

