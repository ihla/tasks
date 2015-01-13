//
//  TaskCategory+Create.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "TaskCategory+Create.h"

@implementation TaskCategory (Create)

+ (TaskCategory *) categoryWithName:(NSString *)name colorName:(NSString *)color inManagedObjectContext:(NSManagedObjectContext *)context {
    TaskCategory *category = nil;
    
    if ([name length] && [color length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TaskCategory"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // category with given name must be unique!
        if (!matches || ([matches count] > 1)) {
            //TODO handle error
        } else if (![matches count]) {
            category = [NSEntityDescription insertNewObjectForEntityForName:@"TaskCategory" inManagedObjectContext:context];
            category.name = name;
            category.color = color;
            
            NSError *error = nil;
            if (![context save:&error]){
                //we have an error!
                NSLog(@"%@", error);
            }
            
        } else {
            category = [matches lastObject];
        }
    }
    return category;
}

@end
