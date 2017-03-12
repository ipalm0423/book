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
#import "HotelDetailViewController.h"
#import "SceneDetailViewController.h"
#import "MapFilterViewControllerTableViewController.h"

@interface MapViewController () <MKMapViewDelegate, MapFilterChangedProtocol>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@end

@implementation MapViewController
{
    UIViewController *internalPopupViewController;
}
@synthesize mapView, bottomBar, containerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _containerViewHeightConstraint.constant = 0;
    containerView.translatesAutoresizingMaskIntoConstraints = false;
    if (_userSearchItem == nil) {
        _userSearchItem = [PCSearchItem new];
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
    for (PCMapSceneItem *mapItem in _sceneMapItems) {
        [mapView addAnnotation:mapItem];
    }
    for (PCMapHotelItem *mapItem in _hotelMapItems) {
        [mapView addAnnotation:mapItem];
        // Update missing variables
        mapItem.distance = @([_userSearchItem.location distanceFromLocation:mapItem.location] / 1000.0);
    }
    for (MapFilterViewControllerTableViewController *filterVC in self.childViewControllers) {
        if ([filterVC isKindOfClass:[MapFilterViewControllerTableViewController class]]) {
            filterVC.searchItem = self.userSearchItem;
            filterVC.delegate = self;
        }
    }
    [self refreshMapItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)refreshMapItems {
    NSMutableString *hotelIds = [NSMutableString new];
    [self.hotelMapItems enumerateObjectsUsingBlock:^(PCMapHotelItem*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [hotelIds appendString:[NSString stringWithFormat:@",%@", obj.ID]];
    }];
    [hotelIds replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    NSString *urlString = [NSString stringWithFormat:@"https://hacker234:8hqNW6HtfU@distribution-xml.booking.com/json/bookings.getBlockAvailability?arrival_date=2017-06-10&departure_date=2017-06-11&hotel_ids=%@", hotelIds];
    NSURL *apiUrl = [[NSURL alloc] initWithString:urlString];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:apiUrl];
        NSArray *result = [NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingAllowFragments
                                                            error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary *hotelDict in result) {
                // find hotel object
                NSString *predicateString = [NSString stringWithFormat:@"ID=='%@'", hotelDict[@"hotel_id"]];
                PCMapHotelItem *hotelItem = [self.hotelMapItems filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString]].firstObject;
                NSMutableArray *prices = [NSMutableArray new];
                NSNumber *minPrice = @(0);
                NSNumber *maxPrice = @(0);
                for (NSDictionary *dict in result) {
                    NSNumber *n = @([dict[@"block"][0][@"min_price"][@"price"] floatValue]);
                    [prices addObject:n];
                    if (n.floatValue > maxPrice.floatValue) {
                        maxPrice = n;
                    }
                    if (n.floatValue < minPrice.floatValue || minPrice.integerValue == 0) {
                        minPrice = n;
                    }
                }
                hotelItem.minPrice = minPrice;
                hotelItem.maxPrice = maxPrice;
            }
            
            for (PCMapHotelItem *hotelItem in self.hotelMapItems) {
                if (hotelItem.minPrice.floatValue > _userSearchItem.maximumPrice.floatValue ||
                    hotelItem.maxPrice.floatValue < _userSearchItem.minimumPrice.floatValue) {
                    [mapView removeAnnotation:hotelItem];
                    continue;
                }
                if (hotelItem.star.floatValue > _userSearchItem.maximumStar.floatValue ||
                    hotelItem.star.floatValue < _userSearchItem.minimumPrice.floatValue) {
                    [mapView removeAnnotation:hotelItem];
                    continue;
                }
                if (hotelItem.numberReviews.floatValue < _userSearchItem.minimumReviews.floatValue) {
                    [mapView removeAnnotation:hotelItem];
                    continue;
                }
                if (hotelItem.userRating.floatValue > _userSearchItem.maximumUserScore.floatValue ||
                    hotelItem.userRating.floatValue < _userSearchItem.minimumUserScore.floatValue) {
                    [mapView removeAnnotation:hotelItem];
                    continue;
                }
                if (hotelItem.distance.floatValue > _userSearchItem.maximumDistance.floatValue ||
                    hotelItem.distance.floatValue < _userSearchItem.minimumDistance.floatValue) {
                    [mapView removeAnnotation:hotelItem];
                    continue;
                }
                
                if (![mapView.annotations containsObject:hotelItem]) {
                    [mapView addAnnotation:hotelItem];
                }
            }
        });
    });
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


- (void)searchShouldChange {
    [self refreshMapItems];
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
    UIViewController *vc;
    if ([view.annotation isKindOfClass: [PCMapHotelItem class]]) {
        ((MKPinAnnotationView *)view).pinTintColor = [UIColor yellowColor];
        HotelDetailViewController *_vc = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"HotelDetailVC"];
        _vc.hotelItem = (PCMapHotelItem *)view.annotation;
        vc = _vc;
    }
    if ([view.annotation isKindOfClass: [PCMapSceneItem class]]) {
        ((MKPinAnnotationView *)view).pinTintColor = [UIColor yellowColor];
        SceneDetailViewController *_vc = [[UIStoryboard storyboardWithName:@"Map" bundle:nil] instantiateViewControllerWithIdentifier:@"SceneDetailVC"];
        vc = _vc;
    }
    vc.view.frame = CGRectMake(0, self.view.bounds.size.height * 0.5, self.view.bounds.size.width, self.view.bounds.size.height * 0.5);
    vc.view.transform = CGAffineTransformMakeTranslation(0, vc.view.frame.size.height);
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    [self.view addSubview:vc.view];
    
    // Animation here;
    [UIView animateWithDuration:0.3 animations:^{
        vc.view.layer.transform = CATransform3DIdentity;
    }];
    
    internalPopupViewController = vc;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass: [PCMapHotelItem class]]) {
        ((MKPinAnnotationView *)view).pinTintColor = [UIColor redColor];
    }
    if ([view.annotation isKindOfClass: [PCMapSceneItem class]]) {
        ((MKPinAnnotationView *)view).pinTintColor = [UIColor blueColor];
    }
    
    UIViewController *vc = internalPopupViewController;
    internalPopupViewController = nil;
    [UIView animateWithDuration:0.3 animations:^{
        vc.view.transform = CGAffineTransformMakeTranslation(0, vc.view.frame.size.height);
    } completion:^(BOOL finished) {
        [vc willMoveToParentViewController:self];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
        [vc didMoveToParentViewController:self];
    }];
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
