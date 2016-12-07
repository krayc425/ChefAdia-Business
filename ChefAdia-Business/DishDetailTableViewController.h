//
//  DishDetailTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishDetailTableViewController : UITableViewController

@property (nonatomic) int ID;

@property (nonnull, nonatomic) NSMutableArray *foodArr;

@property (nonatomic) int foodNum;

- (void)loadFood;

@end
