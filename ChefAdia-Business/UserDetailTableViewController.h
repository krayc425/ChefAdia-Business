//
//  UserDetailTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/7.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailTableViewController : UITableViewController

@property (nonatomic) IBOutlet UILabel *idLabel;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UILabel *bowlLabel;
@property (nonatomic) IBOutlet UILabel *ticketLabel;
@property (nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic) IBOutlet UIImageView *avatarImg;

@property (nonnull, nonatomic) NSDictionary *userInfo;

@end
