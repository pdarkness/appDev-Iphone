//
//  Game.h
//  iOS App Dev
//
//  Created by Sveinn Fannar Kristjansson on 9/17/13.
//  Copyright 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "inputLayer.h"
#import "Goal.h"
#import "Coin.h"
#import "Enemy.h"
#import "HUDLayer.h"
#import "SoundEffects.h"

@class SoundEffects;
@interface Game : CCScene <InputLayerDelgate>
{
    CGSize _winSize;
    NSDictionary *_config;
    CCLayerGradient *_sky;
    Player *_player;
    BOOL _followPlayer;
    CCParallaxNode *_parallaxNode;
    CGFloat _landscapeWidth;
    CCNode *_gameNode;
    ChipmunkSpace *_space;
    ccTime _accumulator;
    Goal *_goal;
    Coin *_coin;
    Enemy *_enemy;
    CGFloat _windSpeed;
    cpVect _impulseVector;
    HUDLayer *_hud;
    SoundEffects *_sound;
    CCSpriteBatchNode *_enemyBatchNode;
    CCSpriteBatchNode *_starBatchNode;
    CCSpriteBatchNode *_coinBatchNode;
}

- (id)initWithPoints:(NSInteger)totalPointsBeforeThisGame;

@property (nonatomic, strong) CCSprite *coinA;
@property (nonatomic, strong) CCAction *coinAction;

@end
