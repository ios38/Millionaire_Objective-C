//
//  Game.m
//  Millionaire
//
//  Created by Maksim Romanov on 09.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "Game.h"
#import "GameResult.h"
#import "ResultsCaretaker.h"
#import "Logger.h"

@interface Game()

@property (strong,nonatomic) ResultsCaretaker *resultsCaretaker;

@end


@implementation Game

+ (Game *) shared {
    static Game *game = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        game = [[Game alloc] init];
        //NSLog(@"Game created");
    });
    
    return game;
}

- (id)init {
    self = [super init];
    if (self) {
        self.gameResults = [NSMutableArray array];
        self.resultsCaretaker = [[ResultsCaretaker alloc] init];
        [self.resultsCaretaker loadResults];
        self.gameResults = [self.resultsCaretaker loadResults];
    }
    return self;
}

- (void)endGameWithResult:(NSUInteger)result andTime:(CGFloat)time {
    NSDate *date = [NSDate date];
    GameResult *gameResult = [[GameResult alloc] initWithDate:date result:result andTime:time];
    [self.gameResults addObject:gameResult];
    [self.resultsCaretaker saveResults:self.gameResults];
    [Logger.shared didAction:endGameSession];
    self.gameSession = nil;
}

@end
