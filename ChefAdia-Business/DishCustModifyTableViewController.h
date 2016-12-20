//
//  DishCustModifyTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/20.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishCustModifyTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonnull, nonatomic) UIImagePickerController* picker_library_;

@property (nonatomic) BOOL isEdit;
@property (nonatomic) int type;
@property (nonatomic, nonnull) NSString *typeName;
@property (nonnull, nonatomic) NSString *foodID;

@property (nonatomic, nonnull) NSString *foodName;
@property (nonatomic) double price;
@property (nonnull, nonatomic) NSURL *imgURL;

@property (nonnull, nonatomic) IBOutlet UILabel *typeIDLabel;
@property (nonnull, nonatomic) IBOutlet UITextField *nameText;
@property (nonnull, nonatomic) IBOutlet UITextField *priceText;
@property (nonnull, nonatomic) IBOutlet UIImageView *pictureView;

@end
