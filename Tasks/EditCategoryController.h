//
//  EditCategoryController.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/11/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnwindDelegate.h"

@interface EditCategoryController : UITableViewController

@property (nonatomic, weak) id<UnwindDelegate> unwindDelegate;

@end
