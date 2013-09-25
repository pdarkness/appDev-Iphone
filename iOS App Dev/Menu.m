//
//  Menu.m
//  iOS App Dev
//
//  Created by Elisa Erludottir on 9/25/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Menu.h"
#import "cocos2d.h"
#import "Game.h"

@implementation Menu
- (id)init
{
    self = [super init];
    if(self != nil)
    {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"START" fontName:@"Arial" fontSize:48];
        CCMenuItemLabel *button = [CCMenuItemLabel itemWithLabel:label block:^(id sender)
        {
            Game *game = [[Game alloc] init];
            [[CCDirector sharedDirector] replaceScene:game];
        }];
        button.position = ccp(200, 200);
        
        CCMenu *menu = [CCMenu menuWithItems:button, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    
    return self;
}

@end
