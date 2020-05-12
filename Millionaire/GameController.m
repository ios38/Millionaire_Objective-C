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

@property (assign,nonatomic)int questionsType;
@property (strong,nonatomic)QuestionAndAnswers *questionAndAnswers;
@property (strong,nonatomic)NSString *trueAnswer;
@property (assign,nonatomic)NSUInteger trueAnswersCount;

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
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    tableView.allowsSelection = NO;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (cell.textLabel.text == self.trueAnswer) {
        //NSLog(@"Правильный ответ!");
        self.trueAnswersCount++;
        //cell.backgroundColor = [UIColor trueAnswerColor];
        cell.backgroundColor = [UIColor greenColor];
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            cell.backgroundColor = [UIColor blackColor];
            [self getQuestion];
            tableView.allowsSelection = YES;
        });

    } else {
        //NSLog(@"Неправильный ответ!");
        cell.backgroundColor = [UIColor redColor];
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.gameDelegate didEndGameWithResult:self.trueAnswersCount];
            //cell.backgroundColor = [UIColor blackColor];
            //tableView.allowsSelection = YES;
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:NO completion:nil];
            });
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

@end
