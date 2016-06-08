//
//  ViewController.m
//  Maps
//
//  Created by Nilay Neeranjun on 6/7/16.
//  Copyright © 2016 Nilay Neeranjun. All rights reserved.
//

#import "ViewController.h"
@import Firebase;
@interface ViewController ()<MKMapViewDelegate,UISearchBarDelegate>{
    
    __weak IBOutlet MKMapView *mapView;
    CLLocationManager*locationManager;
    UIBarButtonItem*leftButton;
    UIBarButtonItem*rightButton;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FIRDatabaseReference *rootRef= [[FIRDatabase database] reference];
    UISearchBar*searchBar = [[UISearchBar alloc]init];
    searchBar.placeholder=@"Enter a location";
    searchBar.delegate=self;
    leftButton = [[UIBarButtonItem alloc] initWithTitle: @"Data" style:UIBarStyleDefault target:self action:@selector(goToData)];
    rightButton = [[UIBarButtonItem alloc] initWithTitle: @"Save" style:UIBarStyleDefault target:self action:@selector(saveData)];
    
    self.navigationItem.leftBarButtonItem=leftButton;
    self.navigationItem.rightBarButtonItem=rightButton;
    self.navigationItem.titleView=searchBar;
    
    
    mapView.showsUserLocation=TRUE;
    mapView.showsBuildings=TRUE;
    locationManager=[CLLocationManager new];
    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(addPin:)];
    [mapView addGestureRecognizer:tap];
    
    NSString*latitude = [[NSString alloc]initWithFormat:@"%f",mapView.userLocation.coordinate.latitude];
    NSString*longitude = [[NSString alloc]initWithFormat:@"%f",mapView.userLocation.coordinate.longitude];
    NSString*userLocation = [NSString stringWithFormat:@"%@,%@",latitude,longitude];
    
    [rootRef setValue:@{@"current-location": userLocation}];
    

}
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.navigationItem.leftBarButtonItem=NULL;
    self.navigationItem.rightBarButtonItem=NULL;
    searchBar.showsCancelButton=TRUE;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=FALSE;
    leftButton = [[UIBarButtonItem alloc] initWithTitle: @"Data" style:UIBarStyleDefault target:self action:@selector(goToData:)];
    rightButton=[[UIBarButtonItem alloc] initWithTitle: @"Save" style:UIBarStyleDefault target:self action:@selector(saveData:)];
    
    self.navigationItem.leftBarButtonItem=leftButton;
    self.navigationItem.rightBarButtonItem=rightButton;
    searchBar.resignFirstResponder;
    searchBar.text=@"";
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    mapView.showsUserLocation=FALSE;
    mapView.userTrackingMode=FALSE;
    searchBar.resignFirstResponder;
    searchBar.showsCancelButton=FALSE;
    NSString*searchText = searchBar.text;
    leftButton = [[UIBarButtonItem alloc] initWithTitle: @"Data" style:UIBarStyleDefault target:self action:@selector(goToData:)];
    rightButton = [[UIBarButtonItem alloc] initWithTitle: @"Save" style:UIBarStyleDefault target:self action:@selector(saveData:)];
    self.navigationItem.leftBarButtonItem=leftButton;
    self.navigationItem.rightBarButtonItem=rightButton;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchText completionHandler:^(NSArray*placemarks,NSError*error){
        CLPlacemark*placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion selectedRegion;
        selectedRegion=MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 1000, 1000);
        MKPointAnnotation*pin = [[MKPointAnnotation alloc]init];
        for (id annotation in mapView.annotations) {
            [mapView removeAnnotation:annotation];
        }
        pin.coordinate=selectedRegion.center;
        [mapView addAnnotation:pin];
        
        selectedRegion = [mapView regionThatFits:selectedRegion];
        [mapView setRegion:selectedRegion animated:YES];
        
        
        
        
    }];
}
-(void)addPin:(UIGestureRecognizer *)gestureRecognizer{
    
    for (id annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    CGPoint selectedPoint = [gestureRecognizer locationInView:mapView];
    CLLocationCoordinate2D coordinate = [mapView convertPoint:selectedPoint toCoordinateFromView:mapView];
    MKPointAnnotation*pin = [[MKPointAnnotation alloc] init];
    pin.coordinate=coordinate;
    
    
    [mapView addAnnotation:pin];
    
    
}
-(void)saveData{
    
    FIRDatabaseReference *rootRef= [[FIRDatabase database] reference];
    if(mapView.annotations.count==2){
        MKPointAnnotation*ann = [[MKPointAnnotation alloc] init];
        ann=mapView.annotations[1];
        
        CLLocationCoordinate2D coordinates = ann.coordinate;
        NSString*latitude = [[NSString alloc]initWithFormat:@"%f",coordinates.latitude];
        NSString*longitude = [[NSString alloc]initWithFormat:@"%f",coordinates.longitude];
        
        NSString *selectedLocation = [NSString stringWithFormat:@"%@,%@",latitude, longitude];
        NSString*key = [[rootRef child:@"saved-locations"]childByAutoId].key;
        NSDictionary *childUpdates = @{[@"/saved-locations/" stringByAppendingString:key]: selectedLocation};
        [rootRef updateChildValues:childUpdates];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No location selected" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:NULL, nil];
        [alert show];
        
        
        
        
    }
}
-(void)goToData{
    UIViewController*tableView = [self.storyboard instantiateViewControllerWithIdentifier:@"DataTableViewController"];
    [self.navigationController pushViewController:tableView animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
