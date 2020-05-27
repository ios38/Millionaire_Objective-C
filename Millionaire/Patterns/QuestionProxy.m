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

@interface QuestionProxy()

@property (assign,nonatomic) double time;

@end

@implementation QuestionProxy


- (void) getQuestionWithType:(NSNumber *) questionType
                   onSuccess:(void(^)(QuestionAndAnswers *questionAndAnswers)) success
                   onFailure:(void(^)(NSError *error)) failure {
    
    self.time = CACurrentMediaTime();
    
    [QuestionAdapter getQuestionWithType:questionType
      onSuccess:^(QuestionAndAnswers *questionAndAnswers) {
        if (success) {
            self.time = CACurrentMediaTime() - self.time;
            NSLog(@"Network request completed successfully in %f seconds",self.time);
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
