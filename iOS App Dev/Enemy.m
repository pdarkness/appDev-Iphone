//
//  Enemy.m
//  iOS App Dev
//
//  Created by Elisa Erludottir on 9/26/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position{
    self = [super initWithFile:@"AppleSprite4.gif"];
    if (self)  {
        CGSize size = self.textureRect.size;
        ChipmunkBody *body = [ChipmunkBody staticBody];
        position.x -= 20;
        body.pos = position;
        ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width/1.5 height:size.height/1.5];

        shape.sensor = YES;
        
        [space addShape:shape];
        
        body.data = self;
        self.chipmunkBody = body;
    }
    return self;
}
@end
