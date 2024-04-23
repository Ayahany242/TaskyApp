//
//  TaskPojo.m
//  ToDoList
//
//  Created by AYA on 03/04/2024.
//

#import "TaskPojo.h"

@implementation TaskPojo
//+ (BOOL)supportsSecureCoding{
//    return YES;
//}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.desc forKey:@"desciption"];
    [coder encodeInt:self.statue forKey:@"statue"];
    [coder encodeInt:self.taskPriority forKey:@"priority"];
    [coder encodeObject:self.date forKey:@"date"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if(self){
        self.name = [coder decodeObjectForKey:@"name"];
        self.desc = [coder decodeObjectForKey:@"desciption"];
        self.statue = [coder decodeIntForKey:@"statue"];
        self.taskPriority = [coder decodeIntForKey:@"priority"];
        self.date = [coder decodeObjectForKey:@"date"];
    }
    return self;
}

@end
