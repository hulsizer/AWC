//
//  EntityComponent.h
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 12/30/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "Component.h"

@interface SubEntityComponent : Component

@property (nonatomic, strong) NSMutableDictionary *subEntites;
@end
