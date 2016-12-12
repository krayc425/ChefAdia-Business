//
//  UserDetailTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/7.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailTableViewController : UITableViewController

@property (nonnull, nonatomic) IBOutlet UILabel *idLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *bowlLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *ticketLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonnull, nonatomic) IBOutlet UIImageView *avatarImg;

@property (nonnull, nonatomic) IBOutlet UIButton *changeBowlButton;

@property (nonnull, nonatomic) NSDictionary *userInfo;

@end
