//
//  GameController.m
//  Millionaire
//
//  Created by Maksim Romanov on 08.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "GameController.h"
//#import "NetworkService.h"
#import "QuestionAndAnswers.h"
#import "Game.h"
#import "GameSession.h"
#import "QuestionStrategy.h"
#import "TimeStrategy.h"
#import "GameDifficultyFacade.h"
#import "QuestionAdapter.h"

@interface GameController ()

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionDifficulty;
@property (weak, nonatomic) IBOutlet UILabel *QuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueAnswersCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *fiftyFiftyButton;

@property (weak, nonatomic) id <GameDelegate> gameDelegate;

@property (strong,nonatomic) QuestionAndAnswers *questionAndAnswers;
@property (strong,nonatomic) NSString *trueAnswer;
//@property (assign,nonatomic) NSUInteger trueAnswersCount;

@property (strong, nonatomic) NSTimer *countdownTimer;
@property (assign, nonatomic) NSInteger currentCountdown;

//@property (strong, nonatomic) QuestionStrategy *questionStrategy;
//@property (strong, nonatomic) TimeStrategy *timeStrategy;
@property (strong, nonatomic) GameDifficultyFacade *gameDifficulty;

@property (strong, nonatomic) NSNotificationCenter *nc;

@property (strong, nonatomic) UIColor *trueAnswerColor;
@property (strong, nonatomic) UIColor *falseAnswerColor;


@end

