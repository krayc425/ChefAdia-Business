//
//  OrderDetailTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/12.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailTableViewController : UITableViewController

@property (nonatomic) BOOL isCust;

@property (nonnull, nonatomic) NSString *orderID;
@property (nonnull, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *typeLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *isFinishedLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonnull, nonatomic) IBOutlet UIButton *changeStatusButton;

@property (nonnull, nonatomic) NSMutableArray *foodArr;

@end
