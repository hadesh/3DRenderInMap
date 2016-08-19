//
//  AMap3DObjectOverlayRenderer.h
//  reaverInMap
//
//  Created by xiaoming han on 16/8/19.
//  Copyright © 2016年 Autonavi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "AMap3DObjectOverlay.h"

@interface AMap3DObjectOverlayRenderer : MAOverlayRenderer

@property (nonatomic, readonly) AMap3DObjectOverlay *objOverlay;

- (instancetype)initWithObjectOverlay:(AMap3DObjectOverlay *)objOverlay;

@end
