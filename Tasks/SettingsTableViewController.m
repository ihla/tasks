//
//  SettingsTableViewController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/11/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "CategoryListController.h"
#import "UserSettings.h"

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *notificationsSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderControl;

@end

@implementation SettingsTableViewController

#pragma mark - IB Actions

- (IBAction)switchNotifications:(UISwitch *)sender {
    if (sender.on) {
        [UserSettings setNotificationsEnabled:YES];
    } else {
        [UserSettings setNotificationsEnabled:NO];
    }
}

- (IBAction)setOrdering:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [UserSettings setTasksOrder:ALPHABETICAL];
    } else {
        [UserSettings setTasksOrder:CHRONOLOGICAL];
    }
}

#pragma mark - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.notificationsSwitch.on = [UserSettings notificationsEnabled];
    self.orderControl.selectedSegmentIndex = [UserSettings tasksOrder] == ALPHABETICAL ? 0 : 1;
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
