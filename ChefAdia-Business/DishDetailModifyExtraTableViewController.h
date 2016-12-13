//
//  DishDetailModifyExtraTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/13.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailExtraDelegate <NSObject>

- (void)passExtras:(NSArray *_Nonnull)arr;

@end

@interface DishDetailModifyExtraTableViewController : UITableViewController

@property (nonnull, nonatomic) id<DetailExtraDelegate> extraDelegate;

@property (nonnull, nonatomic) NSMutableArray *foodArr;
//初始已经被选中的
@property (nonnull, nonatomic) NSMutableArray *selectExtraArr;

@end
