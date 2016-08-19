//
//  ViewController.m
//  reaverInMap
//
//  Created by yi chen on 1/26/16.
//  Copyright © 2016 Autonavi. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>

#import "AMap3DObjectOverlayRenderer.h"
#import "FelReaverMount.h"


@interface ViewController ()<MAMapViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) MAMapView * mapView;

@property (nonatomic, strong) AMap3DObjectOverlay *objOverlay;

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

@end

@implementation ViewController

@synthesize singleTap = _singleTap;

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.singleTap && ([touch.view isKindOfClass:[UIControl class]] || [touch.view isKindOfClass:[MAAnnotationView class]]))
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - Action

- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap
{
    CLLocationCoordinate2D destination = [self.mapView convertPoint:[theSingleTap locationInView:self.mapView]
                                               toCoordinateFromView:self.mapView];
    [self setDestinationToReaver:destination];
}

- (void)setDestinationToReaver:(CLLocationCoordinate2D)coordinate
{
    self.objOverlay.coordinate = coordinate;
    AMap3DObjectOverlayRenderer * renderer = (AMap3DObjectOverlayRenderer *)[self.mapView rendererForOverlay:self.objOverlay];
    
    [renderer referenceDidChange];
    [renderer glRender];
}

#pragma mark - map delegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[AMap3DObjectOverlay class]])
    {
        AMap3DObjectOverlayRenderer * reaverRenderer = [[AMap3DObjectOverlayRenderer alloc] initWithObjectOverlay:overlay];
        [reaverRenderer loadStrokeTextureImage:[UIImage imageNamed:@"FelReaverMount"]];
        
        return reaverRenderer;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddOverlayRenderers:(NSArray *)overlayRenderers
{
    MAMapStatus * mapStatus = [mapView getMapStatus];
    mapStatus.centerCoordinate = self.objOverlay.coordinate;
    mapStatus.zoomLevel = 18.f;
    mapStatus.cameraDegree = 60.f;
    mapStatus.rotationDegree = 135.f;
    
    [mapView setMapStatus:mapStatus animated:YES duration:5.f];
}

#pragma mark - override

- (AMap3DObjectOverlay *)objOverlay
{
    if (_objOverlay == nil)
    {
        _objOverlay = [AMap3DObjectOverlay objectOverlayWithCenterCoordinate:self.mapView.centerCoordinate size:200 vertexPointer:FelReaverMountVerts normalPointer:FelReaverMountNormals texCoordPointer:FelReaverMountTexCoords vertsNum:FelReaverMountNumVerts];
    }
    
    return _objOverlay;
}

- (MAMapView *)mapView
{
    if (_mapView == nil)
    {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.zoomLevel = 15.0;
        _mapView.isAllowDecreaseFrame = NO;
        _mapView.showsBuildings = NO;
        _mapView.showsLabels = NO;
        _mapView.mapType = MAMapTypeStandardNight;
    }

    return _mapView;
}

- (UIGestureRecognizer *)singleTap
{
    if (_singleTap == nil)
    {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.delegate = self;
    }
    
    return _singleTap;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set up mapView
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    
    //add overlay
    [self.mapView addOverlay:self.objOverlay];
    
    //add gesture
    [self.view addGestureRecognizer:self.singleTap];
}

@end
