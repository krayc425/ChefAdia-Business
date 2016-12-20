//
//  OrderTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/12.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "OrderTableViewController.h"
#import "OrderTableViewCell.h"
#import "AFNetworking.h"
#import "OrderDetailTableViewController.h"

#define ORDER_LIST_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/getOrderList"
#define CUST_ORDER_LIST_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/getCustOrderList"

@interface OrderTableViewController ()

@end

@implementation OrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dateText = [[UITextField alloc] initWithFrame:CGRectMake(0,
                                                              self.view.frame.size.height - 260,
                                                              self.view.frame.size.width,
                                                              260)];
    self.selectDate = [NSDate date];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadOrder];
}

- (void)loadOrder{
    self.orderArr = [[NSMutableArray alloc] init];
    
//    __weak typeof(self) weakSelf = self;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    [self.dateLabel setText:[fmt stringFromDate:self.selectDate]];
    
    fmt.dateFormat = @"yyyyMMdd";
    
    NSDictionary *getDict = @{
                              @"date" : [fmt stringFromDate:self.selectDate],
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:ORDER_LIST_URL
      parameters:getDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 NSArray *resultArr = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *subResultDict in resultArr){
                     if([subResultDict[@"iscust"] intValue] == 0){
                         [self.orderArr addObject:subResultDict];
                     }
                 }
                 
                 [self loadCustOrder];
                 
             }else{
                 NSLog(@"Order Error, MSG: %@", [resultDict objectForKey:@"msg"]);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];
}

- (void)loadCustOrder{
    self.custOrderArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"yyyy-MM-dd";
    
//    fmt.dateFormat = @"yyyyMMdd";
    
    NSDictionary *getDict = @{
                              @"date" : [fmt stringFromDate:self.selectDate],
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:CUST_ORDER_LIST_URL
      parameters:getDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 NSArray *resultArr = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *subResultDict in resultArr){
                     [self.custOrderArr addObject:subResultDict];
                 }
                 
                 [weakSelf.tableView reloadData];
             }else{
                 NSLog(@"Cust Order Error, MSG: %@", [resultDict objectForKey:@"msg"]);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
         }];

}

- (void)showDatePicker{
    [self.view addSubview:_dateText];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    datePicker.date = self.selectDate;
    
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    _dateText.inputView = datePicker;
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barTintColor = [UIColor lightGrayColor];
    toolbar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35);
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"DONE" style:UIBarButtonItemStylePlain target:self action:@selector(click:)];
    
    toolbar.items = @[item0, item1];
    
    _dateText.inputAccessoryView = toolbar;
    [_dateText becomeFirstResponder];
}

- (void)dateChange:(UIDatePicker *)sender{
    self.selectDate = sender.date;
}

-(void)click:(UIButton *)sender{
    [_dateText resignFirstResponder];
    [_dateText removeFromSuperview];
    [self loadOrder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 1:
            return [self.orderArr count];
        case 2:
            return [self.custOrderArr count];
        default:
            return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 || indexPath.section == 2){
        static NSString *CellIdentifier = @"OrderTableViewCell";
        UINib *nib = [UINib nibWithNibName:@"OrderTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell" forIndexPath:indexPath];
        
        NSDictionary *orderDict;
        if(indexPath.section == 1){
            orderDict = self.orderArr[indexPath.row];
        }else if(indexPath.section == 2){
            orderDict = self.custOrderArr[indexPath.row];
        }
        
        [cell.userNameLabel setText:[NSString stringWithFormat:@"User : %@", [orderDict objectForKey:@"username"]]];
        [cell.timeLabel setText:[orderDict objectForKey:@"time"]];
        [cell.addressLabel setText:[NSString stringWithFormat:@"Addr : %@", [orderDict objectForKey:@"addr"]]];
        [cell.orderIDLabel setText:[NSString stringWithFormat:@"Order ID : %@", [orderDict objectForKey:@"orderid"]]];
        [cell.priceLabel setText:[NSString stringWithFormat:@"$%.2f", [[orderDict objectForKey:@"price"] doubleValue]]];
        if([[orderDict objectForKey:@"isfinish"] intValue] == 0){
            [cell.isFinishedLabel setText:@"Not Finished"];
            [cell.isFinishedLabel setTextColor:[UIColor redColor]];
        }else{
            [cell.isFinishedLabel setText:@"Finished"];
            [cell.isFinishedLabel setTextColor:[UIColor greenColor]];
        }
        
        if([[orderDict objectForKey:@"type"] intValue] == 0){
            [cell.typeLabel setText:@"Cash"];
        }else if([[orderDict objectForKey:@"type"] intValue] == 1){
            [cell.typeLabel setText:@"Visa"];
        }
        
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        [self showDatePicker];
    }else{
        [self performSegueWithIdentifier:@"detailSegue" sender:indexPath];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    OrderDetailTableViewController *orderDetailTableViewController = (OrderDetailTableViewController *)[segue destinationViewController];
    
    NSIndexPath *path = (NSIndexPath *)sender;
    if(path.section == 1){
        [orderDetailTableViewController setIsCust:NO];
        
        [orderDetailTableViewController setOrderID:[self.orderArr[path.row] objectForKey:@"orderid"]];
    }else if(path.section == 2){
        [orderDetailTableViewController setIsCust:YES];
        
        [orderDetailTableViewController setOrderID:[self.custOrderArr[path.row] objectForKey:@"orderid"]];
    }
}

@end
