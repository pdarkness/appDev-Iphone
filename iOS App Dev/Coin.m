//
//  Coin.m
//  iOS App Dev
//
//  Created by Elisa Erludottir on 9/25/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Coin.h"

@implementation Coin
    
- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"newCoins.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"newCoins.png"];
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for (int i=1; i<=8; i++) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"coin%d.png",i]]];
    }
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:walkAnimFrames delay:0.1f];
    
    //CGSize winSize = [[CCDirector sharedDirector] winSize];
    self.coin = [CCSprite spriteWithSpriteFrameName:@"coin1.png"];
    if (self.coin)  {
        CGSize size = self.coin.textureRect.size;
        ChipmunkBody *body = [ChipmunkBody staticBody];
        body.pos = position;
        ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
        shape.sensor = YES;
        
        [space addShape:shape];
        
        body.data = self;
        self.chipmunkBody = body;
    }
    self.coin.position = position;
    self.coinAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim]];
    [self.coin runAction:self.coinAction];
    [spriteSheet addChild:self.coin];
    return self;
    
}



@end
