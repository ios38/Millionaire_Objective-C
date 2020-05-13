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

@interface Game()

@property (strong,nonatomic) ResultsCaretaker *resultsCaretaker;

@end


@implementation Game

+ (Game *) shared {
    static Game *game = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        game = [[Game alloc] init];
        NSLog(@"Game created");
    });
    
    return game;
}

- (id)init {
    self = [super init];
    if (self) {
        self.gameResults = [NSMutableArray array];
        self.resultsCaretaker = [[ResultsCaretaker alloc] init];
        [self.resultsCaretaker loadResults];
    }
    return self;
}

- (void) setGameResults:(NSMutableArray *)gameResults { //не срабатывает при gameResults addObject:
    NSLog(@"Game: setGameResults");
    _gameResults = gameResults;
    [self.resultsCaretaker saveResults:gameResults];
}

- (void)endGameWithResult:(NSUInteger)result {
    NSLog(@"Game: endGameWithResult: %lu",(unsigned long)result);
    NSDate *date = [NSDate date];
    GameResult *gameResult = [[GameResult alloc] initWithDate:date andResult:result];
    [self.gameResults addObject:gameResult]; //не срабатывает сеттер для gameResults
    [self.resultsCaretaker saveResults:self.gameResults];
    self.gameSession = nil;
}

@end
