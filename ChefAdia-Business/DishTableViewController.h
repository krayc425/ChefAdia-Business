//
//  DishTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishTableViewController : UITableViewController

@property (nonatomic, nonnull) NSMutableArray *typeArr;
@property (nonatomic, nonnull) NSMutableArray *typeFoodArr;

- (void)addAction:(_Nonnull id)sender;

@end
