//
//  DishDetailTableViewCell.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishDetailTableViewCell : UITableViewCell

@property (nonnull, nonatomic) IBOutlet UIImageView *picView;

@property (nonnull, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *goodLabel;
@property (nonnull, nonatomic) IBOutlet UILabel *badLabel;

@end
