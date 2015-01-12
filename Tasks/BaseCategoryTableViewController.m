//
//  BaseCategoryTableViewController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "BaseCategoryTableViewController.h"
#import "ImageUtils.h"

@interface BaseCategoryTableViewController ()

@end

@implementation BaseCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];

    [cell.textLabel setText:@"TODO"];
    cell.imageView.image = [self imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 18, 18)];
    cell.imageView.layer.cornerRadius = 9;
    cell.imageView.clipsToBounds = YES;
    
    return cell;
}

#pragma mark - Utilities

- (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect {
    return [ImageUtils imageWithColor:color rect:rect];
}

@end
