//
//  AddTaskViewController.h
//  Taskie
//
//  Created by AYA on 20/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
#import "DelegationNavigation.h"

@interface AddTaskViewController : UIViewController

@property TaskModel *task;
@property int btnMethod;
@property id<DelegationNavigation> taskProtocol;
@property int taskIndex;


@end

