//
//  GameController.h
//  Millionaire
//
//  Created by Maksim Romanov on 08.05.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GameDelegate;

@interface GameController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@end

@protocol GameDelegate

- (void) didEndGameWithResult: (NSUInteger) result;

@end

NS_ASSUME_NONNULL_END
