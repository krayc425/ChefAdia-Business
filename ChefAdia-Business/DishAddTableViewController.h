//
//  DishAddTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/10.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishAddTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonnull, nonatomic) UIImagePickerController* picker_library_;

@property (nonnull, nonatomic) IBOutlet UITextField *nameText;
@property (nonnull, nonatomic) IBOutlet UIImageView *pictureView;

@end
