//
//  EditCategoryController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/11/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "EditCategoryController.h"
#import "ColorUtils.h"
#import "TextFieldCell.h"
#import "TaskCategory+Retrieve.h"
#import "TaskCategory+Create.h"
#import "TaskCategory+Update.h"

static NSString * const NameCellID = @"categoryDetailNameCell";
static NSString * const ColorCellID = @"categoryDetailColorCell";

@interface EditCategoryController ()

@property (nonatomic) NSDictionary *colors;
@property (nonatomic) NSArray *colorNames;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (weak, nonatomic) UITextField *textField;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation EditCategoryController

#pragma mark - IB Actions

- (IBAction)done:(id)sender {
    if (self.textField && [self.textField.text length]) {
        NSString *name = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *color = self.colorNames[self.selectedIndexPath.row];
        if (self.category) {
            [self.category updateWithName:name color:color];
            [self.unwindDelegate unwind:self];
        } else if ([TaskCategory retrieveCategoryWithName:name inManagedObjectContext:self.managedObjectContext]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"A category with the given name already exists." message:@"Category must have a unique name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            // create new category
            [TaskCategory categoryWithName:name colorName:color inManagedObjectContext:self.managedObjectContext];
            [self.unwindDelegate unwind:self];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name empty." message:@"Category must have a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Accessors

-(NSArray*)colorNames {
    if (!_colorNames) {
        _colorNames = [[ColorUtils colorNameArray] copy];
    }
    return _colorNames;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFieldCell" bundle:nil] forCellReuseIdentifier:NameCellID];
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];

    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.category) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:[self indexOfColor:self.category.color] inSection:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // fixed default height returned here only to silent warning (not nice!)
    return 44;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [self.colors count];
        default:
            return -1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    NSString *cellID = nil;
    if (indexPath.section == 0) {
        cellID = NameCellID;
    } else if (indexPath.section == 1) {
        cellID = ColorCellID;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if ([cellID isEqualToString:NameCellID]) {
        TextFieldCell *c = (TextFieldCell*)cell;
        self.textField = c.textField;
        if (self.category) {
            [c.textField setText:self.category.name];
        }
    }
    if ([cellID isEqualToString:ColorCellID]) {
        NSString *colorName = self.colorNames[indexPath.row];
        UIColor *color = [self.colors objectForKey:colorName];
        cell.imageView.image = [ColorUtils imageWithColor:color rect:CGRectMake(0, 0, 18, 18)];
        cell.imageView.layer.cornerRadius = 9;
        cell.imageView.clipsToBounds = YES;
        cell.textLabel.text = colorName;
        if ([self.selectedIndexPath isEqual:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // return nil for not selectable cells
    if (indexPath.section == 1) {
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    cell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    self.selectedIndexPath = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Helper Methods

-(NSInteger)indexOfColor:(NSString*)name {
    for (int idx = 0; idx < self.colorNames.count; idx++) {
        NSString *color = self.colorNames[idx];
        if ([color isEqualToString:name]) {
            return idx;
        }
    }
    return -1;
}

@end
