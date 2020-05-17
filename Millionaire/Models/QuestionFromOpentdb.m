//
//  QuestionFromOpentdb.m
//  Millionaire
//
//  Created by Maksim Romanov on 16.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "QuestionFromOpentdb.h"

@implementation QuestionFromOpentdb

- (instancetype)initWithServerResponse:(NSDictionary*) responseObject {
    self = [super init];
    if (self) {
        self.difficulty = [responseObject objectForKey:@"difficulty"];
        self.question = [responseObject objectForKey:@"question"];
        self.trueAnswer = [responseObject objectForKey:@"correct_answer"];
        self.answers = [responseObject objectForKey:@"incorrect_answers"];
    }
    return self;
}

@end
