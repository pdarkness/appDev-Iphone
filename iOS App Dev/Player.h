//
//  Player.h
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/22/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCPhysicsSprite
{
    ChipmunkSpace *_space;
    cpVect _impulseVector;
}

@property (nonatomic, strong) CCAction *playerAction;
@property (nonatomic) NSInteger playerScore;

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
- (void)jump;
- (void)jumpWithPower:(CGFloat)power vector:(cpVect)vector;
- (NSInteger) updatePlayerScore:(NSInteger) score;
- (NSInteger) updatePlayerScore;
@end
