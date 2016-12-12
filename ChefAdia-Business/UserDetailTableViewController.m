//
//  UserDetailTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/7.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "UserDetailTableViewController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define CHANGE_BOWL_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/setBowl"

@interface UserDetailTableViewController ()

@end

@implementation UserDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadUserDetail];
}

- (void)loadUserDetail{
    
    [self.idLabel setText:[self.userInfo objectForKey:@"userid"]];
    [[self nameLabel] setText:[self.userInfo objectForKey:@"username"]];
    //NSURL *imageUrl = [NSURL URLWithString:[[self.userInfo valueForKey:@"avatar"] stringByReplacingOccurrencesOfString:@"/data/wwwroot/default/images/" withString:@"http://139.196.179.145/images/"]];
    NSURL *imageUrl = [NSURL URLWithString:[self.userInfo valueForKey:@"avatar"]];
    [self.avatarImg sd_setImageWithURL:imageUrl];
    
    NSDictionary *subInfo = [self.userInfo objectForKey:@"extra"];
    
    int i = [[subInfo objectForKey:@"bowl"] intValue];
    if(i == 0){
        [[self bowlLabel] setText:@"Not Returned"];
        [self.changeBowlButton setTitle:@"Set Returned" forState:UIControlStateNormal];
    }else if(i == 1){
        [[self bowlLabel] setText:@"Returned"];
        [self.changeBowlButton setTitle:@"Set Not Returned" forState:UIControlStateNormal];
    }
    
    NSString *ticket = [subInfo objectForKey:@"tick"];
    if(ticket != NULL){
        [[self ticketLabel] setText:ticket];
    }else{
        [[self ticketLabel] setText:@"Not Set"];
    }
    
    NSString *addr = [subInfo objectForKey:@"addr"];
    if(![addr isEqualToString:@""]){
        [[self addressLabel] setText:addr];
    }else{
        [[self addressLabel] setText:@"Not Set"];
    }
    
    NSString *phone = [subInfo objectForKey:@"phone"];
    if(![phone isEqualToString:@""]){
        [[self phoneLabel] setText:phone];
    }else{
        [[self phoneLabel] setText:@"Not Set"];
    }
    
    double money = [[subInfo objectForKey:@"price"] doubleValue];
    [[self moneyLabel] setText:[NSString stringWithFormat:@"$%.2f", money]];
    
    [self.tableView reloadData];
}

- (IBAction)changeBowlAction:(id)sender{
    
    NSNumber *state;
    if([[self.bowlLabel text] isEqualToString:@"Returned"]) {
        state = [NSNumber numberWithInt:0];
    }else{
        state = [NSNumber numberWithInt:1];
    }
    
    NSDictionary *getDict = @{
                              @"userid" : [self.idLabel text],
                              @"state" : state,
                              };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:CHANGE_BOWL_URL
      parameters:getDict
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 
                 if([state intValue] == 0){
                     [[self bowlLabel] setText:@"Not Returned"];
                     [self.changeBowlButton setTitle:@"Set Returned" forState:UIControlStateNormal];
                 }else if([state intValue] == 1){
                     [[self bowlLabel] setText:@"Returned"];
                     [self.changeBowlButton setTitle:@"Set Not Returned" forState:UIControlStateNormal];
                 }
                 
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
