//
//  Coin.h
//  iOS App Dev
//
//  Created by Elisa Erludottir on 9/25/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Coin : CCPhysicsSprite{
    
}

- (id)initWithSpace:(ChipmunkSpace * )space position:(CGPoint)position;
@end
