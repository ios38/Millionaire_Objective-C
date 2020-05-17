//
//  QuestionAdapter.h
//  Millionaire
//
//  Created by Maksim Romanov on 16.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionAndAnswers.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuestionAdapter : NSObject

+ (void) getQuestionWithType:(NSNumber *) questionType
                   onSuccess:(void(^)(QuestionAndAnswers *questionAndAnswers)) success
                   onFailure:(void(^)(NSError *error)) failure;

@end

NS_ASSUME_NONNULL_END
