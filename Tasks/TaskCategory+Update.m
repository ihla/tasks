//
//  TaskCategory+Update.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "TaskCategory+Update.h"

@implementation TaskCategory (Update)

- (void)updateWithName:(NSString *)name color:(NSString *)color {
    BOOL categoryNameChanged = ![self.name isEqualToString:name];
    BOOL categoryColorChanged = ![self.color isEqualToString:color];
    if (categoryNameChanged || categoryColorChanged) {
        // update category
        if (categoryNameChanged) self.name = name;
        if (categoryColorChanged) self.color = color;
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            //we have an error!
            NSLog(@"%@", error);
        }
    }
}


@end
