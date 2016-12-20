//
//  DishCustModifyTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/20.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "DishCustModifyTableViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define UPLOAD_CUST_DISH_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/addMMenu"
#define MODIFY_CUST_DISH_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/modMMenu"
#define UPLOAD_CUST_IMAGE_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/uploadCustFoodPic"

@interface DishCustModifyTableViewController ()

@end

@implementation DishCustModifyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.typeIDLabel setText:self.typeName];
    
    [self.nameText setText:self.foodName];
    [self.priceText setText:[NSString stringWithFormat:@"%.2f", self.price]];
    [self.pictureView sd_setImageWithURL:self.imgURL];
}

- (void)addAction{
    NSLog(@"add cust");
    if([_nameText.text isEqualToString:@""]
       || [_pictureView.image isEqual:NULL]
       || [_priceText.text isEqualToString:@""]
       ){
        NSLog(@"NOT COMPLETE");
        return;
    }
    
    UIImage *image = [self.pictureView image];
    NSData *imageData = UIImagePNGRepresentation(image);
    if(imageData == nil){
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    
    NSDictionary *tempDict = @{
                               @"type" : [NSNumber numberWithInt:self.type],
                               @"name" : self.nameText.text,
                               @"price" : [NSNumber numberWithDouble:[[self.priceText text] doubleValue]],
                               };
    
    NSLog(@"%@", [tempDict description]);
    
    [manager POST:UPLOAD_CUST_DISH_URL
       parameters:tempDict
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
              NSDictionary *resultDict = (NSDictionary *)responseObject;
              if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                  
                  NSLog(@"%@", [[resultDict objectForKey:@"data"] description]);
                  [self uploadPic:[NSString stringWithFormat:@"%d", [[resultDict objectForKey:@"data"] intValue]]];
                  
                  NSLog(@"add cust dish success");
                  
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
       ){
        NSLog(@"NOT COMPLETE");
        return;
    }
    
    UIImage *image = [self.pictureView image];
    NSData *imageData = UIImagePNGRepresentation(image);
    if(imageData == nil){
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    
    NSDictionary *tempDict = @{
                               @"mmenu_foodid" : self.foodID,
                               @"type" : [NSNumber numberWithInt:self.type],
                               @"name" : self.nameText.text,
                               @"price" : [NSNumber numberWithDouble:[[self.priceText text] doubleValue]],
                               };
    
    NSLog(@"%@", [tempDict description]);
    
    [manager POST:MODIFY_CUST_DISH_URL
       parameters:tempDict
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
              NSDictionary *resultDict = (NSDictionary *)responseObject;
              if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                  
                  [self uploadPic: self.foodID];
                  
                  NSLog(@"modify cust dish success");
                  
              }else{
                  NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
          }];
    
}

- (void)uploadPic:(NSString *)foodid{
    UIImage *image = [self.pictureView image];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSDictionary *dict = @{
                           @"foodid" : foodid,
                           @"pic" : @"pic.jpeg",
                           };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
    [hud.label setText: @"Uploading"];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         @"text/json",
                                                         @"application/json",
                                                         nil];
    
    [manager POST:UPLOAD_CUST_IMAGE_URL
       parameters:dict
     
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:imageData name:@"pic" fileName:@"pic.jpeg" mimeType:@"image/jpeg"];
} progress:^(NSProgress * _Nonnull uploadProgress) {
    [hud setProgressObject:uploadProgress];
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    NSLog(@"UPLOAD FOOD PIC SUCCESS");
    
    [hud hideAnimated:YES];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    NSLog(@"FAILED");
    NSLog(@"%@", [error description]);
}];
    
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
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 1;
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 3) {
        [self modifyPic];
    }else if(indexPath.section == 1){
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

@end
