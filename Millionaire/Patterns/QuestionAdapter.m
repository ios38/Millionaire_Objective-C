//
//  QuestionAdapter.m
//  Millionaire
//
//  Created by Maksim Romanov on 16.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "QuestionAdapter.h"
#import "NetworkService.h"
#import "QuestionAndAnswers.h"
#import "GameSession.h"
#import "Game.h"

@implementation QuestionAdapter

+ (void) getQuestionWithType:(NSNumber *) questionType onSuccess:(void(^)(QuestionAndAnswers *questionAndAnswers)) success onFailure:(void(^)(NSError *error)) failure {
    
    if (Game.shared.gameSession.language == rus) {
        [[NetworkService shared] getQuestionFromLip2xyzWithType:questionType
          onSuccess:^(QuestionAndAnswers *questionAndAnswers) {
            
            if (success) {
                success(questionAndAnswers);
            }
        }
          onFailure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];


    } else if (Game.shared.gameSession.language == eng) {
        NSString *questionTypeString = [self questionTypeStringFrom:questionType];
        [[NetworkService shared] getQuestionFromOpentdbWithType:questionTypeString
          onSuccess:^(QuestionFromOpentdb *questionFromOpentdb) {
            
            QuestionAndAnswers *questionAndAnswers = [[QuestionAndAnswers alloc] init];
            questionAndAnswers.question = questionFromOpentdb.question;
            NSMutableArray *answers = [(NSMutableArray *)questionFromOpentdb.answers mutableCopy];
            [answers insertObject:questionFromOpentdb.trueAnswer atIndex:0];
            questionAndAnswers.answers = answers;
            
            if (success) {
                success(questionAndAnswers);
            }
        }
          onFailure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

+ (NSString *)questionTypeStringFrom:(NSNumber *)questionType {
    switch (questionType.intValue) {
        case 1:
            return @"easy";
            break;
        case 2:
            return @"medium";
            break;
        case 3:
            return @"hard";
            break;
        default:
            return @"easy";
            break;
    }
}

@end
