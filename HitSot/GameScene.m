//
//  GameScene.m
//  HitSJ
//
//  Created by zoolsher on 16/3/21.
//  Copyright (c) 2016年 ZooTech. All rights reserved.
//

#import "GameScene.h"
#import "Ball.h"
#define DOTSIZE 50
#define DOTNUM 200
#define EMPTYCOLOR 100
typedef NS_OPTIONS(int, ColorType){
    GREEN,RED,BLUE
};
typedef NS_OPTIONS(int, DirType) {
    UP,DOWN,LEFT,RIGHT
};
@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.colorMap = [NSArray arrayWithObjects:[SKColor blueColor],[SKColor greenColor],[SKColor redColor],[SKColor blackColor],nil];
    /* Setup your scene here */
    [self initMap];
    [self initDots];
    
}

-(void)initMap{

    
    int widthNumber = (int)self.frame.size.width/DOTSIZE ;
    int heightNumber = (int)self.frame.size.height/DOTSIZE ;
    self.widthNumber = widthNumber;
    self.heightNumber = heightNumber;
    
    self.ballArray = [NSMutableArray arrayWithCapacity:100];
    for(int i = 0;i<self.widthNumber;i++){
        self.ballArray[i] = [NSMutableArray array];
        for(int j = 0;j<self.heightNumber;j++){
            self.ballArray[i][j] = [NSNull null];
        }
    }
    

    self.balls = [NSMutableArray array];
    
    SKSpriteNode *node = [[SKSpriteNode alloc]initWithColor:[SKColor grayColor] size:CGSizeMake(widthNumber*DOTSIZE, heightNumber*DOTSIZE)];
    node.anchorPoint = CGPointMake(0.5, 0.5);
    node.name=@"nodeGray";
    node.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addChild:node];
    for(int w = 0; w<widthNumber;w++){
        for (int h = 0; h<heightNumber; h++) {
            if ((w+h)%2) {
                CGPoint p = node.frame.origin;
                p.x += w*DOTSIZE;
                p.y += h*DOTSIZE;
                [self drawDot:p];
                
            }
        }
    }
    self.background = node;
}


-(void)drawDot:(CGPoint)point{
    SKSpriteNode *node = [[SKSpriteNode alloc]initWithColor:[SKColor whiteColor] size:CGSizeMake(DOTSIZE,DOTSIZE)];
    node.anchorPoint = CGPointMake(0,0);
    node.position = point;
    node.name=@"nodeWhite";
    [self addChild:node];
    
}
-(void)initDots{
    /**
     * init the colorArray
     */
    int *colorArray = (int*)malloc(self.widthNumber*self.heightNumber*sizeof(int));
    for (int l = 0;l<self.widthNumber*self.heightNumber;l++){
        if(l < DOTNUM){
            *(colorArray + l) = floor(l*[self.colorMap count]/DOTNUM);
        }else{
            *(colorArray+l) = (int)EMPTYCOLOR;
        }
    }
    /**
     * random the colorArray (alg. wash card)
     */
    for (int j = 0; j<self.widthNumber*self.heightNumber; j++) {
        int swanper = arc4random_uniform(self.widthNumber*self.heightNumber-1);
        int temp = *(colorArray + j);
        *(colorArray +j) = *(colorArray + swanper);
        *(colorArray + swanper) = temp;
    }
    /**
     * init balls with colorArray
     */
    for (int k = 0; k<self.widthNumber*self.heightNumber; k++) {
        Ball *ball;
        if (*(colorArray + k)!=EMPTYCOLOR) {
            ball = [Ball initBallWithColor:(SKColor *)[self.colorMap objectAtIndex:*(colorArray + k)]];
            ball.position = [self convertPointWithDotNumber:k];
            [self addChild:ball];
            [self.balls addObject:ball];
            self.ballArray[(int)k%self.widthNumber][(int)k/self.widthNumber]=ball;
        }
    }
}



/**
 * functions works with colorArray 
 * probably never usable
 */

