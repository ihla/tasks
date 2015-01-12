//
//  EditCategoryController.m
//  Tasks
//
//  Created by Lubos Ilcik on 1/11/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import "EditCategoryController.h"
#import "ColorUtils.h"

@interface EditCategoryController ()

@property (nonatomic) NSDictionary *colors;
@property (nonatomic) NSArray *colorNames;

@end

@implementation EditCategoryController

#pragma mark - IB Actions

- (IBAction)done:(id)sender {
    [self.unwindDelegate unwind:self];
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
        _colors = [[self colorsDictionary] copy];
    }
    return _colors;
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    NSString *nameCellID = @"categoryDetailNameCell";
    NSString *colorCellID = @"categoryDetailColorCell";
    
    UITableViewCell *cell = nil;
    NSString *cellID = nil;
    if (indexPath.section == 0) {
        cellID = nameCellID;
    } else if (indexPath.section == 1) {
        cellID = colorCellID;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if ([cellID isEqualToString:colorCellID]) {
        NSString *colorName = self.colorNames[indexPath.row];
        UIColor *color = [self.colors objectForKey:colorName];
        cell.imageView.image = [ColorUtils imageWithColor:color rect:CGRectMake(0, 0, 18, 18)];
        cell.imageView.layer.cornerRadius = 9;
        cell.imageView.clipsToBounds = YES;
        cell.textLabel.text = colorName;
    }
    
    return cell;
}

#pragma mark - Helper Methods

-(NSDictionary*)colorsDictionary{
    NSArray *uiColors = [[ColorUtils uiColorArray] copy];
    NSDictionary *colors = [NSDictionary dictionaryWithObjects:uiColors forKeys:self.colorNames];
    return colors;
}

@end
