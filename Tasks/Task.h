//
//  Task.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaskCategory;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * notificationEnabled;
@property (nonatomic, retain) NSDate * due;
@property (nonatomic, retain) NSNumber * complete;
@property (nonatomic, retain) TaskCategory *category;

@end
