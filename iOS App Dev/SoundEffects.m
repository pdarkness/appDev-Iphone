//
//  SoundEffects.m
//  iOS App Dev
//
//  Created by Elisa Erludottir on 9/29/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "SoundEffects.h"

@implementation SoundEffects
-(id)init
{
    if ((self = [super init])) {
        [self playBackgroundMusic:@"AppDevBackgroundMusic.mp3" loop:YES];
        self.backgroundMusicVolume  = 0.2f;
    }
    
    return self;
}

-(void)playSounds:(NSString *)string
{
    NSString *type = [self getString:string];
    if (![type isEqualToString:@""]) {
        [self playEffect:type pitch:(CCRANDOM_0_1() * 0.3f) + 1 pan:0 gain:1];
    }
}

-(NSString *) getString:(NSString *)string
{
    if ([string isEqualToString:@"coin"]) {
        return @"coin-drop-4.wav";
    } else if([string isEqualToString:@"suck"]) {
        return @"suck.wav";
    } else if ([string isEqualToString:@"goal"]) {
        return @"applause-8.wav";
    } else if ([string isEqualToString:@"star"]) {
        return @"star1.wav";
    }else {
        return @"";
    }
}

@end
