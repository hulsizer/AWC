//
//  Scene.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/17/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawableComponent.h"
@interface Scene : NSObject

- (id)initWithProjection:(GLKMatrix4)projectionMatrix size:(CGSize)size;

@property (nonatomic, strong)NSMutableArray *objects;
@property (nonatomic, strong)NSMutableArray *lights;
@property (nonatomic, assign)GLKMatrix4 projectionMatrix;
@property (nonatomic, assign)GLKMatrix4 cameraMatrix;
@property (nonatomic, assign)GLKMatrix4 cameraScaleMatrix;
@property (nonatomic, assign)CGPoint translation;
@property (nonatomic, assign)CGFloat scale;

- (GLKMatrix4)getCamera;
- (CGSize)getSize;
- (void)registerObject:(DrawableComponent*)object;
- (void)deregisterObject:(DrawableComponent*)object;
- (void)draw;
@end
