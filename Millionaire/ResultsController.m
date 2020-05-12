//
//  ResultsController.m
//  Millionaire
//
//  Created by Maksim Romanov on 09.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import "ResultsController.h"
#import "Game.h"
#import "GameResult.h"

@interface ResultsController ()

@property (strong,nonatomic)NSDateFormatter *dateFormatter;

- (IBAction)backButton:(id)sender;

@end

@implementation ResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd.MM.yy hh-mm";
}

- (IBAction)backButton:(id)sender {

    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Game.shared.gameResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"resultCell"];
    GameResult *gameResult = [Game.shared.gameResults objectAtIndex:indexPath.row];
    //NSLog(@"date = %@, result = %@", gameResult.date, gameResult.result);
    cell.textLabel.text = [self.dateFormatter stringFromDate:gameResult.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",gameResult.result];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}


@end
