//
//  LogCommand.h
//  Millionaire
//
//  Created by Maksim Romanov on 20.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    startGameSession, //with selected Difficulty, Language
    trueAnswer, //with time
    endGameSession //with trueAnswerCount
} LogAction;

@interface LogCommand : NSObject

@property (assign,nonatomic) LogAction logAction;
@property (strong,nonatomic) NSString *logMessage;

- (instancetype) initWithAction:(LogAction)logAction;
- (void) execute;

@end

NS_ASSUME_NONNULL_END
