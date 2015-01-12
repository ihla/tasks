//
//  TaskDetailViewController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/10/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

/**
 * NOTE:    This implementation is based on the sources from Apple DateCell sample
 *          (https://developer.apple.com/library/ios/samplecode/DateCell/)
 *          and is adapted to my needs.
 *          The code is a work in progress and needs further refactoring.
 */

#import "TaskDetailViewController.h"
#import "CategoryListController.h"
#import "TextFieldCell.h"
#import "TaskCategory+Retrieve.h"

#define kDatePickerTag              99     // view tag identifiying the date picker view

static NSString *kNameCellID = @"nameCell";
static NSString *kRemindMeCellID = @"remindMeCell";
static NSString *kDateCellID = @"dateCell";
static NSString *kDatePickerID = @"datePicker";
static NSString *kCategoryCellID = @"categoryCell";

// table view sections and rows (why not make it as static cells instead???)
static NSInteger kCategorySection = 1;
static NSInteger kCategoryRow = 0;
static NSInteger kAlarmSection = 2;
static NSInteger kRemindMeRow = 0;
static NSInteger kDateRow = 1; // inserted/deleted depending on the switch in remind me row

static NSInteger kNumberOfStaticRowsInNameSection = 1;
static NSInteger kNumberOfStaticRowsInCategorySection = 1;
static NSInteger kNumberOfStaticRowsInAlarmSection = 1;

static NSInteger kNumberOfSections = 3;

@interface TaskDetailViewController () <UnwindDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (assign) NSInteger pickerCellRowHeight;
@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (assign) NSInteger alarmSectionNumberOfRows;
@property(nonatomic) NSDate *setDate;
@property (weak, nonatomic) UITextField *textField;
@property (nonatomic) TaskCategory *selectedCategory;
@property (nonatomic) NSIndexPath *categoryIndexPath;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation TaskDetailViewController

#pragma mark - IB Actions

- (IBAction)done:(id)sender {
    [self.unwindDelegate unwind:self];
}

- (IBAction)switchAlarm:(UISwitch*)sender {
    if (sender.on) {
        [self insertAlarmRow];
    } else {
        [self deleteAlarmRows];
    }
}

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    self.setDate = targetedDatePicker.date;
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:kNameCellID];
    
    self.categoryIndexPath = [NSIndexPath indexPathForRow:kCategoryRow inSection:kCategorySection];
    self.selectedCategory = [TaskCategory retrieveCategoryWithName:@"Chore" inManagedObjectContext:self.managedObjectContext];
    
    self.alarmSectionNumberOfRows = kNumberOfStaticRowsInAlarmSection;
    
    self.setDate = [NSDate date]; // set the current date as init value
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
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


#pragma mark - Utilities

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:kAlarmSection]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            [targetedDatePicker setDate:self.setDate animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.section == indexPath.section && self.datePickerIndexPath.row == indexPath.row);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : 44);
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return kNumberOfStaticRowsInNameSection;
        case 1:
            return kNumberOfStaticRowsInCategorySection;
        case 2:
            return self.alarmSectionNumberOfRows;
        default:
            return -1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    NSString *cellID = nil;
    
    switch (indexPath.section) {
        case 0:
            cellID = kNameCellID;
            break;
        case 1:
            cellID = kCategoryCellID;
            break;
        case 2:
            if (indexPath.row == kRemindMeRow) {
                cellID = kRemindMeCellID;
            } else if (indexPath.row == kDateRow) {
                cellID = kDateCellID;
            } else if ([self indexPathHasPicker:indexPath]) {
                cellID = kDatePickerID;
            }
            break;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if ([cellID isEqualToString:kNameCellID])
    {
        TextFieldCell *nameCell = (TextFieldCell*)cell;
        self.textField = nameCell.textField;
    }
    
    if ([cellID isEqualToString:kCategoryCellID]) {
        [cell.detailTextLabel setText:[self.selectedCategory name]];
    }
    
    if ([cellID isEqualToString:kRemindMeCellID])
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if ([cellID isEqualToString:kDateCellID])
    {
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.setDate];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID)
    {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - TableView Manipulate Methods

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:kAlarmSection]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
        self.alarmSectionNumberOfRows--;
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
        self.alarmSectionNumberOfRows++;
    }
    
    [self.tableView endUpdates];
}

- (void)deleteDatePickerRowIfExists
{
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        self.alarmSectionNumberOfRows--;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:kAlarmSection]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    [self deleteDatePickerRowIfExists];
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:kAlarmSection];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:kAlarmSection];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

-(void)insertAlarmRow {
    [self.tableView beginUpdates];
    
    self.alarmSectionNumberOfRows++;
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:kDateRow inSection:kAlarmSection]];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

    [self.tableView endUpdates];
}

-(void)deleteAlarmRows {
    [self.tableView beginUpdates];
    
    self.alarmSectionNumberOfRows--;
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:kDateRow inSection:kAlarmSection]];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    [self deleteDatePickerRowIfExists];
    
    [self.tableView endUpdates];
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nvc = (UINavigationController *)segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"showCategory"]) {
        CategoryListController *categoryController = (CategoryListController*)nvc.topViewController;
        categoryController.unwindDelegate = self;
        categoryController.selectedCategory = self.selectedCategory;
        
    }
}

#pragma mark - UnwindDelegate

-(void)unwind:(UIViewController*)controller {
    if ([controller isKindOfClass:[CategoryListController class]]) {
        self.selectedCategory = ((CategoryListController*)controller).selectedCategory;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.categoryIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
