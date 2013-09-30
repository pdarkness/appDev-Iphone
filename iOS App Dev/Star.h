//
//  Star.h
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/30/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Star : CCPhysicsSprite
{
    
}

- (id)initWithSpace:(ChipmunkSpace * )space position:(CGPoint)position;

@property (nonatomic, strong) CCAction *starAction;


@end
