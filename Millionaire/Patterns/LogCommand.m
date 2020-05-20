//
//  LogCommand.m
//  Millionaire
//
//  Created by Maksim Romanov on 20.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "LogCommand.h"

@implementation LogCommand

- (instancetype) initWithAction: (LogAction) logAction {
    self = [super init];
    if (self) {
        self.logAction = logAction;
        //NSLog(@"LogCommand created with action %d",logAction);
    }
    return self;
}

- (NSString *)logMessage {
    switch (self.logAction) {
        case startGameSession:
            return @"Game session started";
            break;
        case trueAnswer:
            return @"Player answered correctly";
            break;
        case endGameSession:
            return @"Game session is over";
            break;
    }
}

- (void) execute {
    NSLog(@"%@", self.logMessage);
}

@end
