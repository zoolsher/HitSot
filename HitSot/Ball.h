//
//  Ball.h
//  HitSJ
//
//  Created by zoolsher on 16/3/22.
//  Copyright © 2016年 ZooTech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Ball : SKNode
@property SKColor* color;
+(instancetype)initBallWithColor:(SKColor *)color;
-(instancetype)initWithColor:(SKColor *)color;
-(void)initGraphNode;
-(void)fall;
@end
