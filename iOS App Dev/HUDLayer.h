//
//  HUDLayer.h
//  iOS App Dev
//
//  Created by Elisa Erludottir on 9/29/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface HUDLayer : CCLayer {
    CCLabelTTF *_scoreLabel;
}

+(CCScene *) scene;
-(void) setScoreString:(NSString *) scoreString;
-(void) updatePosition:(CGPoint) point;

@end
