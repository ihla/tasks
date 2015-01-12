//
//  BaseCategoryTableViewController.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "CoreDataTableViewController.h"

@class TaskCategory;

@interface BaseCategoryTableViewController : CoreDataTableViewController

@property (nonatomic) TaskCategory *selectedCategory;

@end
