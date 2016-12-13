//
//  DishDetailAddTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/12.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishDetailModifyExtraTableViewController.h"

@interface DishDetailModifyTableViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, DetailExtraDelegate>

@property (nonnull, nonatomic) UIImagePickerController* picker_library_;

@property (nonnull, nonatomic) NSString *typeID;

@property (nonatomic) Boolean isEdit;

@property (nonnull, nonatomic) IBOutlet UILabel *typeIDLabel;
@property (nonnull, nonatomic) IBOutlet UITextField *nameText;
@property (nonnull, nonatomic) IBOutlet UITextField *descriptionText;
@property (nonnull, nonatomic) IBOutlet UITextField *priceText;
@property (nonnull, nonatomic) IBOutlet UIImageView *pictureView;
@property (nonnull, nonatomic) IBOutlet UILabel *extraNumLabel;

@property (nonnull, nonatomic) NSString *typeName;
@property (nonnull, nonatomic) NSString *foodName;
@property (nonnull, nonatomic) NSString *foodDescription;
@property (nonnull, nonatomic) NSString *price;
@property (nonnull, nonatomic) NSURL *imgURL;

@property (nonnull, nonatomic) NSString *foodID;
@property (nonnull, nonatomic) NSArray *extraArr;

@end
