//
//  Congressperson.m
//  v2
//
//  Created by John Bogil on 7/23/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "Congressperson.h"

@implementation Congressperson

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if(self != nil) {
        self.firstName = [data valueForKey:@"first_name"];
        self.lastName = [data valueForKey:@"last_name"];
        self.bioguide = [data valueForKey:@"bioguide_id"];
        self.phone = [data valueForKey:@"phone"];
        self.crpID = [data valueForKey:@"crp_id"];
        return self;
    }
    return self;
}
@end