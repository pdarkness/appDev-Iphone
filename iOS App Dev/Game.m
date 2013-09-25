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
#import "ChipmunkSpace.h"
#import "Goal.h"


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
        
        // Collision handler
        [_space setDefaultCollisionHandler:self begin:@selector(CollisionStarted:space:) preSolve:nil postSolve:nil separate:nil];
        
        // Add goal
        _goal = [[Goal alloc] initWithSpace:_space position:CGPointFromString(_config[@"goalPos"])];
        [_gameNode addChild: _goal];
        
        // Create our debug node
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        debugNode.visible = NO;
        [self addChild:debugNode];
        
        //Add player
        NSString *startPosition = _config[@"startPosition"];
        _player = [[Player alloc] initWithSpace:_space position:CGPointFromString(startPosition)];
        [_gameNode addChild:_player];
        
        //Add inputLayer
        inputLayer *inputlayer = [[inputLayer alloc] init];
        inputlayer.delegate = self;
        [self addChild:inputlayer];
        
        [self scheduleUpdate];
    }
    return self;
}

- (bool)CollisionStarted:(cpArbiter *)arbiter space:(ChipmunkSpace*)space {
    cpBody *firstBody;
    cpBody *secondBody;
    cpArbiterGetBodies(arbiter, &firstBody, &secondBody);
    ChipmunkBody *firstChipBody = firstBody->data;
    ChipmunkBody *secChipBody = secondBody->data;
    if ((firstChipBody == _player.chipmunkBody && secChipBody == _goal.chipmunkBody) ||
        (firstChipBody == _goal.chipmunkBody && secChipBody == _player.chipmunkBody)) {
        NSLog(@"You hit the goal! =)");
    }
    return YES;
}

- (void)setupLandscape
{
    // Sky
    _sky = [CCLayerGradient layerWithColor:ccc4(255, 87, 145, 255) fadingTo:ccc4(67, 60, 245, 255)];
    [self addChild:_sky];
    
    _parallaxNode = [CCParallaxNode node];
    [self addChild:_parallaxNode];
    
    CCSprite *bottom = [CCSprite spriteWithFile:@"grass_lower2.png"];
    bottom.anchorPoint = ccp(0, 0);
    _landscapeWidth = bottom.contentSize.width;
    [_parallaxNode addChild:bottom z:3 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *top = [CCSprite spriteWithFile:@"grass_up2.png"];
    top.anchorPoint = ccp(0,-1.11f);
    _landscapeWidth = top.contentSize.width;
    [_parallaxNode addChild:top z:3 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    _gameNode = [CCNode node];
    [_parallaxNode addChild:_gameNode z:2 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
}

- (void)setupPhysicsLandscape
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"grass_lower2" withExtension:@"png"];
    ChipmunkImageSampler *sampler = [ChipmunkImageSampler samplerWithImageFile:url isMask:NO];
    ChipmunkPolylineSet *contour = [sampler marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line = [contour lineAtIndex:0];
    ChipmunkPolyline *simpleLine = [line simplifyCurves:1];
    ChipmunkBody *terrainBody = [ChipmunkBody staticBody];
    NSArray * terrainShapes =  [simpleLine asChipmunkSegmentsWithBody:terrainBody radius:0 offset:cpvzero];
    for (ChipmunkShape *shape in terrainShapes) {
        [_space addShape:shape];
    }
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"grass_up2" withExtension:@"png"];
    ChipmunkImageSampler *sampler1 = [ChipmunkImageSampler samplerWithImageFile:url1 isMask:NO];
    ChipmunkPolylineSet *contour1 = [sampler1 marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line1 = [contour1 lineAtIndex:0];
    ChipmunkPolyline *simpleLine1 = [line1 simplifyCurves:1];
    ChipmunkBody *terrainBody1 = [ChipmunkBody staticBody];
    NSArray * terrainShapes1 =  [simpleLine1 asChipmunkSegmentsWithBody:terrainBody1 radius:0 offset:ccp(0, 168)];
    for (ChipmunkShape *shape1 in terrainShapes1) {
        [_space addShape:shape1];
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
    NSString *st = NSStringFromCGPoint(_player.position);
    NSLog(st);
    if (_followPlayer)
    {
        if (_player.position.x >= _winSize.width / 2 && _player.position.x < (_landscapeWidth - (_winSize.width / 2)))
        {
            _parallaxNode.position = ccp(-(_player.position.x - (_winSize.width / 2)), 0);
        }
    }
}


- (void)touchEndedAtPosition:(CGPoint)position afterDelay:(NSTimeInterval)delay
{
    position = [_gameNode convertToNodeSpace:position];
    _followPlayer = YES;
    cpVect normalizedVector = cpvnormalize(cpvsub(position, _player.position));
    [_player jumpWithPower:delay*300 vector:normalizedVector];
}
@end
