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
        self.manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"text/html", nil];
    }
    return self;
}
- (void) getQuestionWithType:(NSInteger) questionType
                    onSuccess:(void(^)(QuestionAndAnswers *questionAndAnswers)) success
                    onFailure:(void(^)(NSError *error)) failure {
    
    NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"q", nil];

    [self.manager GET:@"https://lip2.xyz/api/millionaire.php" parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * task, NSDictionary * responseObject) {
        
        NSDictionary *dict = [responseObject objectForKey:@"data"];
        QuestionAndAnswers *questionAndAnswers = [[QuestionAndAnswers alloc] initWithServerResponse:dict];

        if (success) {
            success(questionAndAnswers);
        }

    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        //NSLog(@"Error: %@", error);
        NSLog(@"error: %@", [error localizedDescription]);
        if (failure) {
            failure(error);
        }
    }];
    
}


@end
