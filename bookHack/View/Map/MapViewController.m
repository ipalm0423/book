//
//  MapViewController.m
//  bookHack
//
//  Created by Jack KY Chen on 2017/3/11.
//  Copyright © 2017年 Jack KY Chen. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "PCSearchItem.h"
#import "PCMapBaseItem.h"
#import "PCMapHotelItem.h"
#import "PCMapSceneItem.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@end

@implementation MapViewController
@synthesize mapView, bottomBar, containerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _containerViewHeightConstraint.constant = 0;
    containerView.translatesAutoresizingMaskIntoConstraints = false;
    if (_userSearchItem == nil) {
        _userSearchItem = [PCSearchItem new];
        _userSearchItem.location = [[CLLocation alloc] initWithLatitude:-33.880837 longitude:151.205606];
        _sceneMapItems = @[
                           [[PCMapSceneItem alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:-33.880837 longitude:151.205606]
                                                               name:@"Scene A"],
                           [[PCMapSceneItem alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:-33.881837 longitude:151.205606]
                                                               name:@"Scene B"],
                           [[PCMapSceneItem alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:-33.880837 longitude:151.202606]
                                                               name:@"Scene C"]
                           ];
        _hotelMapItems = @[
                           [[PCMapHotelItem alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:-33.870837 longitude:151.205606]
                                                               name:@"Scene A"],
                           [[PCMapHotelItem alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:-33.871837 longitude:151.201606]
                                                               name:@"Scene B"],
                           [[PCMapHotelItem alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:-33.880737 longitude:151.222606]
                                                               name:@"Scene C"]
                           ];
    }
    
    mapView.region = MKCoordinateRegionMakeWithDistance(_userSearchItem.location.coordinate, 5000, 5000);
    [mapView addOverlay:[MKCircle circleWithCenterCoordinate:_userSearchItem.location.coordinate radius:1000]];
    [mapView addOverlay:[MKCircle circleWithCenterCoordinate:_userSearchItem.location.coordinate radius:2000]];
    for (PCMapBaseItem *mapItem in _sceneMapItems) {
        [mapView addAnnotation:mapItem];
    }
    for (PCMapBaseItem *mapItem in _hotelMapItems) {
        [mapView addAnnotation:mapItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
}

- (IBAction)someAction:(id)sender {
    if (_containerViewHeightConstraint.constant == 0) {
        _containerViewHeightConstraint.constant = 240;
    }
    else {
        _containerViewHeightConstraint.constant = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}


// MARK: MKMapView delegate

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView {
    
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
    circleRenderer.lineWidth = 2;
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircle *circle = (MKCircle *)overlay;
        if (circle.radius <= 1000) {
            circleRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
            circleRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        }
        else {
            circleRenderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
            circleRenderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
        }
    }
    
    return circleRenderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    if ([annotation isKindOfClass: [PCMapHotelItem class]]) {
        annotationView.pinTintColor = [UIColor redColor];
    }
    if ([annotation isKindOfClass: [PCMapSceneItem class]]) {
        annotationView.pinTintColor = [UIColor blueColor];
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
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
