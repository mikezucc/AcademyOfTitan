//
//  GameScene.m
//  TunnelRunner
//
//  Created by Michael Zuccarino on 11/24/14.
//  Copyright (c) 2014 Michael Zuccarino. All rights reserved.
//

#import "GameScene.h"

@interface GameScene () <SKPhysicsContactDelegate>
{
    SKSpriteNode* _playerNode;
    SKSpriteNode* _flashlightMask;
    SKSpriteNode* _leftWallNode;
    SKSpriteNode* _rightWallNode;
    SKTexture* _dmvObstacleLeftTxtr;
    SKTexture* _dmvObstacleRightTxtr;
    SKAction* _moveAndRemoveDMV;
    SKLabelNode* _passCountLabel;
    SKLabelNode* _hitCountLabel;
    NSInteger hitCount;
    NSInteger passCount;
}
@end

@implementation GameScene

static NSInteger const kObstacleGap = 130;
static const uint32_t playerClass = 0x1 << 0;
static const uint32_t enviroClass = 0x1 << 1;
static const uint32_t effectsClass = 0x1 << 2;
static const uint32_t obstacleCollision = 0x1 << 3;
static const uint32_t bottomCollision = 0x1 << 4;

-(void)didMoveToView:(SKView *)view
{
    self.physicsWorld.contactDelegate = self;
    
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Avoid the DMV!";
    myLabel.fontSize = 30;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    [SKAction waitForDuration:1.0];
    [myLabel removeFromParent];
    
    _hitCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _hitCountLabel.text = @"0 hits";
    _hitCountLabel.fontSize = 30;
    _hitCountLabel.position = CGPointMake(CGRectGetMidX(self.frame)+100, 500);
    _passCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _passCountLabel.text = @"0 passed";
    _passCountLabel.fontSize = 30;
    _passCountLabel.position = CGPointMake(CGRectGetMidX(self.frame)+100, 450);
    [self addChild:_hitCountLabel];
    [self addChild:_passCountLabel];
    
    SKTexture* flashTexture = [SKTexture textureWithImageNamed:@"flashmask"];
    flashTexture.filteringMode = SKTextureFilteringNearest;
    
    _flashlightMask = [SKSpriteNode spriteNodeWithTexture:flashTexture];
    [_flashlightMask setScale:5.0];
    _flashlightMask.position = CGPointMake(CGRectGetMidX(self.frame), 300);
    _flashlightMask.zPosition = 100;
    _flashlightMask.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_flashlightMask.size.height / 2];
    _flashlightMask.physicsBody.dynamic = NO;
    _flashlightMask.physicsBody.allowsRotation = NO;
    _flashlightMask.physicsBody.affectedByGravity = NO;
    _flashlightMask.physicsBody.collisionBitMask = effectsClass;
    //_flashlightMask.physicsBody.collisionBitMask =
    
    //[self addChild:_flashlightMask];
    
    SKTexture* playerTxtr1 = [SKTexture textureWithImageNamed:@"playerMan"];
    playerTxtr1.filteringMode = SKTextureFilteringNearest;
    
    SKTexture* leftWallTxtr = [SKTexture textureWithImageNamed:@"leftwallwider"];
    leftWallTxtr.filteringMode = SKTextureFilteringNearest;
    SKTexture* rightWallTxtr = [SKTexture textureWithImageNamed:@"rightwallwider"];
    rightWallTxtr.filteringMode = SKTextureFilteringNearest;
    
    _playerNode = [SKSpriteNode spriteNodeWithTexture:playerTxtr1];
    [_playerNode setScale:1.0];
    _playerNode.position = CGPointMake(CGRectGetMidX(self.frame), 300);
    
    _playerNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_playerNode.size.height / 2];
    _playerNode.physicsBody.dynamic = YES;
    _playerNode.physicsBody.allowsRotation = NO;
    _playerNode.physicsBody.affectedByGravity = NO;
    _playerNode.physicsBody.contactTestBitMask = obstacleCollision | bottomCollision;
    
    //wall collisions
    SKNode* leftWallCollision = [SKNode node];
    leftWallCollision.position = CGPointMake(CGRectGetMidX(self.frame)-200,0);
    leftWallCollision.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(60, 600)];
    leftWallCollision.physicsBody.dynamic = NO;
    leftWallCollision.physicsBody.contactTestBitMask = enviroClass | playerClass;
    [self addChild:leftWallCollision];
    SKNode* rightWallCollision = [SKNode node];
    rightWallCollision.position = CGPointMake(CGRectGetMidX(self.frame)+200,0);
    rightWallCollision.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(60, 600)];
    rightWallCollision.physicsBody.dynamic = NO;
    rightWallCollision.physicsBody.contactTestBitMask = enviroClass | playerClass;
    [self addChild:rightWallCollision];
    
    //[rightWallSpriteNode runAction:moveRightWallSpriteForever];
    
    SKAction* movedLeftWallSprite = [SKAction moveByX:0 y:-leftWallTxtr.size.height duration:1];
    SKAction* resetLeftWallSprite = [SKAction moveByX:0 y:leftWallTxtr.size.height duration:0];
    SKAction* moveLeftWallSpriteForever = [SKAction repeatActionForever:[SKAction sequence:@[movedLeftWallSprite, resetLeftWallSprite]]];
    
    for( int i = 0; i < 2 + (self.frame.size.height/leftWallTxtr.size.height); i++ ) {
        // Create the sprite
        SKSpriteNode* leftWallSpriteNode = [SKSpriteNode spriteNodeWithTexture:leftWallTxtr];
        [leftWallSpriteNode setScale:1.0];
        leftWallSpriteNode.position = CGPointMake(CGRectGetMidX(self.frame)-200,i * 300);
        [leftWallSpriteNode runAction:moveLeftWallSpriteForever];
        [self addChild:leftWallSpriteNode];
    }
    
    SKAction* movedRightWallSprite = [SKAction moveByX:0 y:-rightWallTxtr.size.height duration:1];
    SKAction* resetRightWallSprite = [SKAction moveByX:0 y:rightWallTxtr.size.height duration:0];
    SKAction* moveRightWallSpriteForever = [SKAction repeatActionForever:[SKAction sequence:@[movedRightWallSprite, resetRightWallSprite]]];
    
    for( int i = 0; i < 2 + (self.frame.size.height/rightWallTxtr.size.height); i++ )
    {
        // Create the sprite
        SKSpriteNode* rightWallSpriteNode = [SKSpriteNode spriteNodeWithTexture:rightWallTxtr];
        [rightWallSpriteNode setScale:1.0];
        rightWallSpriteNode.position = CGPointMake(CGRectGetMidX(self.frame)+200,i * 300);
        [rightWallSpriteNode runAction:moveRightWallSpriteForever];
        [self addChild:rightWallSpriteNode];
    }
    
    [self addChild:_playerNode];
    
    _dmvObstacleLeftTxtr = [SKTexture textureWithImageNamed:@"obstacleLeft"];
    _dmvObstacleLeftTxtr.filteringMode = SKTextureFilteringNearest;
    _dmvObstacleRightTxtr = [SKTexture textureWithImageNamed:@"obstacleLeft"];
    _dmvObstacleRightTxtr.filteringMode = SKTextureFilteringNearest;
    
    SKAction* moveObstacles = [SKAction moveByX:0 y:-((self.frame.size.height)+140) duration:4];
    SKAction* removeObstacles = [SKAction removeFromParent];
    _moveAndRemoveDMV = [SKAction sequence:@[moveObstacles, [SKAction performSelector:@selector(passAThing) onTarget:self], removeObstacles]];
    
    // generate new DMV obst, wait repeat cycle
    SKAction* genDelay = [SKAction sequence:@[[SKAction performSelector:@selector(makeNewObstacles) onTarget:self], [SKAction waitForDuration:1.0]]];
    SKAction* genDelayRepeat = [SKAction repeatActionForever:genDelay];
    [self runAction:genDelayRepeat];
    
    SKNode *bottomCollisionNode = [SKNode node];
    bottomCollisionNode.position = CGPointMake(CGRectGetMidX(self.frame)-250,5);
    bottomCollisionNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(600, 10)];
    bottomCollisionNode.physicsBody.dynamic = NO;
    //bottomCollisionNode.physicsBody.collisionBitMask = 0x0;
    bottomCollisionNode.physicsBody.contactTestBitMask = bottomCollision;
    [self addChild:bottomCollisionNode];
}

