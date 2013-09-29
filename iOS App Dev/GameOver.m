//
//  GameOver.m
//  iOS App Dev
//
//  Created by Elisa Erludottir on 9/26/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "GameOver.h"
#import "cocos2d.h"
#import "Game.h"

@implementation GameOver

-(id)initGameOver:(NSInteger)playerScore :(BOOL)won
{
    if ((self = [super init])) {
        NSString *message;
        if (won) {
            message = [NSString stringWithFormat:@"Congratulations my friend you won\n You scored %d points\nPlay Again", playerScore];
        } else {
            message = [NSString stringWithFormat:@"Sorry my friend you lost\n You scored %d points\nPlay Again", playerScore];
        }
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCLabelTTF *label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:22];
        
        
        CCMenuItemLabel *button = [CCMenuItemLabel itemWithLabel:label block:^(id sender)
                                   {
                                       Game *game = [[Game alloc] init];
                                       [[CCDirector sharedDirector] replaceScene:game];
                                   }];
        button.position = ccp(winSize.width / 2, winSize.height / 2);
        
        CCMenu *menu = [CCMenu menuWithItems:button, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    return self;
}

@end
