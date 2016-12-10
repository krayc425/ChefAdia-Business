//
//  TabBarViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    [self.naviItem setTitle:@"Order"];
    
    self.dishTableViewController = (DishTableViewController *)self.viewControllers[1];
    
    [self.tabBarItem setImageInsets:UIEdgeInsetsMake(10, 0, -10, 0)];
    [[self.tabBar.items objectAtIndex:0] setTitle:@"Order"];
//    [[self.tabBar.items objectAtIndex:0] setImage:[UIImage imageNamed:@"TAB_FOOD"]];
    [[self.tabBar.items objectAtIndex:1] setTitle:@"Dish"];
//    [[self.tabBar.items objectAtIndex:1] setImage:[UIImage imageNamed:@"TAB_FIND"]];
    [[self.tabBar.items objectAtIndex:2] setTitle:@"User"];
//    [[self.tabBar.items objectAtIndex:2] setImage:[UIImage imageNamed:@"TAB_ME"]];

}

#pragma mark - UITabBarController Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    switch (self.selectedIndex) {
        case 0:
        {
            [self.naviItem setTitle:@"Order"];
            self.naviItem.rightBarButtonItems = nil;
        }
            break;
        case 1:
        {
            [self.naviItem setTitle:@"Dish"];
            UIBarButtonItem *R1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self.dishTableViewController
                                                                                action:@selector(addAction)];
            self.naviItem.rightBarButtonItems = [NSArray arrayWithObjects:R1,nil];
        }
            break;
        case 2:
        {
            [self.naviItem setTitle:@"User"];
            self.naviItem.rightBarButtonItems = nil;
        }
            break;
        default:
            break;
    }
}


@end
