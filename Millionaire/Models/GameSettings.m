//
//  GameSettings.m
//  Millionaire
//
//  Created by Maksim Romanov on 10.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "GameSettings.h"
#import "GameResult.h"

@implementation GameSettings

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.gameResults forKey:@"gameResults"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.gameResults = [coder decodeObjectForKey:@"gameResults"];
    }
    return self;
}

- (instancetype)initWith:(NSMutableArray *)gameResults {
    self = [super init];
    if (self) {
        self.gameResults = gameResults;
    }
    return self;
}

@end
