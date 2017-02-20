//
//  SearchResultsManager
//  Voices
//
//  Created by John Bogil on 2/16/17.
//  Copyright © 2017 John Bogil. All rights reserved.
//

#import "SearchResultsManager.h"

@import GooglePlaces;

@interface SearchResultsManager () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) GMSPlacesClient *placesClient;

@end

@implementation SearchResultsManager

+ (SearchResultsManager *) sharedInstance {
    static SearchResultsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        
        _placesClient = [[GMSPlacesClient alloc] init];
        self.resultsArray = @[@"one", @"two", @"three"];
    }
    return self;
}

#pragma mark - Autocomplete methods ---------------------------------

- (void)placeAutocomplete:(NSString *)searchText {
    
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.country = @"US";
    
    [_placesClient autocompleteQuery:searchText
                              bounds:nil
                              filter:filter
                            callback:^(NSArray *results, NSError *error) {
                                if (error != nil) {
                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                    return;
                                }
                                NSMutableArray *tempArray = @[].mutableCopy;
                                for (GMSAutocompletePrediction* result in results) {
                                    NSLog(@"Result '%@'", result.attributedFullText.string);
                                    [tempArray addObject:result.attributedFullText];
                                }
                                self.resultsArray = tempArray;
                                //                                [self.tableView reloadData];
                            }];
}


#pragma mark - Tableview delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = self.resultsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
