//
//  ViewController.m
//  Millionaire
//
//  Created by Maksim Romanov on 08.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "ViewController.h"
#import "NetworkService.h"
#import "QuestionAndAnswers.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getQuestion];

}

#pragma mark - API

- (void) getQuestion {
    [[NetworkService shared] getQuestionWithType:1
      onSuccess:^(QuestionAndAnswers *questionAndAnswers) {

        NSLog(@"question: %@", questionAndAnswers.question);
        for (NSString *answer in questionAndAnswers.answers) {
            NSLog(@"answer: %@", answer);
        }
    }
      onFailure:^(NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }];
}

@end
