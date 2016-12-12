//
//  OrderTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/12.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewController : UITableViewController

@property (nonatomic, nonnull) IBOutlet UILabel *dateLabel;
@property (nonatomic, nonnull) NSDate *selectDate;

@property (nonatomic, nonnull) UITextField *dateText;

@property (nonnull, nonatomic) NSMutableArray *orderArr;

@end
