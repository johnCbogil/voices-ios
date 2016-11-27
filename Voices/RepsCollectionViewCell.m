//
//  RepsCollectionViewCell.m
//  Voices
//
//  Created by John Bogil on 11/12/16.
//  Copyright © 2016 John Bogil. All rights reserved.
//

#import "RepsCollectionViewCell.h"
#import "RepTableViewCell.h"
#import "EmptyRepTableViewCell.h"
#import "RepDetailViewController.h"
#import "RepsManager.h"
#import "LocationService.h"

@interface RepsCollectionViewCell()

@property (strong, nonatomic) EmptyRepTableViewCell *emptyRepTableViewCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation RepsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:kRepTableViewCell bundle:nil]forCellReuseIdentifier:kRepTableViewCell];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelection = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.bounds = CGRectMake(self.refreshControl.bounds.origin.x,
                                       15,
                                       self.refreshControl.bounds.size.width,
                                       self.refreshControl.bounds.size.height);

    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    self.emptyRepTableViewCell = [[EmptyRepTableViewCell alloc]init];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.tableViewDataSource.count > 0){
        return self.tableViewDataSource.count;
    } else{
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell;
    if(self.tableViewDataSource.count > 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:kRepTableViewCell];
        
        [cell initWithRep:self.tableViewDataSource[indexPath.row]];
    }
    else {
        UITableViewCell *emptyStateCell = [[UITableViewCell alloc]init];
        emptyStateCell.backgroundView = self.emptyRepTableViewCell;
        cell = emptyStateCell;
    }
    [self.refreshControl endRefreshing];
    [self toggleZeroState];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableViewDataSource.count > 0) {
        return 140;
    }
    else {
        return 400;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // CREATE DETAIL VIEW
    RepDetailViewController *repDetailVC = [[RepDetailViewController alloc]init];
    // ASSIGN REP TO DETAIL VIEW
    repDetailVC.representative = self.tableViewDataSource[indexPath.row];
    // TODO: PUSH TO DETAIL VIEW
    
}

- (void)reloadTableView {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)pullToRefresh {
    [[LocationService sharedInstance]startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSearchText" object:nil];
}

- (void)endRefreshing {
    [self.refreshControl endRefreshing];
}

#pragma mark - ZeroState Logic

- (void)toggleZeroState {
    if (self.tableViewDataSource.count == 0) {
        [self turnZeroStateOn];
    }
    else {
        [self turnZeroStateOff];
    }
}

- (void)turnZeroStateOn {
    [UIView animateWithDuration:.25 animations:^{
        self.tableView.backgroundView.alpha = 1;
    }];
    if (self.index == 2 && ![RepsManager sharedInstance].isLocalRepsAvailable) {
        [self.emptyRepTableViewCell updateLabels:kLocalRepsMissing bottom:@""];
        [self.emptyRepTableViewCell updateImage];
    }
}

- (void)turnZeroStateOff {
    [UIView animateWithDuration:.25 animations:^{
        self.tableView.backgroundView.alpha = 0;
    }];
}

@end