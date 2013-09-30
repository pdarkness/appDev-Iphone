//
//  Star.m
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/30/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Star.h"

@implementation Star

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"star.plist"];
    self = [super initWithSpriteFrameName:@"Star1.png"];
    if (self)  {
        CGSize size = self.textureRect.size;
        ChipmunkBody *body = [ChipmunkBody staticBody];
        body.pos = position;
        ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width/1.5 height:size.height/1.5];
        
        shape.sensor = YES;
        
        [space addShape:shape];
        
        body.data = self;
        self.chipmunkBody = body;
        
        NSMutableArray *starAnimFrames = [NSMutableArray array];
        for (int i=1; i<=5 ; i++) {
            [starAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"Star%d.png", i]
              ]
             ];
        }
        CCAnimation *starAnim = [CCAnimation animationWithSpriteFrames:starAnimFrames delay:0.1f];
        _starAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:starAnim]];
    }
    return self;
}
@end
