//
//  InputLayer.h
//  iOS App Dev
//
//  Created by Knútur Óli Magnússon on 9/22/13.
//  Copyright (c) 2013 Sveinn Fannar Kristjansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol InputLayerDelgate <NSObject>

- (void)touchEndedAtPosition:(CGPoint)point afterDelay:(NSTimeInterval)delay;

@end

@interface inputLayer : CCLayer
{
    NSDate *_touchBeganDate;
}

@property (nonatomic, weak) id<InputLayerDelgate> delegate;

@end
