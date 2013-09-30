//
//  HUDLayer.m
//  iOS App Dev
//
//  Created by Elisa Erludottir on 9/29/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "HUDLayer.h"

@implementation HUDLayer

+(CCScene *)scene
{
    CCScene *scene = [CCScene node];
    
    HUDLayer *hud = [HUDLayer node];
    
    [scene addChild:hud];
    
    return scene;
}

-(id)init
{
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _scoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize: 17];
        _scoreLabel.position = ccp(winSize.width * 0.85, winSize.height * 0.9);
        [self addChild:_scoreLabel];
    }
    return self;
}

-(void) updatePosition:(CGPoint) point
{
    _scoreLabel.position = point;
}

-(void)setScoreString:(NSString *)scoreString
{
    _scoreLabel.string = scoreString;
}

@end
