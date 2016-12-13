//
//  DishDetailModifyExtraTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/13.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "DishDetailModifyExtraTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DishDetailTableViewCell.h"
#import "AFNetworking.h"

#define LIST_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/menu/getList"
#define EXTRA_ID @"5"

@interface DishDetailModifyExtraTableViewController ()

@end

@implementation DishDetailModifyExtraTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadExtras];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.extraDelegate passExtras:self.selectExtraArr];
}

- (void)loadExtras{
    
    self.foodArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *tempDict = @{
                               @"menuid" : EXTRA_ID,
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.foodArr count];
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
    
    NSString *foodid = [self.foodArr[indexPath.row] valueForKey:@"foodid"];
    
    if ([self.selectExtraArr containsObject:foodid]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *foodid = [self.foodArr[indexPath.row] valueForKey:@"foodid"];

    if(![self.selectExtraArr containsObject:foodid]){
        [self.selectExtraArr addObject:foodid];
    }else{
        [self.selectExtraArr removeObject:foodid];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationFade];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

@end
