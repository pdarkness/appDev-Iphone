//
//  Player.m
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/22/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithPosition:(CGPoint)position
{
    self = [super initWithFile:@"devil.gif"];
    if (self)
    {
        self.position = position;
    }
    return self;
}
@end
