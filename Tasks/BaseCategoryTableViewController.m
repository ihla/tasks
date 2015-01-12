//
//  BaseCategoryTableViewController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/12/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "BaseCategoryTableViewController.h"
#import "ColorUtils.h"
#import "TaskCategory.h"

@interface BaseCategoryTableViewController ()

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation BaseCategoryTableViewController

#pragma mark - Accessories

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TaskCategory"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark - Life Cycle Methods


- (void)viewDidLoad {
    [super viewDidLoad];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];

    TaskCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [cell.textLabel setText:category.name];
    cell.imageView.image = [ColorUtils imageWithColorName:category.color rect:CGRectMake(0, 0, 18, 18)];
    cell.imageView.layer.cornerRadius = 9;
    cell.imageView.clipsToBounds = YES;
    
    return cell;
}

#pragma mark - Utilities

- (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect {
    return [ColorUtils imageWithColor:color rect:rect];
}

@end
