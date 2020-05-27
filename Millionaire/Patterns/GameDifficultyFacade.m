//
//  GameDifficulty.m
//  Millionaire
//
//  Created by Maksim Romanov on 13.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "GameDifficultyFacade.h"
#import "Game.h"
#import "GameSession.h"

@implementation GameDifficultyFacade

- (NSNumber *) getQuestionType {
    Difficulty difficulty = Game.shared.gameSession.difficulty;
    switch (difficulty) {
        case easy:
            return @1;
            break;
        case medium:
            return self.questionTypeForMediumDifficulty;
            break;
        case hard:
            return @2;
            break;
        case insane:
            return @3;
            break;
    }
}

- (NSNumber *) questionTypeForMediumDifficulty {
    NSUInteger count = Game.shared.gameSession.trueAnswersCount;
    if (count >= 0 && count <= 4){
        return @1;
    } else if (count >= 5 && count <= 9){
        return @2;
    } else {
        return @3;
    };
}

- (NSNumber *) questionTypeForHardDifficulty {
    NSUInteger count = Game.shared.gameSession.trueAnswersCount;
    switch (count) {
        case 0 ... 4:
            return @2;
            break;
        case 5 ... 9:
            return @3;
            break;
        case 10 ... 14:
            return @3;
            break;
        default:
            return @1;
            break;
    }
}

- (NSUInteger) getCountdownDuration {
    Difficulty difficulty = Game.shared.gameSession.difficulty;
    switch (difficulty) {
        case easy:
            return 30;
            break;
        case medium:
            return 15;
            break;
        case hard:
            return 10;
            break;
        case insane:
            return 5;
            break;
    }
}

@end
