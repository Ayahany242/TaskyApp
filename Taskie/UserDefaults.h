//
//  UserDefaults.h
//  Taskie
//
//  Created by AYA on 20/04/2024.
//

#import <Foundation/Foundation.h>
#import "TaskModel.h"

@interface UserDefaults : NSObject
+(NSMutableArray *)loadTasksFromUserDefaults ;
+(void)saveData : (NSMutableArray<TaskModel *> *) tasks;

@end

