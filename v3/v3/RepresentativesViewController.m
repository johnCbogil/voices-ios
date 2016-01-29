//
//  RepresentativesViewController.m
//  Voices
//
//  Created by Bogil, John on 1/22/16.
//  Copyright © 2016 John Bogil. All rights reserved.
//

#import "RepresentativesViewController.h"
#import "CongresspersonTableViewCell.h"
#import "StateRepTableViewCell.h"
#import "NYCRepresentativeTableViewCell.h"
#import "RepManager.h"
#import "LocationService.h"
#import "CacheManager.h"
#import "NetworkManager.h"

@interface RepresentativesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *zeroStateContainer;
@property (strong, nonatomic) NSString *tableViewCellName;
@property (strong, nonatomic) NSString *cachedRepresentatives;
@property (strong, nonatomic) NSArray *tableViewDataSource;
@property (strong, nonatomic) NSString *getRepresentativesMethod;
@end

@implementation RepresentativesViewController

- (void)viewWillAppear:(BOOL)animated {
    //[self setDataSources];
    [self addObservers];
    [self checkCache];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDataSources];
    [self createTableView];
    [self checkLocationAuthorizationStatus];
    [self createRefreshControl];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[LocationService sharedInstance]removeObserver:self forKeyPath:@"currentLocation" context:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnZeroStateOn) name:@"turnZeroStateOn" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(turnZeroStateOff) name:@"turnZeroStateOff" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endRefreshing) name:@"endRefreshing" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView) name:@"reloadData" object:nil];
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setDataSources {
    if (self.index == 0) {
        self.tableViewCellName = @"CongresspersonTableViewCell";
        self.cachedRepresentatives = @"cachedCongresspersons";
        self.tableViewDataSource = [RepManager sharedInstance].listOfCongressmen;
        self.getRepresentativesMethod = @"createCongressmen";
    }
    else if (self.index == 1) {
        self.tableViewCellName = @"StateRepTableViewCell";
        self.cachedRepresentatives = @"cachedStateLegislators";
        self.tableViewDataSource = [RepManager sharedInstance].listOfStateLegislators;
        self.getRepresentativesMethod = @"createStateLegislators";
    }
    else if (self.index == 2) {
        self.tableViewCellName = @"NYCRepresentativeTableViewCell";
        self.cachedRepresentatives = @"cachedNYCRepresentatives";
        self.tableViewDataSource = [RepManager sharedInstance].listOfNYCRepresentatives;
        self.getRepresentativesMethod = @"createNYCRepresentatives";
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:self.tableViewCellName bundle:nil] forCellReuseIdentifier:self.tableViewCellName];
}

#pragma mark - UI Methods

- (void)createTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

        [self.tableView registerNib:[UINib nibWithNibName:self.tableViewCellName bundle:nil]forCellReuseIdentifier:self.tableViewCellName];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)checkCache {
    [[CacheManager sharedInstance] checkCacheForRepresentative:self.cachedRepresentatives];
}

- (void)turnZeroStateOn {
    [UIView animateWithDuration:.25 animations:^{
        self.zeroStateContainer.alpha = 1;
    }];
}

- (void)turnZeroStateOff {
    [UIView animateWithDuration:.25 animations:^{
        self.zeroStateContainer.alpha = 0;
    }];
}

- (void)endRefreshing {
    [self.refreshControl endRefreshing];
}

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (void)createRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateCurrentLocation) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self setDataSources];
    if (self.tableViewDataSource.count > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.tableViewDataSource] forKey:self.cachedRepresentatives];
    }
    return self.tableViewDataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:self.tableViewCellName];
    [cell initFromIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

#pragma mark - LocationServices Methods

- (void)updateCurrentLocation {
    [[LocationService sharedInstance]startUpdatingLocation];
}

- (void)checkLocationAuthorizationStatus {
    if ([CLLocationManager authorizationStatus] <= 2) {
        [self turnZeroStateOn];
    }
    else {
        [self turnZeroStateOff];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"currentLocation"]) {
        [self getRepresentativesForCurrentLocation];
        [self.refreshControl endRefreshing];
    }
}

- (void)getRepresentativesForCurrentLocation {
    SEL selector = NSSelectorFromString(self.getRepresentativesMethod);
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(self, selector);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}

- (void)createCongressmen {
    [[RepManager sharedInstance]createCongressmenFromLocation:[LocationService sharedInstance].currentLocation WithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } onError:^(NSError *error) {
        NSLog(@"error");
    }];
}

- (void)createStateLegislators {
    [[RepManager sharedInstance]createStateLegislatorsFromLocation:[LocationService sharedInstance].currentLocation WithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } onError:^(NSError *error) {
        NSLog(@"error");
    }];
}

- (void)createNYCRepresentatives {
    [[RepManager sharedInstance]createNYCRepresentativesFromLocation:[LocationService sharedInstance].currentLocation WithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } onError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end