//
//  GameDifficulty.h
//  Millionaire
//
//  Created by Maksim Romanov on 13.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameDifficultyFacade : NSObject

- (NSNumber *) getQuestionType;
- (NSUInteger) getCountdownDuration;

@end

NS_ASSUME_NONNULL_END
