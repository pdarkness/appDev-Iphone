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
#import "Coin.h"
#import "Enemy.h"
#import "GameOver.h"

@implementation Game

#pragma mark - Initilization

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
        [self generateRandomWind];
        [self setupLandscape];
        [self setupPhysicsLandscape];
        
        // Collision handler
        [_space setDefaultCollisionHandler:self begin:@selector(CollisionStarted:space:) preSolve:nil postSolve:nil separate:nil];
        
        // Add goal
        _goal = [[Goal alloc] initWithSpace:_space position:CGPointFromString(_config[@"goalPos"])];
        [_gameNode addChild: _goal];
        
        //Add coin
        CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"newCoins-hd.png"];
        _coin = [[Coin alloc] initWithSpace:_space position:CGPointFromString(_config[@"coinPos"])];
        [_gameNode addChild:batchNode];
        [_coin runAction:_coin.coinAction];
        [batchNode addChild:_coin];
        
        //Add enemy
        CCSpriteBatchNode *enemyBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"newApple-hd.png"];
        _enemy = [[Enemy alloc] initWithSpace:_space position:CGPointFromString(_config[@"enemyPos"])];
        [_gameNode addChild:enemyBatchNode];
        [_enemy runAction:_enemy.enemyAction];
        [enemyBatchNode addChild:_enemy];
        
        // Create our debug node
        CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
        debugNode.visible = YES;
        [_gameNode addChild:debugNode];
        
        //Add player
        CCSpriteBatchNode *playerBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"ghost-hd.png"];
        _player = [[Player alloc] initWithSpace:_space position:CGPointFromString(_config[@"startPosition"])];
        [_gameNode addChild:playerBatchNode];
        [_player runAction:_player.playerAction];
        [playerBatchNode addChild:_player];
        
        _sound = [[SoundEffects alloc] init];
        
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
        [_sound playSounds:@"goal"];
        GameOver *gameOver = [[GameOver alloc] initGameOver:_player.playerScore :YES];
        [[CCDirector sharedDirector] replaceScene:gameOver];
    }
    if ((firstChipBody == _player.chipmunkBody && secChipBody == _coin.chipmunkBody) ||
        (firstChipBody == _coin.chipmunkBody && secChipBody == _player.chipmunkBody)) {
        NSLog(@"You got the coin! =)");
        [_sound playSounds:@"coin"];
        [_player updatePlayerScore:1000];
        [_coin removeFromParentAndCleanup:YES];
    }
    if ((firstChipBody == _player.chipmunkBody && secChipBody == _enemy.chipmunkBody) ||
        (firstChipBody == _enemy.chipmunkBody && secChipBody == _player.chipmunkBody)) {
        NSLog(@"GAME OVER! =)");
        [_sound playSounds:@"suck"];
        GameOver *menu = [[GameOver alloc] initGameOver:_player.playerScore :NO];
        [[CCDirector sharedDirector] replaceScene:menu];
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
    
    CCSprite *bottom = [CCSprite spriteWithFile:@"ground2.png"];
    bottom.anchorPoint = ccp(0, 0);
    _landscapeWidth = bottom.contentSize.width;
    [_parallaxNode addChild:bottom z:3 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    CCSprite *top = [CCSprite spriteWithFile:@"top.png"];
    top.anchorPoint = ccp(0,-0.01f);
    [_parallaxNode addChild:top z:3 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    _gameNode = [CCNode node];
    [_parallaxNode addChild:_gameNode z:2 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:CGPointZero];
    
    _hud = [[HUDLayer alloc] init];
    [_parallaxNode addChild:_hud z:4 parallaxRatio:ccp(1.0f,1.0f) positionOffset: ccp(0, 0)];
    [self updateScore];
}

-(void) updateScore
{
    [_hud setScoreString:[NSString stringWithFormat:@"Score : %d", _player.playerScore]];
}

- (void)setupPhysicsLandscape
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ground2" withExtension:@"png"];
    ChipmunkImageSampler *sampler = [ChipmunkImageSampler samplerWithImageFile:url isMask:NO];
    ChipmunkPolylineSet *contour = [sampler marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line = [contour lineAtIndex:0];
    ChipmunkPolyline *simpleLine = [line simplifyCurves:1];
    ChipmunkBody *terrainBody = [ChipmunkBody staticBody];
    NSArray * terrainShapes =  [simpleLine asChipmunkSegmentsWithBody:terrainBody radius:0 offset:cpvzero];
    for (ChipmunkShape *shape in terrainShapes) {
        [_space addShape:shape];
    }
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"top" withExtension:@"png"];
    ChipmunkImageSampler *sampler1 = [ChipmunkImageSampler samplerWithImageFile:url1 isMask:NO];
    ChipmunkPolylineSet *contour1 = [sampler1 marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line1 = [contour1 lineAtIndex:0];
    ChipmunkPolyline *simpleLine1 = [line1 simplifyCurves:1];
    ChipmunkBody *terrainBody1 = [ChipmunkBody staticBody];
    NSArray * terrainShapes1 =  [simpleLine1 asChipmunkSegmentsWithBody:terrainBody1 radius:0 offset:cpvzero];
    for (ChipmunkShape *shape1 in terrainShapes1) {
        [_space addShape:shape1];
    }
}

-(void)generateRandomWind
{
    _windSpeed = CCRANDOM_MINUS1_1()*[_config[@"winMaxSpeed"] floatValue];
}

#pragma mark - Update

- (void)update:(ccTime)delta
{
    CGFloat fixedTimeStep = 1.0f / 240.0f;
    _accumulator += delta;
    while (_accumulator > fixedTimeStep) {
        [_space step:fixedTimeStep];
        _accumulator -= fixedTimeStep;
    }
    
   // NSString *st = NSStringFromCGPoint(_player.position);
    //NSLog(st);
    [self updateScore];
    if (_followPlayer == YES)
    {
        //_impulseVector = cpv(_player.chipmunkBody.mass/50, _player.chipmunkBody.mass/10);
        //[_player.chipmunkBody applyForce:_impulseVector offset:cpvzero];
        if (_player.position.x >= _winSize.width / 2 && _player.position.x <
            (_landscapeWidth - (_winSize.width / 2)))
        {
            _parallaxNode.position = ccp(-(_player.position.x - (_winSize.width / 2)), 0);
            [_hud updatePosition:ccp(_player.position.x + (_winSize.width * .35), _winSize.height * 0.9)];
            [self updateLandscapeAndElements:delta];
            [_player updatePlayerScore];
        }
        
        if(_player.position.x >= _landscapeWidth)
        {
            GameOver *menu = [[GameOver alloc] initGameOver:_player.playerScore :NO];
            [[CCDirector sharedDirector] replaceScene:menu];
        }
        
    }
}

-(void)updatePhysicsLandscape
{

}

-(void)updateLandscapeAndElements:(ccTime)delta
{
    [self updatePhysicsLandscape];
    //_landscapeWidth += 50;
}

#pragma mark - My Touch Delegate Methods

- (void)touchEndedAtPosition:(CGPoint)position afterDelay:(NSTimeInterval)delay
{
    position = [_gameNode convertToNodeSpace:position];
    NSLog(@"touch: %@", NSStringFromCGPoint(position));
    NSLog(@"player: %@", NSStringFromCGPoint(_player.position));
    _followPlayer = YES;
    cpVect normalizedVector = cpvnormalize(cpvsub(position, _player.position));

    [_player jump];
}
@end
