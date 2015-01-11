//
//  TaskDetailViewController.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/10/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnwindDelegate.h"

@interface TaskDetailViewController : UITableViewController

@property (nonatomic, weak) id<UnwindDelegate> unwindDelegate;

@end
