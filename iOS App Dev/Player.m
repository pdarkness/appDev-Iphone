//
//  Player.m
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/22/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ghost-hd.plist"];
    self = [super initWithSpriteFrameName:@"mon1.png"];
    if (self)
    {
        _space = space;
        
        if (_space != nil)
        {
            CGSize size = self.textureRect.size;
            cpFloat mass = size.width * size.height;
            cpFloat momentum = cpMomentForBox(mass, size.width, size.height);
            
            ChipmunkBody *body = [ChipmunkBody bodyWithMass:mass andMoment:momentum];
            body.pos = position;
            ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
            
            // Add this to our space
            [_space addBody:body];
            [_space addShape:shape];
            
            // Add sprite
            self.chipmunkBody = body;
            
            // Initialize player score
            self.playerScore = 0;
            
            NSMutableArray *playerAnimFrames = [NSMutableArray array];
            for (int i=1; i<=5 ; i++) {
                [playerAnimFrames addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:@"mon%d.png", i]
                  ]
                 ];
            }
            CCAnimation *playerAnim = [CCAnimation animationWithSpriteFrames:playerAnimFrames delay:0.1f];
            _playerAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:playerAnim]];

        }
    }
    return self;
}

// Update player score if he collides with a coin or some object
- (NSInteger) updatePlayerScore:(NSInteger)score
{
    return self.playerScore += score;
}

// Update player score according to the distance he travels
- (NSInteger) updatePlayerScore
{
    return self.playerScore++;
}

- (void)jump
{
    _impulseVector = cpv(30*self.chipmunkBody.mass, 70*self.chipmunkBody.mass);
    [self.chipmunkBody applyImpulse:_impulseVector offset:cpvzero];
}


- (void)jumpWithPower:(CGFloat)power vector:(cpVect)vector
{
    //vector = ccp(0, 35535);
    cpVect impulseVector = cpvmult(vector, self.chipmunkBody.mass * power);
    [self.chipmunkBody applyImpulse:impulseVector offset:cpvzero];
}
@end
