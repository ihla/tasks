//
//  TasksTableViewController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/10/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "TasksTableViewController.h"
#import "TaskCell.h"
#import "EditTaskController.h"
#import "ColorUtils.h"
#import "UserSettings.h"
#import "TaskCategory.h"
#import "Task+Delete.h"
#import "Task+Update.h"

static NSString * const CellIdentifier = @"TaskCell";

@interface TasksTableViewController () <SWTableViewCellDelegate, UnwindDelegate>

@property (nonatomic) NSDictionary *colors;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic) Task *selectedTask;

@end

@implementation TasksTableViewController

#pragma mark - Accessories

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    if ([UserSettings tasksOrder] == ALPHABETICAL) {
        [self fetchTaskSortedAlphabeticallyWithContext:managedObjectContext];
    } else {
        [self fetchTaskSortedChronologicallyWithContext:managedObjectContext];
    }
}

-(NSDictionary*)colors {
    if (!_colors) {
        _colors = [[ColorUtils colorsDictionary] copy];
    }
    return _colors;
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];

    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self.tableView setRowHeight:68];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];

    // if task order in user defaults is changed, we need to refresh table
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:[UserSettings taskOrderKey] options:NSKeyValueObservingOptionNew context:NULL];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:[UserSettings notificationsEnabledKey] options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];

    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:[UserSettings taskOrderKey]];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:[UserSettings notificationsEnabledKey]];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    cell.name.text = task.name;
    cell.due.text = [self.dateFormatter stringFromDate:task.due];
    [cell.category setBackgroundColor:self.colors[task.category.color]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showTask" sender:self];
}

#pragma mark - Helper Methods

- (void)addCompleteButton:(NSMutableArray *)utilityButtons
{
    [utilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0] title:@"Complete"];
}

- (void)addDeleteButton:(NSMutableArray *)utilityButtons
{
    [utilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete"];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [self addCompleteButton:rightUtilityButtons];
    [self addDeleteButton:rightUtilityButtons];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    return nil;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self didTriggerRightUtilityButtonWithIndex:index forTask:task];
}

-(void)didTriggerRightUtilityButtonWithIndex:(NSInteger)index forTask:(Task*)task {
    switch (index) {
        case 0:
            [task updateWithComplete:YES];
            break;
        case 1:
            [task delete];
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nvc = (UINavigationController *)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"showNewTask"]) {
        EditTaskController *editTaskController = (EditTaskController*)nvc.topViewController;
        editTaskController.unwindDelegate = self;

    } else if ([segue.identifier isEqualToString:@"showTask"]) {
        EditTaskController *editTaskController = (EditTaskController*)nvc.topViewController;
        editTaskController.unwindDelegate = self;
        editTaskController.task = self.selectedTask;
    }
}

#pragma mark - UnwindDelegate

-(void)unwind:(UIViewController*)controller {
    if ([controller isKindOfClass:[EditTaskController class]]) {
        
        Task *task = ((EditTaskController*)controller).task;
        NSDate *alarmDate = task.due;
        if (alarmDate && [UserSettings notificationsEnabled]) {
            [self scheduleNotificationWithTask:task];
        }
        
    }
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}

-(void)scheduleNotificationWithTask:(Task*)task {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = task.due;
    notification.alertBody = [NSString stringWithFormat:@"Task %@ is due.", task.name];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    // no need to send id, this is solely for a test
    NSURL *objectURL = [task.objectID URIRepresentation];
    notification.userInfo = @{ @"objectID" : [objectURL absoluteString], @"name" : task.name };
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}

#pragma mark - User Defaults observer

- (void)observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context {
    if ([keyPath isEqual:[UserSettings taskOrderKey]]) {
        if ([UserSettings tasksOrder] == ALPHABETICAL) {
            [self fetchTaskSortedAlphabeticallyWithContext:self.managedObjectContext];
        } else {
            [self fetchTaskSortedChronologicallyWithContext:self.managedObjectContext];
        }
    } else if ([keyPath isEqual:[UserSettings notificationsEnabledKey]]) {
        if ([UserSettings notificationsEnabled]) {
            for (Task *task in [self.fetchedResultsController fetchedObjects]) {
                BOOL isDueLater = [task.due compare:[NSDate date]] == NSOrderedDescending;
                BOOL isNotComplete = [task.complete isEqualToNumber:[NSNumber numberWithBool:NO]];
                if (isNotComplete && isDueLater) {
                    [self scheduleNotificationWithTask:task];
                }
            }
            
        } else {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    }
}

#pragma mark - Fetch Requests

-(void)fetchTaskSortedAlphabeticallyWithContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.predicate = [NSPredicate predicateWithFormat:@"complete = %@", [NSNumber numberWithBool:NO]];
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
    request.predicate = [NSPredicate predicateWithFormat:@"complete = %@", [NSNumber numberWithBool:NO]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"due"
                                                              ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

@end
