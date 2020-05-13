//
//  GameSession.h
//  Millionaire
//
//  Created by Maksim Romanov on 09.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    easy,medium,hard,insane
} Difficulty;

extern NSString* const trueAnswersCountNotification;
extern NSString* const trueAnswersCountUserInfoKey;


@interface GameSession : NSObject <GameDelegate>

@property (assign,nonatomic) Difficulty difficulty;
@property (assign,nonatomic) NSUInteger trueAnswersCount;
@property (assign,nonatomic) CGFloat averageAnswersTime;


-(void)startGame:(UIViewController *)mainMenuController;

@end

NS_ASSUME_NONNULL_END
