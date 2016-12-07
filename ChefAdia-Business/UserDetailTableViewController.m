//
//  UserDetailTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/7.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "UserDetailTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UserDetailTableViewController ()

@end

@implementation UserDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.idLabel setText:[self.userInfo objectForKey:@"userid"]];
    [[self nameLabel] setText:[self.userInfo objectForKey:@"username"]];
    NSURL *imageUrl = [NSURL URLWithString:[[self.userInfo valueForKey:@"avatar"] stringByReplacingOccurrencesOfString:@"/data/wwwroot/default/images/" withString:@"http://139.196.179.145/images/"]];
    [self.avatarImg sd_setImageWithURL:imageUrl];
    
    NSDictionary *subInfo = [self.userInfo objectForKey:@"extra"];
    
    int i = [[subInfo objectForKey:@"bowl"] intValue];
    if(i == 0){
        [[self bowlLabel] setText:@"NOT RETURNED"];
    }else if(i == 1){
        [[self bowlLabel] setText:@"RETURNED"];
    }
    
    NSString *ticket = [subInfo objectForKey:@"tick"];
    if(ticket != NULL){
        [[self ticketLabel] setText:ticket];
    }else{
        [[self ticketLabel] setText:@"NOT SET"];
    }
    
    NSString *addr = [subInfo objectForKey:@"addr"];
    if(addr != NULL){
        [[self addressLabel] setText:addr];
    }else{
        [[self addressLabel] setText:@"NOT SET"];
    }
    
    NSString *phone = [subInfo objectForKey:@"phone"];
    if(phone != NULL){
        [[self phoneLabel] setText:phone];
    }else{
        [[self phoneLabel] setText:@"NOT SET"];
    }
    
    double money = [[subInfo objectForKey:@"price"] doubleValue];
    [[self moneyLabel] setText:[NSString stringWithFormat:@"%.2f", money]];
    
    [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 5;
        default:
            return 0;
    }
}

@end
