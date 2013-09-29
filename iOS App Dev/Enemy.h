//
//  Enemy.h
//  iOS App Dev
//
//  Created by Elisa Erludottir on 9/26/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Enemy : CCPhysicsSprite{
    
}

- (id)initWithSpace:(ChipmunkSpace * )space position:(CGPoint)position;

@property (nonatomic, strong) CCAction *enemyAction;

@end
