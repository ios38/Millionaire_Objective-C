//
//  QuestionFromOpentdb.h
//  Millionaire
//
//  Created by Maksim Romanov on 16.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionFromOpentdb : NSObject

@property (strong, nonatomic) NSString *difficulty;
@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSString *trueAnswer;
@property (strong, nonatomic) NSMutableArray *answers;

- (instancetype)initWithServerResponse:(NSDictionary*) responseObject;

@end

NS_ASSUME_NONNULL_END
