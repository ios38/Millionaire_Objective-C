//
//  QuestionAndAnswers.m
//  Millionaire
//
//  Created by Maksim Romanov on 08.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "QuestionAndAnswers.h"

@implementation QuestionAndAnswers

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.question = @"Загружаю вопрос...";
        NSArray *array = @[@"Ответ 1",@"Ответ 2",@"Ответ 3",@"Ответ 4"];
        self.answers = [NSMutableArray arrayWithArray:array];
    }
    return self;
}

- (instancetype)initWithServerResponse:(NSDictionary*) responseObject {
    self = [super init];
    if (self) {
        self.question = [responseObject objectForKey:@"question"];
        self.answers = [responseObject objectForKey:@"answers"];
    }
    return self;
}

@end
