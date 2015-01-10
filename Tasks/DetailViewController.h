//
//  DetailViewController.h
//  Tasks
//
//  Created by Lubos Ilcik on 1/10/15.
//  Copyright (c) 2015 Lubos Ilcik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

