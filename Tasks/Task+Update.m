//
//  Task+Update.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/13/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "Task+Update.h"

@implementation Task (Update)

-(void)updateWithComplete:(BOOL)complete {
    self.complete = [NSNumber numberWithBool:complete];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        //we have an error!
        NSLog(@"%@", error);
    }
}

@end
