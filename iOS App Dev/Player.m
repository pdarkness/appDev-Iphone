//
//  Player.m
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/22/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)initWithSpace:(ChipmunkSpace *)space position:(CGPoint)position;
{
    self = [super initWithFile:@"devil.gif"];
    if (self)
    {
        _space = space;
        
        if (_space != nil)
        {
            CGSize size = self.textureRect.size;
            cpFloat mass = size.width * size.height;
            cpFloat momentum = cpMomentForBox(mass, size.width, size.height);
            
            ChipmunkBody *body = [ChipmunkBody bodyWithMass:mass andMoment:momentum];
            body.pos = position;
            ChipmunkShape *shape = [ChipmunkPolyShape boxWithBody:body width:size.width height:size.height];
            
            // Add this to our space
            [_space addBody:body];
            [_space addShape:shape];
            
            // Add sprite
            self.chipmunkBody = body;
        }
    }
    return self;
}

- (void)jumpWithPower:(CGFloat)power vector:(cpVect)vector
{
    cpVect impulseVector = cpvmult(vector, self.chipmunkBody.mass * power);
    [self.chipmunkBody applyImpulse:impulseVector offset:cpvzero];
}
@end
