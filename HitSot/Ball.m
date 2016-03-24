//
//  Ball.m
//  HitSJ
//
//  Created by zoolsher on 16/3/22.
//  Copyright © 2016年 ZooTech. All rights reserved.
//

#import "Ball.h"
#define DOTSIZE 50.0
@implementation Ball
+(instancetype)initBallWithColor:(SKColor *)color{
    return [[self alloc]initWithColor:color];
}
-(instancetype)initWithColor:(SKColor *)color{
    if (self = [super init]) {
        self.color = color;
        [self initGraphNode];
    }
    return self;
}
-(void)initGraphNode{
    SKSpriteNode *sp = [[SKSpriteNode alloc]initWithImageNamed:@"white-pool-ball"];
    sp.xScale = ((CGFloat)DOTSIZE/(CGFloat)1753);
    sp.yScale = sp.xScale;
    sp.color = self.color;
    sp.colorBlendFactor = 0.8;
    sp.anchorPoint = CGPointMake(0, 0);
    [self addChild:sp];
}
-(void)fall{
    int dir = ((int)arc4random_uniform(2))*2-1;
    SKAction *ac = [SKAction moveByX:dir y:3 duration:0.01];
    SKPhysicsBody *pb = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10, 10)];
    pb.dynamic = YES;
    pb.mass = 0.5;
    pb.linearDamping = 0.2;
    pb.angularDamping = 0.2;
    
    pb.affectedByGravity = YES;
    self.physicsBody = pb;

    [self runAction:[SKAction repeatActionForever:ac ]];
}
@end