@implementation GameController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.questionStrategy = [[QuestionStrategy alloc] init];
    //self.timeStrategy = [[TimeStrategy alloc] init];
    self.gameDifficulty = [[GameDifficultyFacade alloc] init];
    self.nc = [NSNotificationCenter defaultCenter];
    self.questionAndAnswers = [[QuestionAndAnswers alloc] init];
    self.QuestionLabel.text = self.questionAndAnswers.question;
    self.questionDifficulty.text = @"Уровень сложности: 1";
    self.trueAnswersCountLabel.text = @"Правильных ответов: 0";
    self.trueAnswerColor = [UIColor colorWithRed:0.0/255.0 green:100.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.falseAnswerColor = [UIColor colorWithRed:100.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    [self.fiftyFiftyButton addTarget:self action:@selector(fiftyFiftyAnswers) forControlEvents:UIControlEventTouchUpInside];
    self.gameDelegate = Game.shared.gameSession;
    [self.nc addObserver:self selector:@selector(trueAnswersCountNotification:) name:trueAnswersCountNotification object:nil];
    [self getQuestion];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - API

- (void) getQuestion {
    NSNumber *questionType = [self.gameDifficulty getQuestionType];
    self.questionDifficulty.text = [NSString stringWithFormat:@"Уровень сложности: %@", questionType];
    
    [QuestionAdapter getQuestionWithType:questionType 
    //[[NetworkService shared] getQuestionWithType:questionType
      onSuccess:^(QuestionAndAnswers *questionAndAnswers) {

        self.questionAndAnswers = questionAndAnswers;
        self.trueAnswer = [questionAndAnswers.answers objectAtIndex:0];
        NSMutableArray *array = [(NSArray *)questionAndAnswers.answers mutableCopy];
        //NSMutableArray *array = self.questionAndAnswers.answers;
        [self shuffle:array];
        self.questionAndAnswers.answers = array;
        self.QuestionLabel.text = self.questionAndAnswers.question;
        [self startTimer];
        [self.tableView reloadData];
    }
      onFailure:^(NSError *error) {
        [self errorAlertWithError:error];

    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.questionAndAnswers.answers count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"answerCell"];
    
    cell.textLabel.text = [self.questionAndAnswers.answers objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_time_t delayAfterTrue = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_time_t delayAfterFalse = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    tableView.allowsSelection = NO;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.textLabel.text == self.trueAnswer) {
        //NSLog(@"Правильный ответ!");
        [self.countdownTimer invalidate];
        NSUInteger answerTime = [self.gameDifficulty getCountdownDuration] - self.currentCountdown;
        [self.gameDelegate trueAnswerWithTime:answerTime];
        cell.backgroundColor = self.trueAnswerColor;
        dispatch_after(delayAfterTrue, dispatch_get_main_queue(), ^{
            cell.backgroundColor = [UIColor blackColor];
            [self getQuestion];
            tableView.allowsSelection = YES;
        });

    } else {
        //NSLog(@"Неправильный ответ!");
        [self.countdownTimer invalidate];
        cell.backgroundColor = self.falseAnswerColor;
        dispatch_after(delayAfterFalse, dispatch_get_main_queue(), ^{
            cell.backgroundColor = [UIColor blackColor];
            [self gameCompletion];
        });
    }
}

#pragma mark - Notifications

- (void) trueAnswersCountNotification:(NSNotification*) notification {
    NSNumber* value = [notification.userInfo objectForKey:trueAnswersCountUserInfoKey];
    self.trueAnswersCountLabel.text = [NSString stringWithFormat:@"Правильных ответов: %@",value];
}

#pragma mark - Other methods

- (void)shuffle:(NSMutableArray *)array {
    for (NSUInteger i = [array count]; i > 1; i--) {
        NSUInteger x = arc4random_uniform((u_int32_t)i);
        [array exchangeObjectAtIndex: i - 1 withObjectAtIndex:x];
    }
}

- (void)fiftyFiftyAnswers {
    NSPredicate *falseAnswerPredicate = [NSPredicate predicateWithFormat:@"SELF != %@",self.trueAnswer];
    NSArray *falseAnswers = [self.questionAndAnswers.answers filteredArrayUsingPredicate:falseAnswerPredicate];
    NSString *randomAnswer = [falseAnswers objectAtIndex:arc4random_uniform((u_int32_t)[falseAnswers count])];
    self.questionAndAnswers.answers = [NSMutableArray arrayWithObjects:self.trueAnswer,randomAnswer,nil];
    //добавить shuffle
    [self.fiftyFiftyButton setHidden:YES];
    [self.tableView reloadData];
}

-(void) gameCompletion {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self findTrueAnswer] inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = self.trueAnswerColor;
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        cell.backgroundColor = [UIColor blackColor];
        [self endGameAlert];
        //[self.gameDelegate didEndGame];
        //[self dismissViewControllerAnimated:NO completion:nil];
    });
}

- (NSInteger) findTrueAnswer {
    NSInteger trueAnswerIndex = 0;
    for (int i = 0; i < [self.questionAndAnswers.answers count]; i++) {
        if ([[self.questionAndAnswers.answers objectAtIndex:i] isEqual:self.trueAnswer]) {
            trueAnswerIndex = i;
            break;
        }
    }
    return trueAnswerIndex;
}

-(void) startTimer {
    self.currentCountdown = [self.gameDifficulty getCountdownDuration];
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleCountdown) userInfo:nil repeats:true];
}

-(void) handleCountdown {
    //NSLog(@"Timer: %ld", (long)self.currentCountdown);
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentCountdown];
    self.currentCountdown -= 1;
    if (self.currentCountdown == -1) {
        [self.countdownTimer invalidate];
        [self gameCompletion];
    }
}

- (void)endGameAlert {
    NSString *alertMessage = [NSString stringWithFormat:@"Правильных ответов: %lu \n Cреднее время ответа %.0f сек",Game.shared.gameSession.trueAnswersCount,Game.shared.gameSession.averageAnswersTime];
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"Игра окончена!" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        [self.gameDelegate didEndGame];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)errorAlertWithError:(NSError *)error {
    NSString *alertMessage = [NSString stringWithFormat:@"%@", [error localizedDescription]];
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"Ошибка загрузки данных!" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        [self.gameDelegate didEndGame];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
     
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
