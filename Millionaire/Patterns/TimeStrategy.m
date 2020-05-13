//
//  TimeStrategy.m
//  Millionaire
//
//  Created by Maksim Romanov on 13.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "TimeStrategy.h"

@implementation TimeStrategy

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
