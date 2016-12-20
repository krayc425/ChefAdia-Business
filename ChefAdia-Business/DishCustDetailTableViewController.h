//
//  DishCustDetailTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/20.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishCustDetailTableViewController : UITableViewController

@property (nonatomic) int ID;
@property (nonnull, nonatomic) NSString *name;

@property (nonnull, nonatomic) NSMutableArray *foodArr;

@end
