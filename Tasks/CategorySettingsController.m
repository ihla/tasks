//
//  CategorySettingsController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "CategorySettingsController.h"
#import "EditCategoryController.h"
#import "TaskCategory.h"
#import "Debuglog.h"

@interface CategorySettingsController () <UnwindDelegate>

@end

@implementation CategorySettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nvc = (UINavigationController *)segue.destinationViewController;
    EditCategoryController *editCategoryController = (EditCategoryController*)nvc.topViewController;
    editCategoryController.unwindDelegate = self;
    if ([segue.identifier isEqualToString:@"editCategory"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TaskCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
        editCategoryController.category = category;
    } else {
        // create new category
        editCategoryController.category = nil;
    }
}

#pragma mark - UnwindDelegate

-(void)unwind:(UIViewController*)controller {
    if ([controller isKindOfClass:[EditCategoryController class]]) {
        // retrieve return data from ctrl if necessary
    }
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
