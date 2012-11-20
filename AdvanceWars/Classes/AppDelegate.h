//
//  AppDelegate.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/8/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameDirector;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GameDirector *viewController;

@end
