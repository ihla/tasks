//
//  CategoryListController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/11/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "CategoryListController.h"
#import "EditCategoryController.h"

@interface CategoryListController ()

@end

@implementation CategoryListController

#pragma mark - IB Actions

- (IBAction)cancel:(id)sender {
    [self.unwindDelegate unwind:self];
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.unwindDelegate unwind:self];
}

@end