-(CGPoint)convertPointWithWidth:(int)width withHeight:(int)height{
    CGPoint origin = self.background.frame.origin;
    CGFloat x = origin.x + width*DOTSIZE;
    CGFloat y = origin.y + height*DOTSIZE;
    return CGPointMake(x, y);
}

-(CGPoint)convertPointWithDotNumber:(int)dotNumber{
    int height = (int)dotNumber/self.widthNumber;
    int width = (int)dotNumber%self.widthNumber;
    return [self convertPointWithWidth:width withHeight:height];
}
/**
 * end of whatever functions
 */

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /* Called when a mouse click occurs */
    
    CGPoint location = [[touches anyObject]locationInNode:self];
    CGPoint orgion = self.background.frame.origin;
    int width = (location.x - orgion.x)/DOTSIZE;
    int height = (location.y - orgion.y)/DOTSIZE;
    
    
    if([self.ballArray[width][height] isKindOfClass:[Ball class]]){
        return;
    }
    
    /**
     * init the temp data for checking;
     */
    NSMutableArray<Ball *>* dirBall = [NSMutableArray array];
    Ball * up = [self checkBallWithDir:UP withWidth:width withHeight:height];
    if(up != nil){
        [dirBall addObject:up];
    }
    Ball * down = [self checkBallWithDir:DOWN withWidth:width withHeight:height];
    if(down != nil){
        [dirBall addObject:down];
    }
    Ball * right = [self checkBallWithDir:RIGHT withWidth:width withHeight:height];
    if(right != nil){
        [dirBall addObject:right];
    }
    Ball * left = [self checkBallWithDir:LEFT withWidth:width withHeight:height];
    if(left != nil){
        [dirBall addObject:left];
    }
    
    /**
     * bucket sort
     */
    NSMutableDictionary<SKColor*,NSMutableArray<Ball *>*>*bucket = [NSMutableDictionary dictionary];
    for (Ball *ball in dirBall) {
        SKColor * color = ball.color;
        
        NSMutableArray<Ball*>* ballTemp = [bucket objectForKey:color];
        if(ballTemp == nil){
            ballTemp = [NSMutableArray array];
        }
        [ballTemp addObject:ball];
        [bucket setObject:ballTemp forKey:color];
    }

    /**
     * remove same color balls
     */
    [bucket enumerateKeysAndObjectsUsingBlock:^(SKColor * _Nonnull key, NSMutableArray<Ball *> * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj count]>1) {
            for (Ball * ball in obj) {
                CGPoint location = ball.position;
                CGPoint orgion = self.background.frame.origin;
                int width = (location.x - orgion.x)/DOTSIZE;
                int height = (location.y - orgion.y)/DOTSIZE;
                self.ballArray[width][height] = [NSNull null];
                //[self.ballArray removeObject:(id)ball];
                [ball fall];

            }
        }
        *stop = NO;
    }];
}


-(void)update:(CFTimeInterval)currentTime {

    /* Called before each frame is rendered */
    NSMutableArray<Ball *>*list = [NSMutableArray array];
    for(Ball *ball in self.balls){
        if (!CGRectContainsPoint(self.frame, ball.position)) {
            [ball removeFromParent];
            [list addObject:ball];
        }
    }
    [self.balls removeObjectsInArray:list];
    [list removeAllObjects];
}

-(Ball* _Nullable)checkBallWithDir:(DirType)dir withWidth:(int)width withHeight:(int)height{
    int tempH = height;
    int tempW = width;
    while (true) {
        switch (dir) {
            case UP:
                tempH++;
                break;
            case DOWN:
                tempH--;
                break;
            case LEFT:
                tempW--;
                break;
            case RIGHT:
                tempW++;
                break;
            default:
                break;
        }
        /**
         *check if break out of bounds
         */
        if (tempW>=self.widthNumber || tempW<0 || tempH>=self.heightNumber || tempH <0) {
            break;
        }
        /**
         * check the one with color on it, then put the ball into dirBall;
         */
        id b = self.ballArray[tempW][tempH];
        if([b isKindOfClass:[Ball class]]){
            return (Ball *)b;
        }
    }
    return nil;
}
@end
