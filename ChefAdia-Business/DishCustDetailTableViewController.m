//
//  DishCustDetailTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/20.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "DishCustDetailTableViewController.h"
#import "DishDetailTableViewCell.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DishCustModifyTableViewController.h"

#define DELETE_CUST_DISH_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/delMMenu"

@interface DishCustDetailTableViewController ()

@end

@implementation DishCustDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *R1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                        target:self
                                                                        action:@selector(addAction:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:R1,nil];
    [self.navigationItem setTitle:self.name];
}

- (void)addAction:(id)sender{
    [self performSegueWithIdentifier:@"addCustSegue" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.foodArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"editCustSegue" sender:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
                                                                                    @"mmenu_foodid" : [self.foodArr[indexPath.row] valueForKey:@"foodid"],
                                                                                    };
                                                             
                                                             AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                                             manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                                                                  @"text/plain",
                                                                                                                  @"text/html",
                                                                                                                  nil];
                                                             [manager GET:DELETE_CUST_DISH_URL
                                                               parameters:dict
                                                                 progress:nil
                                                                  success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                                                                      NSDictionary *resultDict = (NSDictionary *)responseObject;
                                                                      if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                                                                          NSLog(@"delete dish success");
                                                                          
                                                                          [weakSelf.foodArr removeObjectAtIndex:indexPath.row];

                                                                          [weakSelf.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
                                                                                                                                                                          withRowAnimation:UITableViewRowAnimationAutomatic];
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = (NSIndexPath *)sender;

    if([segue.identifier isEqualToString:@"addCustSegue"]){
        DishCustModifyTableViewController *dishCustModifyTableViewController = [segue destinationViewController];
        
        [dishCustModifyTableViewController setIsEdit:NO];
        [dishCustModifyTableViewController setType:self.ID];
        [dishCustModifyTableViewController setTypeName:self.name];
    }else if([segue.identifier isEqualToString:@"editCustSegue"]){
        DishCustModifyTableViewController *dishCustModifyTableViewController = [segue destinationViewController];
        
        [dishCustModifyTableViewController setIsEdit:YES];
        [dishCustModifyTableViewController setType:self.ID];
        [dishCustModifyTableViewController setTypeName:self.name];
        
        [dishCustModifyTableViewController setFoodID:self.foodArr[path.row][@"foodid"]];
        [dishCustModifyTableViewController setFoodName:self.foodArr[path.row][@"name"]];
        [dishCustModifyTableViewController setPrice:[self.foodArr[path.row][@"price"] doubleValue]];
        [dishCustModifyTableViewController setImgURL:[NSURL URLWithString:self.foodArr[path.row][@"pic"]]];    }
}

@end
