//
//  TaskModel.m
//  Taskie
//
//  Created by AYA on 20/04/2024.
//

#import "TaskModel.h"

@implementation TaskModel

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.note forKey:@"note"];
    [coder encodeInt:self.statue forKey:@"statue"];
    [coder encodeInt:self.taskPriority forKey:@"priority"];
    [coder encodeObject:self.date forKey:@"date"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if(self){
        self.title = [coder decodeObjectForKey:@"title"];
        self.note = [coder decodeObjectForKey:@"note"];
        self.statue = [coder decodeIntForKey:@"statue"];
        self.taskPriority = [coder decodeIntForKey:@"priority"];
        self.date = [coder decodeObjectForKey:@"date"];
    }
    return self;
}

@end
