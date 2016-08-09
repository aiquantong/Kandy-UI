//
//  LocationViewController.m
//  CallCenter
//
//  Created by aiquantong on 7/21/16.
//  Copyright © 2016 aiquantong. All rights reserved.
//

#import "CCLocationViewController.h"
#import "../Model/CCLocationAddressModel.h"


@interface CCLocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    CLLocationManager *locationManager;
    
    CLLocation *currentLocation;
    CLLocation *chooseLocation;
    UIImageView *pointAnnotationImageView;
    CLGeocoder *revGeo;
    
    NSMutableArray *mTableArr;
    BOOL isLocationCenter;
}

@property (nonatomic, strong) MKMapView *mmapView;
@property (nonatomic, strong) UITableView *mtableView;

@end

@implementation CCLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isReceive) {
        
        self.mmapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.view addSubview:self.mmapView];
        self.mmapView.delegate = self;
        self.mmapView.mapType = MKMapTypeStandard;
        self.mmapView.zoomEnabled = YES;
        [self.mmapView setShowsUserLocation:YES];
        [self moveToLocation];
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        [annotationPoint setCoordinate:self.currentLocationCoordinate];
        [self.mmapView  addAnnotation:annotationPoint];
        
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendLocationAction:)];
        
        isLocationCenter = YES;
        self.currentLocationCoordinate = kCLLocationCoordinate2DInvalid;
        self.mmapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2)];
        [self.view addSubview:self.mmapView];
        self.mmapView.delegate = self;
        self.mmapView.mapType = MKMapTypeStandard;
        self.mmapView.zoomEnabled = YES;
        [self.mmapView setShowsUserLocation:YES];
        pointAnnotationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CCkit.bundle/located_pin@3x.png"]];
        pointAnnotationImageView.frame = CGRectMake((self.mmapView.frame.size.width - 18)/2, (self.mmapView.frame.size.height - 38)/2 + 13, 18, 38);
        [self.mmapView addSubview:pointAnnotationImageView];
        pointAnnotationImageView.hidden = YES;
        
        UIButton *relocationButton = [[UIButton alloc] initWithFrame:CGRectMake(self.mmapView.frame.size.width - 50 -10, self.mmapView.frame.size.height - 50 - 20, 50, 50)];
        [self.mmapView addSubview:relocationButton];
        [relocationButton setImage:[UIImage imageNamed:@"CCkit.bundle/location_my@3x.png"] forState:UIControlStateNormal];
        [relocationButton addTarget:self action:@selector(relocationAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        mTableArr = [[NSMutableArray alloc] initWithCapacity:10];
        self.mtableView = [[UITableView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height/2,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/2) style:UITableViewStylePlain];
        [self.view addSubview:self.mtableView];
        self.mtableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.mtableView.delegate = self;
        self.mtableView.dataSource = self;
        
        [self startLocation];
    }

    // Do any additional setup after loading the view.
}


-(void)startLocation
{
    BOOL enable = [CLLocationManager locationServicesEnabled];
    CLAuthorizationStatus laState = [CLLocationManager authorizationStatus];
    if (enable) {
        if (laState == kCLAuthorizationStatusNotDetermined) {
            if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [[self locationManager] requestWhenInUseAuthorization];
            }
        }else if(laState == kCLAuthorizationStatusAuthorizedWhenInUse || laState == kCLAuthorizationStatusAuthorizedAlways){
        
        }else{
        
        }
    }else{
    
    }
}

-(CLLocationManager *)locationManager
{
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
    }
    return locationManager;
}


-(void)sendLocationAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseLocation:address:)]) {
        NSString *address = @"";
        for (CCLocationAddressModel *lm in mTableArr) {
            if (lm.isSelect) {
                address = lm.address;
                break;
            }
        }
        [self.delegate chooseLocation:chooseLocation address:address];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startRevGeo:(CLLocation *)location
{
    if (revGeo == nil) {
        revGeo = [[CLGeocoder alloc] init];
    }
    
    [revGeo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"reverseGeocodeLocation error == %@", [error description]);
        }
        
        [mTableArr removeAllObjects];
        for (int i = 0; i < [placemarks count]; i++) {
            CLPlacemark *pk = [placemarks objectAtIndex:i];
            CCLocationAddressModel *lm = [[CCLocationAddressModel alloc] init];
            //lm.address = [NSString stringWithFormat:@"%@ %@%@%@", pk.name, pk.administrativeArea,pk.locality,pk.thoroughfare];
            lm.address = pk.name;
            lm.location = pk.location;
            lm.isSelect = i == 0? YES : NO;
            [mTableArr addObject:lm];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mtableView reloadData];
        });
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)relocationAction:(id)sender
{
    isLocationCenter = YES;
    [self moveToLocation];
}


#pragma mark location
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//      NSLog(@"fromLocation");
//}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [[self locationManager] requestWhenInUseAuthorization];
        }
    }else{
        
    }
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(10_9, 4_0);
{
    NSLog(@"didUpdateUserLocation");
    if(isLocationCenter){
        pointAnnotationImageView.hidden = NO;
        self.currentLocationCoordinate = userLocation.location.coordinate;
        chooseLocation = userLocation.location;
        currentLocation = userLocation.location;
        isLocationCenter = NO;
        [self moveToLocation];
    }
}


-(void)moveToLocation
{
    if (CLLocationCoordinate2DIsValid(self.currentLocationCoordinate)) {
        float zoomLevel = 0.005;
        MKCoordinateRegion region = MKCoordinateRegionMake(self.currentLocationCoordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
        MKCoordinateRegion fitRegion = [self.mmapView regionThatFits:region];
        [self.mmapView setRegion:fitRegion animated:YES];
        
        if (!self.isReceive) {
            [self startRevGeo:currentLocation];
        }
    }
}


- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error NS_AVAILABLE(10_9, 4_0);
{
    NSLog(@"didFailToLocateUserWithError");
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;
{
    if (!self.isReceive) {
        CLLocationCoordinate2D chooseLocationCoordinate2D = [self.mmapView convertPoint:self.mmapView.center toCoordinateFromView:self.mmapView];
        chooseLocation = [[CLLocation alloc] initWithCoordinate:chooseLocationCoordinate2D altitude:currentLocation.altitude horizontalAccuracy:kCLLocationAccuracyThreeKilometers verticalAccuracy:kCLLocationAccuracyThreeKilometers timestamp:[NSDate date]];
        [self startRevGeo:chooseLocation];
    }
}


#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [mTableArr count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationAddressCell"];
    
    CCLocationAddressModel *lm = [mTableArr objectAtIndex:[indexPath row]];
    cell.textLabel.text = lm.address;
    cell.accessoryType = lm.isSelect?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCLocationAddressModel *lm = [mTableArr objectAtIndex:[indexPath row]];
    lm.isSelect = !lm.isSelect;
    [self.mtableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.mtableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



