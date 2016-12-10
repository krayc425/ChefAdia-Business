
//
//  UserTableViewController.m
//  ChefAdia-Business
//
//  Created by 宋 奎熹 on 2016/12/7.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "UserTableViewController.h"
#import "AFNetworking.h"
#import "UserTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserDetailTableViewController.h"

#define USERLIST_URL @"http://139.196.179.145/ChefAdia-1.0-SNAPSHOT/shop/getUserList"

@interface UserTableViewController ()

@end

@implementation UserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userArr = [[NSMutableArray alloc] init];
    [self loadUser];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    [self.searchController.searchBar sizeToFit];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

- (void)loadUser{
    self.userArr = [[NSMutableArray alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"text/plain",
                                                         @"text/html",
                                                         nil];
    [manager GET:USERLIST_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
             NSLog(@"SUCCESS");
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             if([[resultDict objectForKey:@"condition"] isEqualToString:@"success"]){
                 NSArray *resultArr = (NSArray *)[resultDict objectForKey:@"data"];
                 for(NSDictionary *dict in resultArr){
                     [weakSelf.userArr addObject: dict];
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

#pragma mark - searchController delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self.filteredUserArr removeAllObjects];
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF['username'] CONTAINS[c] %@", self.searchController.searchBar.text];
    self.filteredUserArr = [[self.userArr filteredArrayUsingPredicate:searchPredicate] mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchController.active){
        return [self.filteredUserArr count];
    }else{
        return [self.userArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserTableViewCell";
    UINib *nib = [UINib nibWithNibName:@"UserTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTableViewCell" forIndexPath:indexPath];
    
    if(!self.searchController.active){
        [cell.nameLabel setText:[self.userArr[indexPath.row] valueForKey:@"username"]];
        NSURL *imageUrl = [NSURL URLWithString:[[self.userArr[indexPath.row] valueForKey:@"avatar"] stringByReplacingOccurrencesOfString:@"/data/wwwroot/default/images/" withString:@"http://139.196.179.145/images/"]];
        [cell.avatarView sd_setImageWithURL:imageUrl];
    }else{
        [cell.nameLabel setText:[self.filteredUserArr[indexPath.row] valueForKey:@"username"]];
        NSURL *imageUrl = [NSURL URLWithString:[[self.filteredUserArr[indexPath.row] valueForKey:@"avatar"] stringByReplacingOccurrencesOfString:@"/data/wwwroot/default/images/" withString:@"http://139.196.179.145/images/"]];
        [cell.avatarView sd_setImageWithURL:imageUrl];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"detailSegue" sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    UserDetailTableViewController *userDetailTableViewController = (UserDetailTableViewController *)[segue destinationViewController];
    [userDetailTableViewController setTitle:[_userArr[indexPath.row] objectForKey:@"username"]];
    
    NSDictionary *infoDict = _userArr[indexPath.row];
    [userDetailTableViewController setUserInfo:infoDict];
}

@end
