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

@interface DishDetailTableViewController ()

@end

@implementation DishDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.foodArr = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadFood{
    
    NSLog(@"%d", self.ID);
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *tempDict = @{
                               @"menuid" : [NSString stringWithFormat:@"%d", self.ID],
                               };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:@"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/getList"
      parameters:tempDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 NSArray *resultArr = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *dict in resultArr){
                     [weakSelf.foodArr addObject:dict];
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
    [cell.priceLabel setText:[NSString stringWithFormat:@"%.2f", [[self.foodArr[indexPath.row] valueForKey:@"price"]doubleValue]]];
    [cell.goodLabel setText:[NSString stringWithFormat:@"%d", [[self.foodArr[indexPath.row] valueForKey:@"like"]intValue]]];
    [cell.badLabel setText:[NSString stringWithFormat:@"%d", [[self.foodArr[indexPath.row] valueForKey:@"dislike"]intValue]]];

    NSURL *imageUrl = [NSURL URLWithString:[self.foodArr[indexPath.row] valueForKey:@"picture"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    [cell.picView setImage:image];
    
    return cell;
}

@end
