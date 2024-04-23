//
//  UserDefaults.m
//  Taskie
//
//  Created by AYA on 20/04/2024.
//

#import "UserDefaults.h"

@implementation UserDefaults

+(NSMutableArray *)loadTasksFromUserDefaults {
    NSData *tasksData = [[NSUserDefaults standardUserDefaults] objectForKey:@"TasksList"];
    printf("loadTasksFromUserDefaults tasksData lenght %d\n",(int)tasksData.length);
    if (tasksData !=nil) {
        NSMutableArray *tasksArray = [NSKeyedUnarchiver unarchiveObjectWithData:tasksData];
        printf("tasksData !=nil %d successful\n",(int)tasksData.length);
        printf("savedTasksData != nil \n");
        printf("savedTasksArray %d \n",(int)tasksArray.count);
        return tasksArray;
    }
    printf("failed tasksData lenght %d\n",(int)tasksData.length);
    return nil;
}
+(void)saveData:(NSMutableArray<TaskModel *> *)tasks{
    NSError *error = nil;
    printf("saveData _tasks count = %d \n", (int)tasks.count);
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tasks];
    if (data != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"TasksList"];
        BOOL success = [[NSUserDefaults standardUserDefaults] synchronize];
        if (success) {
            NSLog(@"Data saved successfully.");
        } else {
            NSLog(@"Failed to synchronize defaults.");
        }
    } else {
        NSLog(@"Error archiving data: %@", error.localizedDescription);
    }
}
@end
