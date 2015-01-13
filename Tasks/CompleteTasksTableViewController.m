//
//  CompleteTasksTableViewController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/13/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "CompleteTasksTableViewController.h"
#import "SWTableViewCell.h"
#import "Task+Delete.h"

@interface CompleteTasksTableViewController ()

@end

@implementation CompleteTasksTableViewController

#pragma mark - SWTableViewDelegate

-(void)didTriggerRightUtilityButtonWithIndex:(NSInteger)index forTask:(Task*)task {
    switch (index) {
        case 0:
            [task delete];
        default:
            break;
    }
}

#pragma mark - Helper Methods

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [self addDeleteButton:rightUtilityButtons];
    
    return rightUtilityButtons;
}

#pragma mark - Fetch Requests

-(void)fetchTaskSortedAlphabeticallyWithContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.predicate = [NSPredicate predicateWithFormat:@"complete = %@", [NSNumber numberWithBool:YES]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(void)fetchTaskSortedChronologicallyWithContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.predicate = [NSPredicate predicateWithFormat:@"complete = %@", [NSNumber numberWithBool:YES]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"due"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

@end
