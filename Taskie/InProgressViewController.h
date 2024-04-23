//
//  InProgressViewController.h
//  Taskie
//
//  Created by AYA on 19/04/2024.
//

#import <UIKit/UIKit.h>
#import "DelegationNavigation.h"
#import "TaskModel.h"

@interface InProgressViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,DelegationNavigation>
@property NSMutableArray<TaskModel *> *tasks;

@property NSMutableArray<TaskModel *> *showsTasks;

@end
