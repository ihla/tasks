//
//  Task+Delete.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/13/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "Task+Delete.h"

@implementation Task (Delete)

-(void)delete {
    [self.managedObjectContext deleteObject:self];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        //we have an error!
        NSLog(@"%@", error);
    }
}

@end
