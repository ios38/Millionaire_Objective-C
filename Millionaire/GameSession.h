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

@interface GameSession : NSObject <GameDelegate>

-(void)startGame:(UIViewController *)mainMenuController;

@end

NS_ASSUME_NONNULL_END
