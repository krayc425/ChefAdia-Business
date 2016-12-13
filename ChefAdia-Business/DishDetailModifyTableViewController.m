
//
//  DishDetailAddTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/12.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "DishDetailModifyTableViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define UPLOAD_DISH_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/addFood"
#define MODIFY_DISH_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/modFood"

@interface DishDetailModifyTableViewController ()

@end

@implementation DishDetailModifyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extraArr = [[NSMutableArray alloc] init];
    
    [self.typeIDLabel setText:self.typeName];
    [self.nameText setText:self.foodName];
    [self.priceText setText:self.price];
    
    [self.pictureView sd_setImageWithURL:self.imgURL];
    [self.extraNumLabel setText:@""];
}

- (void)addAction{
    if([_nameText.text isEqualToString:@""]
       || [_pictureView.image isEqual:NULL]
       || [_priceText.text isEqualToString:@""]
       //|| [_descriptionText.text isEqualToString:@""]
       ){
        NSLog(@"NOT COMPLETE");
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    UIImage *image = [self.pictureView image];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
    [hud.label setText: @"Uploading"];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    NSDictionary *tempDict = @{
                               @"foodid" : self.foodID,
                               @"pic" : @"pic.jpeg",
                               @"price" : [NSNumber numberWithDouble:[[self.priceText text] doubleValue]],
                               //@"description" : self.descriptionText.text,
                               @"extra" : self.extraArr,
                               };
    
    //NSLog(@"%@", [tempDict description]);
    
    [manager POST:MODIFY_DISH_URL
       parameters:tempDict
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:imageData name:@"pic" fileName:@"pic.jpeg" mimeType:@"image/jpeg"];
}
         progress:^(NSProgress * _Nonnull uploadProgress) {
             [hud setProgressObject:uploadProgress];
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
              NSDictionary *resultDict = (NSDictionary *)responseObject;
              if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                  
                  NSLog(@"modify dish success");
                  
                  [hud hideAnimated:YES];
                  
                  [self.navigationController popViewControllerAnimated:YES];
                  
              }else{
                  NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
          }];
}

- (void)editAction{
    if([_nameText.text isEqualToString:@""]
       || [_pictureView.image isEqual:NULL]
       || [_priceText.text isEqualToString:@""]
       //|| [_descriptionText.text isEqualToString:@""]
       ){
        NSLog(@"NOT COMPLETE");
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         @"text/json",
                                                         @"application/json",
                                                         nil];
    UIImage *image = [self.pictureView image];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
    [hud.label setText: @"Uploading"];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    NSDictionary *tempDict = @{
                               @"name" : self.nameText.text,
                               @"pic" : @"pic.jpeg",
                               @"typeid" : self.typeID,
                               @"price" : [NSNumber numberWithDouble:[[self.priceText text] doubleValue]],
                               @"description" : self.descriptionText.text,
                               @"extra" : self.extraArr,
                               };
    
    //NSLog(@"%@", [tempDict description]);
    
    [manager POST:UPLOAD_DISH_URL
       parameters:tempDict
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:imageData name:@"pic" fileName:@"pic.jpeg" mimeType:@"image/jpeg"];
}
         progress:^(NSProgress * _Nonnull uploadProgress) {
             [hud setProgressObject:uploadProgress];
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
              NSDictionary *resultDict = (NSDictionary *)responseObject;
              if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                  
                  NSLog(@"add dish success");
                  
                  [hud hideAnimated:YES];
                  
                  [self.navigationController popViewControllerAnimated:YES];
                  
              }else{
                  NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
          }];

}

- (void)passExtras:(NSArray *)arr{
    self.extraArr = arr;
    NSLog(@"%@", [self.extraArr description]);
    if([self.extraArr count] != 0){
        [self.extraNumLabel setText:[NSString stringWithFormat:@"%lu items", [self.extraArr count]]];
    }else{
        [self.extraNumLabel setText:@""];
    }
}

- (void)modifyPic{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Pick a Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                             imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                                                             [self presentViewController:imagePickerController animated:YES completion:nil];
                                                         }];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"Choose from Photo Library"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                             [self presentViewController:imagePickerController animated:YES completion:nil];
                                                         }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [alert addAction:cameraAction];
    }
    
    [alert addAction:photosAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        if([_typeIDLabel.text isEqualToString:@"extra"]){
            return 5;
        }else{
            return 6;
        }
    }else if(section == 1){
        return 1;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 4){
        [self modifyPic];
    }else if(indexPath.section == 1 && indexPath.row == 0){
        if(self.isEdit){
            [self editAction];
        }else{
            [self addAction];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.pictureView setImage:image];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"extraSegue"]){
        DishDetailModifyExtraTableViewController *dishDetailModifyExtraTableViewController = (DishDetailModifyExtraTableViewController *)[segue destinationViewController];
        dishDetailModifyExtraTableViewController.extraDelegate = self;
        [dishDetailModifyExtraTableViewController setSelectExtraArr:[NSMutableArray arrayWithArray:self.extraArr]];
    }
}

@end
