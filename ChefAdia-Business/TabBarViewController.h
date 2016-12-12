//
//  TabBarViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DishTableViewController;
@class OrderTableViewController;
@class UserTableViewController;

@interface TabBarViewController : UITabBarController <UITabBarControllerDelegate>

@property (nonnull, nonatomic) IBOutlet UINavigationItem *naviItem;

@property (nonnull, nonatomic) OrderTableViewController *orderTableViewController;
@property (nonnull, nonatomic) DishTableViewController *dishTableViewController;
@property (nonnull, nonatomic) UserTableViewController *userTableViewController;

@end
