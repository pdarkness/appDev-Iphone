//
//  GameoverLayer.m
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/23/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//
#import "Game.h"
#import "GameoverLayer.h"

@implementation GameoverLayer

+(CCScene *) sceneWithWon:(BOOL)won
{
    CCScene *scene = [CCScene node];
    GameoverLayer *layer = [[GameoverLayer alloc] initWithWon:won];
    [scene addChild:layer];
    return scene;
}

- (id)initWithWon:(BOOL)won {
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        
        NSString * message;
        if (won) {
            message = @"You Won!";
        } else {
            message = @"You Lose :[";
        }
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:32];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
   /*
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[Game _gameNode]];
         }],
          nil]];*/
    }
    return self;
}
@end
