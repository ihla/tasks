//
//  SettingsTableViewController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/11/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "CategoryTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

#pragma mark - IB Actions

- (IBAction)switchNotifications:(UISwitch *)sender {
}

- (IBAction)setOrdering:(UISegmentedControl *)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // return nil for not selectable cells
    if (indexPath.section == 0) {
        return indexPath;
    }
    return nil;
}



@end
