//
//  Enemy.m
//  iOS App Dev
//
//  Created by Elisa Erludottir on 9/26/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Enemy.h"


@implementation Enemy

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"newApple-hd.plist"];
    self = [super initWithSpriteFrameName:@"AppleSprite1.png"];
    if (self)  {
        CGSize size = self.textureRect.size;
        ChipmunkBody *body = [ChipmunkBody staticBody];
        position.x -= 20;
        body.pos = position;
        ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width/1.5 height:size.height/1.5];

        shape.sensor = YES;
        
        [space addShape:shape];
        
        body.data = self;
        self.chipmunkBody = body;
        
        NSMutableArray *enemyAnimFrames = [NSMutableArray array];
        for (int i=1; i<=7 ; i++) {
            [enemyAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"AppleSprite%d.png", i]
              ]
             ];
        }
        CCAnimation *enemyAnim = [CCAnimation animationWithSpriteFrames:enemyAnimFrames delay:0.1f];
        _enemyAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:enemyAnim]];
    }
    return self;
}
@end
