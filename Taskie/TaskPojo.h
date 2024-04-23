//
//  TaskPojo.h
//  ToDoList
//
//  Created by AYA on 03/04/2024.
//

#import <Foundation/Foundation.h>

@interface TaskPojo : NSObject <NSCoding>

@property NSString *name,*desc, *date;
@property int taskPriority,statue;

@end

