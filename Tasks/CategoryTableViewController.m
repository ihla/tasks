//
//  CategoryTableViewController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/11/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "ImageUtils.h"
#import "AddCategoryTableViewController.h"

@interface CategoryTableViewController ()  <UnwindDelegate>

@end

@implementation CategoryTableViewController

#pragma mark - IB Actions

- (IBAction)cancel:(id)sender {
    [self.unwindDelegate unwind:self];
}

#pragma mark - Life Cycle Methods

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nvc = (UINavigationController *)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"showCategoryDetail"]) {
        AddCategoryTableViewController *categoryController = (AddCategoryTableViewController*)nvc.topViewController;
        categoryController.unwindDelegate = self;
    }
}

#pragma mark - UnwindDelegate

-(void)unwind:(UIViewController*)controller {
    if ([controller isKindOfClass:[AddCategoryTableViewController class]]) {
        // retrieve return data from ctrl if necessary
    }
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utilities

- (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect {
    return [ImageUtils imageWithColor:color rect:rect];
}

@end
