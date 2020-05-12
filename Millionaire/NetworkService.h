//
//  ServerManager.h
//  Millionaire
//
//  Created by Maksim Romanov on 08.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionAndAnswers.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkService : NSObject

+ (NetworkService *) shared;

- (void) getQuestionWithType:(NSInteger) questionType
              onSuccess:(void(^)(QuestionAndAnswers *questionAndAnswers)) success
              onFailure:(void(^)(NSError *error)) failure;


@end

NS_ASSUME_NONNULL_END
