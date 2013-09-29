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
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"newCoins-hd.plist"];
    self = [super initWithSpriteFrameName:@"coin1.png"];
    if (self)  {
        CGSize size = self.textureRect.size;
        ChipmunkBody *body = [ChipmunkBody staticBody];
        body.pos = position;
        ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
        shape.sensor = YES;
        
        [space addShape:shape];
        
        body.data = self;
        self.chipmunkBody = body;
        
        NSMutableArray *coinAnimFrames = [NSMutableArray array];
        for (int i=1; i<=8 ; i++) {
            [coinAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"coin%d.png", i]
              ]
             ];
        }
        CCAnimation *coinAnim = [CCAnimation animationWithSpriteFrames:coinAnimFrames delay:0.1f];
        _coinAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:coinAnim]];
    }
    return self;
    
}

@end
