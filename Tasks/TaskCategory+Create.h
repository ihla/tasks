//
//  TaskCategory+Create.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "TaskCategory.h"

@interface TaskCategory (Create)

+ (TaskCategory *) categoryWithName:(NSString *)name colorName:(NSString *)color inManagedObjectContext:(NSManagedObjectContext *)context;

@end
