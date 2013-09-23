//
//  Game.m
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Game.h"
#import "Player.h"
#import "inputLayer.h"
#import "ChipmunkAutoGeometry.h"


@implementation Game

- (id)init
{
    self = [super init];
    if (self)
    {
        _config = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                              pathForResource:@"Config" ofType:@"plist"]];
        _winSize = [CCDirector sharedDirector].winSize;
        
        // ChipmunkSpace physics
        _space = [[ChipmunkSpace alloc] init];
        CGFloat gravity = [_config[@"gravity"] floatValue];
        _space.gravity = ccp(0.0f, -gravity);
        
        // Setup world
        [self setupLandscape];
        [self setupPhysicsLandscape];
        
        // Create our debug node
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        debugNode.visible = NO;
        [self addChild:debugNode];
        
        //Add player
        NSString *startPosition = _config[@"startPosition"];
        _player = [[Player alloc] initWithSpace:_space position:CGPointFromString(startPosition)];
        [self addChild:_player];
        
        //Add inputLayer
        inputLayer *inputlayer = [[inputLayer alloc] init];
        inputlayer.delegate = self;
        [self addChild:inputlayer];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)setupLandscape
{
    // Sky
    _sky = [CCLayerGradient layerWithColor:ccc4(255, 67, 245, 255) fadingTo:ccc4(67, 60, 245, 255)];
    [self addChild:_sky];
    
    _parallaxNode = [CCParallaxNode node];
    [self addChild:_parallaxNode];
    /*
    CCSprite *bottom = [CCSprite spriteWithFile:@"testDown.png"];
    bottom.anchorPoint = ccp(0, 0);
    [_parallaxNode addChild:bottom z:0 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    */
    CCSprite *top = [CCSprite spriteWithFile:@"testDown2.png"];
    top.anchorPoint = ccp(0, 0);
    _landscapeWidth = top.contentSize.width;
    [_parallaxNode addChild:top z:1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    _gameNode = [CCNode node];
    [_parallaxNode addChild:_gameNode z:2 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
}

- (void)setupPhysicsLandscape
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"testDown2" withExtension:@"png"];
    ChipmunkImageSampler *sampler = [ChipmunkImageSampler samplerWithImageFile:url isMask:NO];
    ChipmunkPolylineSet *contour = [sampler marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line = [contour lineAtIndex:0];
    ChipmunkPolyline *simpleLine = [line simplifyCurves:1];
    ChipmunkBody *terrainBody = [ChipmunkBody staticBody];
    NSArray * terrainShapes =  [simpleLine asChipmunkSegmentsWithBody:terrainBody radius:0 offset:cpvzero];
    for (ChipmunkShape *shape in terrainShapes) {
        [_space addShape:shape];
    }
}

- (void)update:(ccTime)delta
{
    CGFloat fixedTimeStep = 1.0f / 240.0f;
    _accumulator += delta;
    while (_accumulator > fixedTimeStep) {
        [_space step:fixedTimeStep];
        _accumulator -= fixedTimeStep;
    }
    
    if (_followPlayer)
    {
        if (_player.position.x >= (_winSize.width / 2) && _player.position.x < (_landscapeWidth - (_winSize.width / 2)))
        {
            _parallaxNode.position = ccp(-(_player.position.x - (_winSize.width / 2)), 0);
        }
    }
}


- (void)touchEndedAtPosition:(CGPoint)position afterDelay:(NSTimeInterval)delay
{
    _followPlayer = YES;
    cpVect normalizedVector = cpvnormalize(cpvsub(position, _player.position));
    [_player jumpWithPower:delay*1000 vector:normalizedVector];
}
@end
