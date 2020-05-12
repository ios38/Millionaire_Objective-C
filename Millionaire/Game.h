//
//  Game.h
//  Millionaire
//
//  Created by Maksim Romanov on 09.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface Game : NSObject

@property (strong,nonatomic) GameSession * _Nullable gameSession;
@property (strong,nonatomic) NSMutableArray *gameResults;

+ (Game *) shared;

- (void)endGameWithResult:(NSUInteger)result;

@end

NS_ASSUME_NONNULL_END
