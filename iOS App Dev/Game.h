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
}

@end
