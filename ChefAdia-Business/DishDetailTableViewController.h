//
//  DishDetailTableViewController.h
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishDetailTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonnull, nonatomic) IBOutlet UINavigationItem *naviItem;

@property (nonnull, nonatomic) UIImagePickerController* picker_library_;

@property (nonnull, nonatomic) IBOutlet UITextField *nameText;
@property (nonnull, nonatomic) IBOutlet UIImageView *pictureView;

@property (nonatomic) int ID;
@property (nonnull, nonatomic) NSString *name;
@property (nonnull, nonatomic) NSString *imgURL;

@property (nonnull, nonatomic) NSMutableArray *foodArr;

@property (nonatomic) int foodNum;

- (void)loadFood;

@end
