//
//  RealmQuestion.h
//  Millionaire
//
//  Created by Maksim Romanov on 27.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm/Realm.h"

NS_ASSUME_NONNULL_BEGIN

//RLM_ARRAY_TYPE(NSString)

@interface RealmQuestion : RLMObject

@property NSString *question;
@property RLMArray <RLMString> *answers;
@property NSNumber <RLMInt> *type;
@property NSNumber <RLMInt> *language;

@end

NS_ASSUME_NONNULL_END
