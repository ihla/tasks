//
//  TasksTableViewController.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/10/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "CoreDataTableViewController.h"

@class Task;

@interface TasksTableViewController : CoreDataTableViewController

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

// helper methods for subclass
- (void)addDeleteButton:(NSMutableArray *)utilityButtons;

@end
