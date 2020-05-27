//
//  QuestionProxy.m
//  Millionaire
//
//  Created by Maksim Romanov on 27.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "QuestionProxy.h"
#import "QuestionAdapter.h"
#import "UIKit/UIKit.h"
#import "Game.h"
#import "RealmQuestion.h"
#import "Realm/Realm.h"



@interface QuestionProxy()

@property(strong,nonatomic) RLMRealm *realm;

@property (assign,nonatomic) double time;

@end

@implementation QuestionProxy

- (instancetype)init
{
    self = [super init];
    if (self) {
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        self.realm = [RLMRealm realmWithConfiguration:config error:nil];
        NSLog(@"%@", self.realm.configuration.fileURL);
    }
    return self;
}

- (void) getQuestionWithType:(NSNumber *) questionType
                   onSuccess:(void(^)(QuestionAndAnswers *questionAndAnswers)) success
                   onFailure:(void(^)(NSError *error)) failure {
    
    self.time = CACurrentMediaTime();
    
    [QuestionAdapter getQuestionWithType:questionType
      onSuccess:^(QuestionAndAnswers *questionAndAnswers) {
        if (success) {
            self.time = CACurrentMediaTime() - self.time;
            NSLog(@"Network request completed successfully in %f seconds",self.time);
            
            RealmQuestion *realmQuestion = [[RealmQuestion alloc] init];
            realmQuestion.question = questionAndAnswers.question;
            for (NSString *answer in questionAndAnswers.answers) {
                [realmQuestion.answers addObject:answer];
            }
            realmQuestion.type = questionType;
            realmQuestion.language = [NSNumber numberWithInteger:Game.shared.gameSession.language];
            
            [self.realm transactionWithBlock:^{
                [self.realm addObject:realmQuestion];
            }];

            success(questionAndAnswers);
        }
    }
      onFailure:^(NSError *error) {
        if (failure) {
            self.time = CACurrentMediaTime() - self.time;
            NSLog(@"Network request completed with error in %f seconds",self.time);
            NSLog(@"error: %@", [error localizedDescription]);
            failure(error);
        }
    }];    
}

@end
