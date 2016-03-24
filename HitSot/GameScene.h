//
//  GameScene.h
//  HitSJ
//

//  Copyright (c) 2016年 ZooTech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class Ball;
@interface GameScene : SKScene
@property (nonatomic) NSMutableArray<Ball *>*balls;
@property (nonatomic) NSArray <SKColor *> * colorMap;
@property (nonatomic) NSMutableArray <NSMutableArray<id> *> * ballArray;
@property (assign,nonatomic) SKSpriteNode *background;
@property (assign,nonatomic) int heightNumber;
@property (assign,nonatomic) int widthNumber;
@end
