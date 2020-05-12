//
//  GameResult.h
//  Millionaire
//
//  Created by Maksim Romanov on 10.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameResult : NSObject <NSCoding>

@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) NSNumber *result;

- (instancetype)initWithDate:(NSDate *)date andResult:(NSUInteger)result;

@end

NS_ASSUME_NONNULL_END
