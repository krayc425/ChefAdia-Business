//
//  DishAddTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/10.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "DishAddTableViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#define UPLOAD_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/addType"

@interface DishAddTableViewController ()

@end

@implementation DishAddTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)uploadAction{
    
    if([_nameText.text isEqualToString:@""] || [_pictureView.image isEqual:NULL]){
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
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
                               @"name" : self.nameText.text,
                               @"pic" : @"pic.jpeg",
                               };
    
    [manager POST:UPLOAD_URL
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
                 
                 NSLog(@"add type success");
                 
                 [hud hideAnimated:YES];
                 
                 UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Upload Success"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action){
                                                                      [self.navigationController popViewControllerAnimated:YES];
                                                                  }];
                 [alertC addAction:okAction];
                 [self presentViewController:alertC animated:YES completion:nil];
                 
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
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
            return 2;
        case 1:
            return 1;
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 1){
        [self modifyPic];
    }else if(indexPath.section == 1 && indexPath.row == 0){
        [self uploadAction];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.pictureView setImage:image];
}

@end
