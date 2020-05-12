//
//  GameController.m
//  Millionaire
//
//  Created by Maksim Romanov on 08.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "GameController.h"
#import "NetworkService.h"
#import "QuestionAndAnswers.h"
#import "Game.h"

@implementation UIColor (Layout)

+ (UIColor *) trueAnswerColor {
    UIColor *color = [UIColor colorWithRed:0/255 green:100/255 blue:0/255 alpha:1];
    return color;
}

@end

@interface GameController ()

@property (weak, nonatomic) IBOutlet UILabel *questionDifficulty;
@property (weak, nonatomic) IBOutlet UILabel *QuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueAnswersCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *fiftyFiftyButton;

@property (weak, nonatomic) id <GameDelegate> gameDelegate;

@property (assign,nonatomic) int questionsType;
@property (strong,nonatomic) QuestionAndAnswers *questionAndAnswers;
@property (strong,nonatomic) NSString *trueAnswer;
@property (assign,nonatomic) NSUInteger trueAnswersCount;

@property (strong, nonatomic) NSTimer *countdownTimer;
@property (assign, nonatomic) NSInteger currentCountdown;

@end

@implementation GameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questionsType = 1;
    self.questionAndAnswers = [[QuestionAndAnswers alloc] init];
    self.QuestionLabel.text = self.questionAndAnswers.question;
    self.questionDifficulty.text = @"Уровень сложности: 1";
    self.trueAnswersCountLabel.text = @"Правильных ответов: 0";
    [self.fiftyFiftyButton addTarget:self action:@selector(fiftyFiftyAnswers) forControlEvents:UIControlEventTouchUpInside];
    self.gameDelegate = Game.shared.gameSession;
    [self getQuestion];
}

#pragma mark - API

- (void) getQuestion {
    [[NetworkService shared] getQuestionWithType:self.questionsType
      onSuccess:^(QuestionAndAnswers *questionAndAnswers) {

        self.questionAndAnswers = questionAndAnswers;
        self.trueAnswer = [questionAndAnswers.answers objectAtIndex:0];
        //NSMutableArray *array = self.questionAndAnswers.answers;
        //[self shuffle:array];
        //self.questionAndAnswers.answers = array;
        self.QuestionLabel.text = self.questionAndAnswers.question;
        self.currentCountdown = 5;
        [self startTimer];
        [self.tableView reloadData];
    }
      onFailure:^(NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
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
        self.trueAnswersCount++;
        //cell.backgroundColor = [UIColor trueAnswerColor];
        cell.backgroundColor = [UIColor greenColor];
        dispatch_after(delayAfterTrue, dispatch_get_main_queue(), ^{
            cell.backgroundColor = [UIColor blackColor];
            [self getQuestion];
            tableView.allowsSelection = YES;
        });

    } else {
        //NSLog(@"Неправильный ответ!");
        [self.countdownTimer invalidate];
        cell.backgroundColor = [UIColor redColor];
        dispatch_after(delayAfterFalse, dispatch_get_main_queue(), ^{
            cell.backgroundColor = [UIColor blackColor];
            [self gameCompletion];
        });
    }
}

#pragma mark - Setters

- (void)setTrueAnswersCount:(NSUInteger)trueAnswersCount {
    _trueAnswersCount = trueAnswersCount;
    self.trueAnswersCountLabel.text = [NSString stringWithFormat:@"Правильных ответов: %lu", (unsigned long)self.trueAnswersCount];
}

- (void)setQuestionsType:(int)questionsType {
    _questionsType = questionsType;
    self.questionDifficulty.text = [NSString stringWithFormat:@"Уровень сложности: %d", self.questionsType];
}


#pragma mark - Other methods

- (void)shuffle:(NSMutableArray *)array {
    for (NSUInteger i = [array count]; i > 1; i--) {
        [array exchangeObjectAtIndex: i - 1 withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

- (void)fiftyFiftyAnswers {
    NSPredicate *falseAnswerPredicate = [NSPredicate predicateWithFormat:@"SELF != %@",self.trueAnswer];
    NSArray *falseAnswers = [self.questionAndAnswers.answers filteredArrayUsingPredicate:falseAnswerPredicate];
    NSString *randomAnswer = [falseAnswers objectAtIndex:arc4random_uniform((u_int32_t)[falseAnswers count])];
    self.questionAndAnswers.answers = [NSMutableArray arrayWithObjects:self.trueAnswer,randomAnswer,nil];
    //добавить shuffle
    [self.tableView reloadData];
}

-(void) gameCompletion {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        cell.backgroundColor = [UIColor blackColor];
        [self.gameDelegate didEndGameWithResult:self.trueAnswersCount];
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

-(void) startTimer {
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleCountdown) userInfo:nil repeats:true];
}

-(void) handleCountdown {
    NSLog(@"Timer: %ld", (long)self.currentCountdown);
    self.currentCountdown -= 1;
    if (self.currentCountdown == -1) {
        [self.countdownTimer invalidate];
        [self gameCompletion];
    }
}

@end
