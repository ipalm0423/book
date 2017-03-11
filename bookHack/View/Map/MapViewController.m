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
@property (weak, nonatomic) UIViewController *filterViewController;
@end

@implementation MapViewController
@synthesize mapView, bottomBar, containerView;
@synthesize filterViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_userSearchItem == nil) {
        _userSearchItem = [PCSearchItem new];
        _userSearchItem.location = [[CLLocation alloc] initWithLatitude:-33.880837 longitude:151.205606];
        _sceneMapItems = @[
                           [[PCMapBaseItem alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:-33.880837 longitude:151.205606]
                                                              name:@"Scene A"],
                           [[PCMapBaseItem alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:-33.881837 longitude:151.205606]
                                                              name:@"Scene B"],
                           [[PCMapBaseItem alloc] initWithLocation:[[CLLocation alloc] initWithLatitude:-33.880837 longitude:151.202606]
                                                              name:@"Scene C"]
                           ];
    }
    
    mapView.region = MKCoordinateRegionMakeWithDistance(_userSearchItem.location.coordinate, 2000, 2000);
    for (PCMapBaseItem *mapItem in _sceneMapItems) {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)someAction:(id)sender {
    [filterViewController willMoveToParentViewController:self];
    [[filterViewController view] removeFromSuperview];
    [filterViewController removeFromParentViewController];
    
    UIViewController *vc = [UIViewController new];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    [[vc view] setFrame:containerView.bounds];
    [containerView addSubview: vc.view];
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"view": vc.view}]];
    
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view(100)]-0-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:@{@"view": vc.view}]];
    
    filterViewController = vc;
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
