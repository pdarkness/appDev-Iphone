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
#import "Star.h"

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
        
        // Create Elemntes
        [self createGoal];
        [self createStars];
        [self createParticleSystemWater];
        [self createParticleSystemFire];
        [self createCoins];
        [self createEnemys];
        [self createPlayer];
        [self createDebugNode:NO];
        [self initSound];
        [self initInputLayer];
        
        [self scheduleUpdate];
    }
    return self;
}

- (id)initWithPoints:(NSInteger)totalPointsBeforeThisGame
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
        
        // Create Elemntes
        [self createGoal];
        [self createStars];
        [self createParticleSystemWater];
        [self createParticleSystemFire];
        [self createCoins];
        [self createEnemys];
        [self createPlayer];
        _player.playerScore = totalPointsBeforeThisGame;
        [self createDebugNode:NO];
        [self initSound];
        [self initInputLayer];
        
        [self scheduleUpdate];
    }
    return self;
}

- (bool)CollisionStarted:(cpArbiter *)arbiter space:(ChipmunkSpace*)space {
    Coin *coin;
    if ([self collisionWithGoal:arbiter]) {
        NSLog(@"You hit the goal! =)");
        [_sound playSounds:@"goal"];
        [self performSelector:@selector(gameOverAndWon) withObject:nil];
    }
    if ((coin = [self collisionWithCoins:arbiter])) {
        NSLog(@"You got the coin! =)");
        [_sound playSounds:@"coin"];
        [_player updatePlayerScore:1000];
        [coin removeFromParentAndCleanup:YES];
    }
    if ([self collisionWithEnemys:arbiter]) {
        NSLog(@"GAME OVER! =)");
        [_sound playSounds:@"suck"];
        [self performSelector:@selector(gameOverAndNotWon) withObject:_goal afterDelay:0.1];
    }
    if ([self collisionWithStar:arbiter]) {
        NSLog(@"You got a star jei =D");
        [_sound playSounds:@"star"];
        cpVect vec = _player.position;
        _player.playerScore += 5000;
        vec.x += _player.position.x + 125000;
        [[_player chipmunkBody] applyImpulse:vec offset:cpvzero];
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
    
    CCSprite *top = [CCSprite spriteWithFile:@"top2.png"];
    top.anchorPoint = ccp(0,-1.31f);
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
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"top2" withExtension:@"png"];
    ChipmunkImageSampler *sampler1 = [ChipmunkImageSampler samplerWithImageFile:url1 isMask:NO];
    ChipmunkPolylineSet *contour1 = [sampler1 marchAllWithBorder:NO hard:YES];
    ChipmunkPolyline *line1 = [contour1 lineAtIndex:0];
    ChipmunkPolyline *simpleLine1 = [line1 simplifyCurves:1];
    ChipmunkBody *terrainBody1 = [ChipmunkBody staticBody];
    NSArray * terrainShapes1 =  [simpleLine1 asChipmunkSegmentsWithBody:terrainBody1 radius:0 offset:ccp(0, 184)];
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
    CGFloat oldPlayerPositionX = _player.position.x;
    CGFloat fixedTimeStep = 1.0f / 240.0f;
    _accumulator += delta;
    while (_accumulator > fixedTimeStep) {
        [_space step:fixedTimeStep];
        _accumulator -= fixedTimeStep;
    }
    [self updateScore];
    if (_followPlayer == YES)
    {
        if (_player.position.x >= _winSize.width / 2 && _player.position.x <
            (_landscapeWidth - (_winSize.width / 2)))
        {
            _parallaxNode.position = ccp(-(_player.position.x - (_winSize.width / 2)), 0);
            [_hud updatePosition:ccp(_player.position.x + (_winSize.width * .35), _winSize.height * 0.9)];
            [self updateLandscapeAndElements:delta];
            if(oldPlayerPositionX < _player.position.x)
                [_player updatePlayerScore];
        }
        if(_player.position.x >= _landscapeWidth)
        {
            [self performSelector:@selector(gameOverAndNotWon) withObject:_player afterDelay:1.7];
        }
        
    }
}

- (void)gameOverAndWon
{
    GameOver *menu = [[GameOver alloc] initGameOver:_player.playerScore :YES];
    [[CCDirector sharedDirector] replaceScene:menu];
}

- (void)gameOverAndNotWon
{
    GameOver *menu = [[GameOver alloc] initGameOver:_player.playerScore :NO];
    [[CCDirector sharedDirector] replaceScene:menu];
}

- (void)createParticleSystemWater
{
    _splashParticles = [CCParticleSystemQuad particleWithFile:@"WaterSplash.plist"];
    [_splashParticles stopSystem];
    [_gameNode addChild:_splashParticles];
}

- (void)createParticleSystemFire
{
    _fireParticles = [CCParticleSystemQuad particleWithFile:@"particleFire.plist"];
    [_fireParticles stopSystem];
    [_gameNode addChild:_fireParticles];
}

-(Coin *)collisionWithCoins:(cpArbiter *)arbiter
{
    cpBody *firstBody;
    cpBody *secondBody;
    cpArbiterGetBodies(arbiter, &firstBody, &secondBody);
    ChipmunkBody *firstChipBody = firstBody->data;
    ChipmunkBody *secChipBody = secondBody->data;
    for (Coin *coin in _coinBatchNode.children) {
        if ((firstChipBody == _player.chipmunkBody && secChipBody == coin.chipmunkBody) ||
            (firstChipBody == coin.chipmunkBody && secChipBody == _player.chipmunkBody)) {
            return coin;
        }
    }
    return nil;
}

