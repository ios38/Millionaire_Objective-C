//
//  Logger.h
//  Millionaire
//
//  Created by Maksim Romanov on 20.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface Logger : NSObject

+ (Logger *) shared;
- (void) didAction:(LogAction)logAction;

@end

NS_ASSUME_NONNULL_END
