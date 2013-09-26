//
//  Goal.m
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/25/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Goal.h"

@implementation Goal

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position{
    self = [super initWithFile:@"mirror.png"];
    if (self)  {
        CGSize size = self.textureRect.size;
        ChipmunkBody *body = [ChipmunkBody staticBody];
        body.pos = position;
        ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width/1.8 height:size.height/1.8];
        shape.sensor = YES;
        
        [space addShape:shape];
        
        body.data = self;
        self.chipmunkBody = body;
    }
    return self;
}
@end