-(bool) collisionWithEnemys:(cpArbiter *)arbiter
{
    cpBody *firstBody;
    cpBody *secondBody;
    cpArbiterGetBodies(arbiter, &firstBody, &secondBody);
    ChipmunkBody *firstChipBody = firstBody->data;
    ChipmunkBody *secChipBody = secondBody->data;
    for (Enemy *enm in _enemyBatchNode.children) {
        if ((firstChipBody == _player.chipmunkBody && secChipBody == enm.chipmunkBody) ||
            (firstChipBody == enm.chipmunkBody && secChipBody == _player.chipmunkBody)) {
            return YES;
        }
    }
    return NO;
}

-(bool) collisionWithStar:(cpArbiter *)arbiter
{
    cpBody *firstBody;
    cpBody *secondBody;
    cpArbiterGetBodies(arbiter, &firstBody, &secondBody);
    ChipmunkBody *firstChipBody = firstBody->data;
    ChipmunkBody *secChipBody = secondBody->data;
    for (Star *star in _starBatchNode.children) {
        if ((firstChipBody == _player.chipmunkBody && secChipBody == star.chipmunkBody) ||
            (firstChipBody == star.chipmunkBody && secChipBody == _player.chipmunkBody)) {
            _splashParticles.position = star.position;
            [_splashParticles resetSystem];
            [star removeFromParentAndCleanup:YES];
            return YES;
        }
    }
    return NO;
}

-(bool) collisionWithGoal:(cpArbiter *)arbiter
{
    cpBody *firstBody;
    cpBody *secondBody;
    cpArbiterGetBodies(arbiter, &firstBody, &secondBody);
    ChipmunkBody *firstChipBody = firstBody->data;
    ChipmunkBody *secChipBody = secondBody->data;
        if ((firstChipBody == _player.chipmunkBody && secChipBody == _goal.chipmunkBody) ||
            (firstChipBody == _goal.chipmunkBody && secChipBody == _player.chipmunkBody)) {
            _fireParticles.position = _goal.position;
            [_fireParticles resetSystem];
            [_goal removeFromParentAndCleanup:YES];
            return YES;
        }
    return NO;
}



-(void)updatePhysicsLandscape
{

}

-(void)updateLandscapeAndElements:(ccTime)delta
{
    [self updatePhysicsLandscape];
}


-(void)initSound
{
    _sound = [[SoundEffects alloc] init];
}

-(void)initInputLayer
{
    inputLayer *inputlayer = [[inputLayer alloc] init];
    inputlayer.delegate = self;
    [self addChild:inputlayer];
}

-(void)createDebugNode:(BOOL) ok
{
    CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForChipmunkSpace:_space];
    debugNode.visible = ok;
    [_gameNode addChild:debugNode];
}

-(void)createPlayer
{
    CCSpriteBatchNode *playerBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"ghost-hd.png"];
    _player = [[Player alloc] initWithSpace:_space position:CGPointFromString(_config[@"startPosition"])];
    [_gameNode addChild:playerBatchNode];
    [_player runAction:_player.playerAction];
    _impulseVector = cpv(_player.position.x+100, _player.position.y);
    [_player.chipmunkBody applyForce:_impulseVector offset:cpvzero];
    [playerBatchNode addChild:_player];
}

-(void)createCoins
{
    _coinBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"newCoins-hd.png"];
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"newCoins-hd.png"];
    [_gameNode addChild:_coinBatchNode];
    [_gameNode addChild:batchNode];
    for (int i = 0; i < 20; i++) {
        _coin = [[Coin alloc] initWithSpace:_space position:ccp(CCRANDOM_0_1() * _landscapeWidth, CCRANDOM_0_1() * (_winSize.height - 100))];
        [_coin runAction:_coin.coinAction];
        [_coinBatchNode addChild:_coin];
    }
}

-(void)createEnemys
{
    _enemyBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"newApple-hd.png"];
    [_gameNode addChild:_enemyBatchNode];
    for (int i = 0; i < 8; i++) {
        Enemy *en = [[Enemy alloc] initWithSpace:_space position:ccp((CCRANDOM_0_1() * _landscapeWidth) + 200, (CCRANDOM_0_1() * (_winSize.height - 100)))];
        [en runAction:en.enemyAction];
        [_enemyBatchNode addChild:en];
    }
}

-(void)createStars
{
    _starBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"star.png"];
    [_gameNode addChild:_starBatchNode];
    for (int i = 0; i < 3; i++) {
        Star *st = [[Star alloc] initWithSpace:_space position:ccp((CCRANDOM_0_1() * _landscapeWidth) + 200, (CCRANDOM_0_1() * (_winSize.height - 100)))];
        [st runAction:st.starAction];
        [_starBatchNode addChild:st];
    }
}


-(void)createGoal
{
    _goal = [[Goal alloc] initWithSpace:_space position:CGPointFromString(_config[@"goalPos"])];
    [_gameNode addChild: _goal];
}

#pragma mark - My Touch Delegate Methods

- (void)touchEndedAtPosition:(CGPoint)position afterDelay:(NSTimeInterval)delay
{
    position = [_gameNode convertToNodeSpace:position];
   // NSLog(@"touch: %@", NSStringFromCGPoint(position));
    //NSLog(@"player: %@", NSStringFromCGPoint(_player.position));
    _followPlayer = YES;

    cpVect normalizedVector = cpvnormalize(cpvsub([self touchedPositionAgainstPlayer:position], _player.position));

    [_player jumpWithPower:delay*600 vector:normalizedVector];
}
-(CGPoint) touchedPositionAgainstPlayer: (CGPoint)position
{
    if (position.x < _player.position.x) {
        position.x += _winSize.width/2;
    }
    return position;
}
@end
