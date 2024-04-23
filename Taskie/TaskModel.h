//
//  TaskModel.h
//  Taskie
//
//  Created by AYA on 20/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : NSObject<NSCoding>

@property NSString *title,*note, *date;
@property int taskPriority,statue;

@end

NS_ASSUME_NONNULL_END
