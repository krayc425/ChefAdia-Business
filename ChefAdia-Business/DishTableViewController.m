//
//  DishTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/5.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "DishTableViewController.h"
#import "AFNetworking.h"
#import "DishTableViewCell.h"
#import "DishDetailTableViewController.h"
#import "DishCustDetailTableViewController.h"
#import "CAMenuData.h"

#define MENU_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/menu/getMenu"
#define DELETE_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/shop/deleteType"
#define MMENU_FOOD_URL @"http://47.89.194.197:8081/ChefAdia-1.0-SNAPSHOT/user/getMMenuInfo"

@interface DishTableViewController ()

@end

@implementation DishTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadMenu];
}

- (void)loadMenu{
    self.typeArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:MENU_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 NSArray *resultArr = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *dict in resultArr){
                     [weakSelf.typeArr addObject: dict];
                 }
                 
                 [self loadMFood];
//                 [weakSelf.tableView reloadData];
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"msg"]);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];
}


- (void)loadMFood{
    self.typeFoodArr = [[NSMutableArray alloc] init];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:MMENU_FOOD_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 NSArray *resultArr = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *dict in resultArr){
                     [self.typeFoodArr addObject:dict];
                 }
                 
                 [self.tableView reloadData];
                 
             }else{
                 NSLog(@"Error, MSG: %@", [resultDict objectForKey:@"message"]);
             }
             
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];
}

- (void)addAction:(id)sender{
    [self performSegueWithIdentifier:@"addTypeSegue" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.typeArr count];
        case 1:
            return [[CAMenuData getNameList] count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DishTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"DishTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    DishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DishTableViewCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0){
        [cell.nameLabel setText:[self.typeArr[indexPath.row] valueForKey:@"name"]];
        [cell.numLabel setText:[NSString stringWithFormat:@"%d selections", [[self.typeArr[indexPath.row] valueForKey:@"num"] intValue]]];
    }else{
        [cell.nameLabel setText:[CAMenuData getNameList][indexPath.row]];
        int count = 0;
        for(NSDictionary *d in self.typeFoodArr){
            if([d[@"type"] intValue] - 1 == indexPath.row){
                count++;
            }
        }
        [cell.numLabel setText:[NSString stringWithFormat:@"%d selections", count]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        [self performSegueWithIdentifier:@"detailSegue" sender:indexPath];
    }else{
        [self performSegueWithIdentifier:@"detailCustSegue" sender:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
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
                                                                                    @"typeid" : [self.typeArr[indexPath.row] valueForKey:@"menuid"],
                                                                                    };
                                                             
                                                             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                                             manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                                                                  @"text/plain",
                                                                                                                  @"text/html",
                                                                                                                  nil];
                                                             [manager GET:DELETE_URL
                                                               parameters:dict
                                                                 progress:nil
                                                                  success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                                                                      NSDictionary *resultDict = (NSDictionary *)responseObject;
                                                                      if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                                                                          NSLog(@"delete success");
                                                                          
                                                                          [weakSelf loadMenu];
                                                                          
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"  Normal";
    }else if(section == 1){
        return @"  Custom";
    }else{
        return @"";
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = (NSIndexPath *)sender;
    if([segue.identifier isEqualToString:@"detailSegue"]){
        DishDetailTableViewController *dishDetailTableViewController = [segue destinationViewController];
        
        [dishDetailTableViewController setName:[self.typeArr[path.row] objectForKey:@"name"]];
        [dishDetailTableViewController setID:[[self.typeArr[path.row] objectForKey:@"menuid"] intValue]];
        [dishDetailTableViewController setImgURL:[self.typeArr[path.row] objectForKey:@"pic"]];
    }else if([segue.identifier isEqualToString:@"detailCustSegue"]){
        DishCustDetailTableViewController *dishCustDetailTableViewController = [segue destinationViewController];
        
        [dishCustDetailTableViewController setID:(int)path.row+1];
        [dishCustDetailTableViewController setName:[CAMenuData getNameList][path.row]];
        NSMutableArray *foodArr = [[NSMutableArray alloc] init];
        for(NSDictionary *d in self.typeFoodArr){
            if([d[@"type"] intValue] - 1 == path.row){
                [foodArr addObject:d];
            }
        }
        [dishCustDetailTableViewController setFoodArr:foodArr];

    }
}

@end
