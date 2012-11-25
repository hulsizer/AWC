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
#import "CMVertexAttribArrayBuffer.h"
#import <QuartzCore/QuartzCore.h>
#import "CMEffect.h"
struct Vertex {
    GLKVector3 position;
    GLKVector4 color;
    GLKVector2 uvs;
};
@interface GameDirector () <UIScrollViewDelegate>
{
    CADisplayLink *_displayLink;
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) UIScrollView *scroll;
@property (strong, nonatomic) UIView *scrollSubView;
@property (nonatomic, strong) UIView *dummy;
//@property (nonatomic, strong) CMVertexAttribArrayBuffer *verts;
@property (nonatomic, strong) CMEffect *effct;
@property (nonatomic, assign) GLuint vao;
@property (nonatomic, assign) GLuint vbo1;
@property (nonatomic, assign) GLuint vbo2;
@property (nonatomic, strong) CMEffect *effect;
@property (nonatomic, assign) GLKVector3 *verts;
@property (nonatomic, assign) GLKVector4 *colors;
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

- (void)print:(GLKVector3) temp
{
    NSLog(@"%f,%f,%f", temp.x,temp.y,temp.z);
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
    
    self.scene = [[Scene alloc] initWithProjection:GLKMatrix4MakeOrtho(0, 1, 1, 0, -1, 2)];
    
    self.verts = malloc(sizeof(GLKVector3)*6*1*1);
    self.colors = malloc(sizeof(GLKVector4)*6*1*1);
    
    for (int i = 0; i < 1; i++)
    {
        for (int j = 0; j <1; j++)
        {
            GLKVector3 one = GLKVector3Make(i, j, 0);
            GLKVector3 two = GLKVector3Make(i+1, j, 0);
            GLKVector3 three = GLKVector3Make(i+1, j+1, 0);
            GLKVector3 four = GLKVector3Make(i+1, j+1, 0);
            GLKVector3 five = GLKVector3Make(i, j+1, 0);
            GLKVector3 six = GLKVector3Make(i, j, 0);
            
            _verts[(i+j)] = one;
            _verts[(i+j)+1] = two;
            _verts[(i+j)+2] = three;
            _verts[(i+j)+3] = four;
            _verts[(i+j)+4] = five;
            _verts[(i+j)+5] = six;

            GLKVector4 color = GLKVector4Make((rand()%255)/255.0, (rand()%255)/255.0, (rand()%255)/255.0, 1);
            
            _colors[(i+j)+0] = color;
            _colors[(i+j)+1] = color;
            _colors[(i+j)+2] = color;
            _colors[(i+j)+3] = color;
            _colors[(i+j)+4] = color;
            _colors[(i+j)+5] = color;

        }
    }
    
    glGenVertexArraysOES(1, &_vao);
    glBindVertexArrayOES(_vao);
    
    glGenBuffers(1, &_vbo1);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo1);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLKVector3), _verts, GL_STATIC_DRAW);
    
    glBindVertexArrayOES(_vao);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vbo1);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLKVector3), _verts);
    //glEnableVertexAttribArray(GLKVertexAttribColor);
    //glVertexAttribPointer(GLKVertexAttribColor, 4, GL_UNSIGNED_BYTE, GL_TRUE, sizeof(GLKVector4), _colors);
    
    
    // Bind back to the default state.
    glBindVertexArrayOES(0);
    
    self.effect = [[CMEffect alloc] init];
    self.effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(0, 13, 10, 0, -1, 2);
    
    //CMVertexAttribArrayBuffer *verts = [[CMVertexAttribArrayBuffer alloc] initWithAttribStride:(sizeof(float)*2) numberOfVertices:25*25 bytes:bytes usage:GL_STATIC_DRAW];

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
    
    glBindVertexArrayOES(_vao);
    //[self.scene draw];
    [self.effect bindProgram];
    [self.effect bindUniforms];
    
    //for (int i = 0; i < 6; i++) {
    //    [self print:_verts[i]];
    //}
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
    
    glBindVertexArrayOES(0);
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
