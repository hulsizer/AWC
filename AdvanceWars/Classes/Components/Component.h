//
//  Component.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/11/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Component : NSObject
{
    NSString* type;
}

- (void)update;

@property (nonatomic, readonly) NSString* type;
@end
