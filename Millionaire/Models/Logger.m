//
//  Logger.m
//  Millionaire
//
//  Created by Maksim Romanov on 20.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "Logger.h"

@interface Logger ()

@property (strong,nonatomic) NSMutableArray *commands;
@property (strong,nonatomic) NSLock *lock;

@end

@implementation Logger

+ (Logger *) shared {
    static Logger *logger = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        logger = [[Logger alloc] init];
        //NSLog(@"Logger created");
    });
    
    return logger;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.commands = [NSMutableArray array];
    }
    return self;
}

- (void) didAction:(LogAction)logAction {
    LogCommand *command = [[LogCommand alloc] initWithAction:logAction];
    
    [self.lock lock];
    [self.commands addObject:command];
    if (logAction == endGameSession) {
        for (LogCommand *command in self.commands) {
            [command execute];
        }
    }
    [self.lock unlock];
}

@end
