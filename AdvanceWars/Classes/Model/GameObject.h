//
//  GameObject.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/4/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

static int globalObjectID = 0;

@interface GameObject : NSObject

@property (nonatomic,readonly) int gid;
@end
