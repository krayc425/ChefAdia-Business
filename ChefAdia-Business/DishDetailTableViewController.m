//
//  DishDetailTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "DishDetailTableViewController.h"
#import "DishDetailTableViewCell.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "DishDetailModifyTableViewController.h"
#import "DishDetailModifyExtraTableViewController.h"

#define LIST_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/menu/getList"
#define MODIFY_MENU_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/modType"
#define DELETE_DISH_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/deleteFood"

@interface DishDetailTableViewController ()

@end

@implementation DishDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *R1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                        target:self
                                                                        action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:R1,nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadMenuInfo];
    [self loadFood];
}

- (void)loadMenuInfo{
    [self.navigationItem setTitle:self.name];
    [self.nameText setText:self.name];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:_imgURL]];
}

- (void)loadFood{
    
    self.foodArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *tempDict = @{
                               @"menuid" : [NSString stringWithFormat:@"%d", self.ID],
                               };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:LIST_URL
      parameters:tempDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){

                 NSDictionary *subResultDict = (NSDictionary *)[resultDict objectForKey:@"data"];
                 
                 _foodNum = [[subResultDict objectForKey:@"num"] intValue];
                 
                 for(NSDictionary *Dict in (NSArray *)[subResultDict objectForKey:@"list"]){
                     [_foodArr addObject:Dict];
                 }
                 
                 [weakSelf.tableView reloadData];
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];

}

- (void)uploadAction{
    
    if([_nameText.text isEqualToString:@""]){
        return;
    }
    UIImage *image = [self.pictureView image];
    NSData *imageData = UIImagePNGRepresentation(image);
    if(imageData == nil){
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
    [hud.label setText: @"Uploading"];
    [hud setRemoveFromSuperViewOnHide:YES];
    
    NSDictionary *tempDict = @{
                               @"typeid" : [NSString stringWithFormat:@"%d", self.ID],
                               @"name" : self.nameText.text,
                               @"pic" : @"pic.jpeg",
                               };
    
    [manager POST:MODIFY_MENU_URL
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
                  
                  NSLog(@"modify success");
                  
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

- (void)addAction:(id)sender{
    [self performSegueWithIdentifier:@"addDishSegue" sender:nil];
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
        case 1:
            return [self.foodArr count];
        default:
            return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 10;
    }else{
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 1){
        [self modifyPic];
    }else if(indexPath.section == 0 && indexPath.row == 2){
        [self uploadAction];
    }else if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"editDishSegue" sender:indexPath];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        static NSString *CellIdentifier = @"DishDetailTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"DishDetailTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        DishDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DishDetailTableViewCell" forIndexPath:indexPath];
        
        [cell.nameLabel setText:[self.foodArr[indexPath.row] valueForKey:@"name"]];
        [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[self.foodArr[indexPath.row] valueForKey:@"price"]doubleValue]]];
        [cell.goodLabel setText:[NSString stringWithFormat:@"%d", [[self.foodArr[indexPath.row] valueForKey:@"good_num"]intValue]]];
        [cell.badLabel setText:[NSString stringWithFormat:@"%d", [[self.foodArr[indexPath.row] valueForKey:@"bad_num"]intValue]]];

        NSURL *imageUrl = [NSURL URLWithString:[self.foodArr[indexPath.row] valueForKey:@"pic"]];
        [cell.picView sd_setImageWithURL:imageUrl];
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Sure to delete?"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Delete"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action){
                                                             
                                                             __weak typeof(self) weakSelf = self;
                                                             
                                                             NSDictionary *dict = @{
                                                                                    @"foodid" : [self.foodArr[indexPath.row] valueForKey:@"foodid"],
                                                                                    };
                                                             
                                                             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                                             manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                                                                  @"text/plain",
                                                                                                                  @"text/html",
                                                                                                                  nil];
                                                             [manager GET:DELETE_DISH_URL
                                                               parameters:dict
                                                                 progress:nil
                                                                  success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                                                                      NSDictionary *resultDict = (NSDictionary *)responseObject;
                                                                      if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                                                                          NSLog(@"delete dish success");
                                                                          
                                                                          [weakSelf loadFood];
                                                                          //                                                                          [weakSelf.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                                                                          //                                                                                                    withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                          [weakSelf.tableView reloadData];
                                                                      }else{
                                                                          NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
                                                                      }
                                                                  }
                                                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                                      NSLog(@"%@",error);
                                                                  }];
                                                             
                                                         }];
        [alertC addAction:cancelAction];
        [alertC addAction:okAction];
        [self presentViewController:alertC animated:YES completion:nil];
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
    if([segue.identifier isEqualToString:@"addDishSegue"]){
        DishDetailModifyTableViewController *dishDetailModifyTableViewController = (DishDetailModifyTableViewController *)[segue destinationViewController];
        
        [dishDetailModifyTableViewController setIsEdit:false];
        
        [dishDetailModifyTableViewController setTypeName:self.name];
        [dishDetailModifyTableViewController setTypeID:[NSString stringWithFormat:@"%d", self.ID]];
    }else if([segue.identifier isEqualToString:@"editDishSegue"]){
        DishDetailModifyTableViewController *dishDetailModifyTableViewController = (DishDetailModifyTableViewController *)[segue destinationViewController];
        
        [dishDetailModifyTableViewController setIsEdit:true];

        [dishDetailModifyTableViewController setTypeID:[NSString stringWithFormat:@"%d", self.ID]];
        [dishDetailModifyTableViewController setTypeName:self.name];
        
        NSIndexPath *path = (NSIndexPath *)sender;
        
        int i = (int)path.row;
        
        [dishDetailModifyTableViewController setFoodID:[self.foodArr[i] valueForKey:@"foodid"]];
        [dishDetailModifyTableViewController setFoodName:[self.foodArr[i] valueForKey:@"name"]];
        [dishDetailModifyTableViewController setPrice:[NSString stringWithFormat:@"%.2f", [[self.foodArr[i] valueForKey:@"price"] doubleValue]]];
        [dishDetailModifyTableViewController setImgURL:[NSURL URLWithString:[self.foodArr[i] valueForKey:@"pic"]]];
        
        NSMutableArray *selectIDs = [[NSMutableArray alloc] init];
        for(NSDictionary *d in [self.foodArr[i] valueForKey:@"extraFood"]){
            [selectIDs addObject:[d objectForKey:@"foodid"]];
        }
        
        [dishDetailModifyTableViewController setExtraArr:[selectIDs mutableCopy]];
    }
}


@end
