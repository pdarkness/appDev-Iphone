//
//  Goal.h
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/25/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Goal : CCPhysicsSprite{
    
}

- (id)initWithSpace:(ChipmunkSpace * )space position:(CGPoint)position;

@end
