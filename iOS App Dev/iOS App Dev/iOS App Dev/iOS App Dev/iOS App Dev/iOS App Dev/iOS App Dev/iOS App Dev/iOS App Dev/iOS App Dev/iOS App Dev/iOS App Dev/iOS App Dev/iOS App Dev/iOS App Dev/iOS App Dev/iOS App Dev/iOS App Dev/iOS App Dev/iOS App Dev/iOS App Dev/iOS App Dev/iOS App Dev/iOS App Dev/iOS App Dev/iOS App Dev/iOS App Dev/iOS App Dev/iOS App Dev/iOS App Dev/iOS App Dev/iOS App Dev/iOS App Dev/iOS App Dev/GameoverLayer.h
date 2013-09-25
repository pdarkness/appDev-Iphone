//
//  GameoverLayer.h
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/23/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "cocos2d.h"

@interface GameoverLayer : CCLayerColor

+(CCScene *) sceneWithWon:(BOOL)won;
- (id)initWithWon:(BOOL)won;

@end
