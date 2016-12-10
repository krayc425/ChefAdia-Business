//
//  UserTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/7.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewController : UITableViewController <UISearchResultsUpdating>

@property (nonatomic, nonnull) NSMutableArray *userArr;

@property (nonnull, nonatomic) UISearchController *searchController;

@property (nonnull, nonatomic) NSMutableArray *filteredUserArr; // 根据searchController搜索的城市

@end
