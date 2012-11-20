//
//  GraphicsRenderer.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/16/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "GraphicsRenderer.h"
#import "DrawableComponent.h"
#import "ShaderManager.h"
#import "TextureManager.h"
#import "TextureGroup.h"
#import "Shader.h"
@interface GraphicsRenderer()

@property (nonatomic, strong) NSMutableDictionary *objects;

@end

@implementation GraphicsRenderer

- (void)draw
{
    for (NSString *programDictionaryKey in [self.objects allKeys])
    {
        //Bind program
        Shader* shader = [[ShaderManager sharedInstance] programForKey:programDictionaryKey];
        [shader bind];
        for (NSString *textureDictionaryKey in [[self.objects objectForKey:programDictionaryKey] allKeys])
        {
            //Bind texture
            //or textures
            TextureGroup *textureGroup = [[[TextureManager alloc] init] texturesForKey:textureDictionaryKey];
            [textureGroup bind];
            for (DrawableComponent *object in [[self.objects objectForKey:programDictionaryKey] objectForKey:textureDictionaryKey])
            {
                //bind vertex attrib
                [object draw:GLKMatrix4Identity];
            }
        }
    }
}

- (void)addDrawableComponent:(DrawableComponent *)component
{
    /*if ([self.objects objectForKey:component.shader.identifer]) {
        //Check Textures
        if ([[self.objects objectForKey:component.shader.identifer] objectForKey:component.textureGroup.identifer]) {
            //Add Object
            [[[self.objects objectForKey:component.shader.identifer] objectForKey:component.textureGroup.identifer] setObject:component forKey:@"Object"];
        }else{
            NSMutableDictionary *textures = [[NSMutableDictionary alloc] initWithObjects:@[component] forKeys:@[@"Object"]];
            [[self.objects objectForKey:component.shader.identifer] setObject:textures forKey:[component.textureGroup identifer]];
        }
    }else{
        NSMutableDictionary *textures = [[NSMutableDictionary alloc] initWithObjects:@[component] forKeys:@[@"Object"]];
        NSMutableDictionary *shader = [[NSMutableDictionary alloc] initWithObjects:@[textures] forKeys:@[[component.textureGroup identifer]]];
        [self.objects setObject:shader forKey:[component.shader identifer]];
    }*/
}
@end
