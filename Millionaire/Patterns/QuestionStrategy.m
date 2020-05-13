//
//  QuestionStrategy.m
//  Millionaire
//
//  Created by Maksim Romanov on 12.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "QuestionStrategy.h"

@implementation QuestionStrategy

- (NSUInteger) getQuestionType {
    Difficulty difficulty = Game.shared.gameSession.difficulty;
    switch (difficulty) {
        case easy:
            return 1;
            break;
        case medium:
            return self.questionTypeForMediumDifficulty;
            break;
        case hard:
            return 2;
            break;
        case insane:
            return 3;
            break;
    }
}

- (NSUInteger) questionTypeForMediumDifficulty {
    NSUInteger count = Game.shared.gameSession.trueAnswersCount;
    if (count >= 0 && count <= 4){
        return 1;
    } else if (count >= 5 && count <= 9){
        return 2;
    } else {
        return 3;
    };
}

- (NSUInteger) questionTypeForHardDifficulty {
    NSUInteger count = Game.shared.gameSession.trueAnswersCount;
    switch (count) {
        case 0:case 1:case 2:case 3:case 4:
            return 2;
            break;
        case 5:case 6:case 7:case 8:case 9:
            return 3;
            break;
        case 10:case 11:case 12:case 13:case 14:
            return 3;
            break;
        default:
            return 1;
            break;
    }
}

@end
