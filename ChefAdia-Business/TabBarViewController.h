//
//  TabBarViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DishTableViewController;

@interface TabBarViewController : UITabBarController <UITabBarControllerDelegate>

@property (nonnull, nonatomic) IBOutlet UINavigationItem *naviItem;

@property (nonnull, nonatomic) DishTableViewController *dishTableViewController;

@end
