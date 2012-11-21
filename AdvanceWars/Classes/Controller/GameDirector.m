//
//  GameDirector.m
//  AdvanceWars
//
//  Created by Andrew Hulsizer on 11/11/12.
//  Copyright (c) 2012 Andrew Hulsizer. All rights reserved.
//

#import "GameDirector.h"
#import "Component.h"
#import "PositionComponent.h"
#import "Scene.h"
#import "Tile.h"
#import <QuartzCore/QuartzCore.h>
@interface GameDirector () <UIScrollViewDelegate>
{
    CADisplayLink *_displayLink;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UIView *scrollSubView;
@property (nonatomic, strong) UIView *dummy;
@end

@implementation GameDirector

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    
    lua_settop(L, 0);
    
    int error;
    
    error = luaL_loadstring(L, "print(\"Hello World\")");
    if (0 != error) {
        luaL_error(L, "cannot compile lua file: %s",
                   lua_tostring(L, -1));
        return;
        
    }
    
    error = lua_pcall(L, 0, 0, 0);
    if (0 != error) {
        luaL_error(L, "cannot run lua file: %s",
                   lua_tostring(L, -1));
        return;
    }
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
    self.scene = [[Scene alloc] initWithProjection:GLKMatrix4MakeOrtho(0, 13, 10, 0, -1, 2)];
    
    for (int i = 0; i < 25; i++)
    {
        for (int j = 0; j <25; j++)
        {
            Tile *tile = [[Tile alloc] initWithPoint:CGPointMake(i, j)];
            [self registerObject:tile.drawingComponent];
            [self registerObject:tile.positionComponent];
        }
    }
	
    
    self.scroll = [[UIScrollView alloc] init];
    self.scroll.frame = self.view.bounds;
    [self.scroll setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    self.scroll.contentSize = CGSizeMake(25*(1024.0f/13),25*(768.0f/10));
    self.scroll.maximumZoomScale = 1.5;
    self.scroll.minimumZoomScale = .75;
    self.scroll.hidden = YES;
    self.scroll.delegate = self;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scroll];
    
	CGSize temp = CGSizeMake(25*(1024.0f/13),25*(768.0f/10));
    self.dummy = [[UIView alloc] initWithFrame:CGRectMake(0, 0, temp.width, temp.height)];
    [self.scrollSubView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [self.scroll addSubview:self.dummy];
   
    self.scrollSubView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.scrollSubView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    //[self.scrollSubView setBackgroundColor:[UIColor redColor]];
    [self.scrollSubView addGestureRecognizer:self.scroll.panGestureRecognizer];
    [self.scrollSubView addGestureRecognizer:self.scroll.pinchGestureRecognizer];
    [self.view addSubview:self.scrollSubView];

}

- (void)viewDidAppear:(BOOL)animated
{
    self.scroll.contentSize = CGSizeMake(25*(CGRectGetWidth(self.view.bounds)/13),25*(CGRectGetHeight(self.view.bounds)/10));
    [self.dummy setFrame:CGRectMake(0, 0, 25*(CGRectGetWidth(self.view.bounds)/13), 25*(CGRectGetHeight(self.view.bounds)/10))];
}
- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Set up for OpenGl

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];    
}


#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.scene draw];
}

- (void)display
{
    GLKView *tempView = (GLKView*)self.view;
    [tempView display];
}

#pragma mark - Object Managment
- (void)registerObject:(Component*)object
{
    if (object.type == e_GRAPHICS) {
        [self.scene registerObject:(DrawableComponent*)object];
    }
}

- (void)deregisterObject:(Component*)object
{
    if (object.type == e_GRAPHICS) {
        [self.scene deregisterObject:(DrawableComponent*)object];
    }
}

#pragma mark - ScrollView delegates

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.dummy;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [self stopDisplayLink];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.scene.scale = scrollView.zoomScale;
    //self.scene.cameraScaleMatrix = GLKMatrix4Scale(GLKMatrix4Identity, scrollView.zoomScale, scrollView.zoomScale, 0);
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    [self startDisplayLinkIfNeeded];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //set translate
    CGPoint translatedPoint = CGPointMake(-scrollView.contentOffset.x/(CGRectGetWidth(self.view.bounds)/13), -scrollView.contentOffset.y/(CGRectGetHeight(self.view.bounds)/10));
    
    self.scene.translation = translatedPoint;
    //self.scene.cameraMatrix = GLKMatrix4Translate(GLKMatrix4Identity, translatedPoint.x, translatedPoint.y, 0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self startDisplayLinkIfNeeded];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stopDisplayLink];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stopDisplayLink];
    }
}

- (void)startDisplayLinkIfNeeded
{
    if(!_displayLink)
    {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(display)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopDisplayLink
{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
   return YES;
}
@end
