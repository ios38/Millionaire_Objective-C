//
//  NetworkService.m
//  Millionaire
//
//  Created by Maksim Romanov on 08.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "NetworkService.h"
#import "AFNetworking.h"
#import "QuestionAndAnswers.h"

@interface NetworkService ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation NetworkService

+ (NetworkService *) shared {
    
    static NetworkService *networkService = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        networkService = [[NetworkService alloc] init];
    });
    
    return networkService;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 30;
        self.manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
        self.manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"text/html", nil];
    }
    return self;
}

- (void) getQuestionFromLip2xyzWithType:(NSNumber *) questionType
                              onSuccess:(void(^)(QuestionAndAnswers *questionAndAnswers)) success
                              onFailure:(void(^)(NSError *error)) failure {
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:questionType,@"q", nil];
    
    [self.manager GET:@"https://lip2.xyz/api/millionaire.php" parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * task, NSDictionary * responseObject) {

        NSLog(@"https://lip2.xyz/api/millionaire.php Success");

        NSDictionary *dict = [responseObject objectForKey:@"data"];
        QuestionAndAnswers *questionAndAnswers = [[QuestionAndAnswers alloc] initWithServerResponse:dict];
     
        if (success) {
            success(questionAndAnswers);
        }
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"https://lip2.xyz/api/millionaire.php Failure");
        //NSLog(@"error: %@", [error localizedDescription]);
        if (failure) {
            failure(error);
        }
    }];
    
}

- (void) getQuestionFromOpentdbWithType:(NSString *) questionType
                    onSuccess:(void(^)(QuestionFromOpentdb *questionFromOpentdb)) success
                    onFailure:(void(^)(NSError *error)) failure {

    self.manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json", nil];
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @1,@"amount",
                                @18,@"category",
                                questionType,@"difficulty",
                                @"multiple",@"type",
                                nil];

    [self.manager GET:@"https://opentdb.com/api.php" parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * task, NSDictionary * responseObject) {
        NSLog(@"https://opentdb.com/api.php Success");
        //NSLog(@"%@",responseObject);
        NSArray *array = [responseObject objectForKey:@"results"];
        QuestionFromOpentdb *questionFromOpentdb = [[QuestionFromOpentdb alloc] initWithServerResponse:[array firstObject]];
        NSLog(@"%@",questionFromOpentdb.difficulty);
        
        if (success) {
            success(questionFromOpentdb);
        }

    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"https://opentdb.com/api.php Failure");
        //NSLog(@"error: %@", [error localizedDescription]);
        if (failure) {
            failure(error);
        }
    }];
    
}


@end