-(void)makeNewObstacles
{
    SKNode* obstaclePair = [SKNode node];
    obstaclePair.position = CGPointMake(0,self.frame.size.height );
    obstaclePair.zPosition = 10;
    
    CGFloat x = arc4random() % (NSInteger)( CGRectGetMidX(self.frame)/3 );
    NSLog(@"%ld random x",(long)x);
    SKSpriteNode* _obstacleLeft = [SKSpriteNode spriteNodeWithTexture:_dmvObstacleLeftTxtr];
    _obstacleLeft.position = CGPointMake( CGRectGetMidX(self.frame)- 260 + x, 200);
    _obstacleLeft.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_dmvObstacleLeftTxtr.size];
    _obstacleLeft.physicsBody.contactTestBitMask = obstacleCollision;
    _obstacleLeft.physicsBody.dynamic = NO;
    
    [obstaclePair addChild:_obstacleLeft];
    
    SKSpriteNode* _obstacleRight = [SKSpriteNode spriteNodeWithTexture:_dmvObstacleRightTxtr];
    _obstacleRight.position = CGPointMake( _obstacleLeft.position.x +  _dmvObstacleLeftTxtr.size.width + kObstacleGap, 200);
    _obstacleRight.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_dmvObstacleRightTxtr.size];
    _obstacleRight.physicsBody.contactTestBitMask = obstacleCollision;
    _obstacleRight.physicsBody.dynamic = NO;
    [obstaclePair addChild:_obstacleRight];
    
    [obstaclePair runAction:_moveAndRemoveDMV];

    [self addChild:obstaclePair];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *aTouch = [touches anyObject];
    NSLog(@"touch at %ld to compare %ld",(long)[aTouch locationInView:self.view].x, (long)(self.view.frame.size.width/2));
    if ([aTouch locationInView:self.view].x < (self.view.frame.size.width/2))
    {
        NSLog(@"to da left");
         _playerNode.physicsBody.velocity = CGVectorMake(-200, 0);
         _flashlightMask.physicsBody.velocity = CGVectorMake(-200, 0);
    }
    else
    {
        NSLog(@"to da right");
        _playerNode.physicsBody.velocity = CGVectorMake(200, 0);
        _flashlightMask.physicsBody.velocity = CGVectorMake(-200, 0);
    }
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"contact detected");
    
    SKPhysicsBody *bodyA, *bodyB;
    
    bodyA = contact.bodyA;
    bodyB = contact.bodyB;
    
    if ((bodyA.contactTestBitMask == obstacleCollision) || (bodyB.contactTestBitMask == obstacleCollision))
    {
        NSLog(@"detected a player 2 obstacle collision");
        hitCount++;
        [_hitCountLabel setText:[NSString stringWithFormat:@"%li hits",(long)hitCount]];
    }
    if ((bodyA.contactTestBitMask == bottomCollision) || (bodyB.contactTestBitMask == bottomCollision))
    {
        NSLog(@"you dead");
        NSLog(@"detected a person 2 bottom collision");
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"YOU DEAD SON!";
        myLabel.fontSize = 50;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        myLabel.zPosition = 150;
        
        [self addChild:myLabel];
        
        
        
        [self removeAllActions];
        //[SKAction waitForDuration:3.0];
        //[myLabel removeFromParent];
        //[self reloadInputViews];
         
    }
}

-(void)passAThing
{
    passCount++;
    [_passCountLabel setText:[NSString stringWithFormat:@"%li passed",(long)passCount]];
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //if (_playerNode.frame.origin.y >= )
}

@end
