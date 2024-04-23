//
//  Delegation.h
//  Taskie
//
//  Created by AYA on 20/04/2024.
//

#import <Foundation/Foundation.h>
#import "TaskModel.h"

@protocol DelegationNavigation <NSObject>

-(void) addNewTask:(TaskModel *) task;
-(void) updateTask:(TaskModel *) task index:(int) index;

@end
