//
//  GameResult.h
//  Millionaire
//
//  Created by Maksim Romanov on 10.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameResult : NSObject <NSCoding>
//@interface GameResult : NSObject

@property (strong,nonatomic) NSDate *date;
@property (assign,nonatomic) NSNumber *result;
@property (assign,nonatomic) NSNumber *time;

- (instancetype)initWithDate:(NSDate *)date result:(NSUInteger)result andTime:(CGFloat)time;

@end

NS_ASSUME_NONNULL_END
