//
//  FederalRepresentative.m
//  Voices
//
//  Created by John Bogil on 7/23/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "FederalRepresentative.h"

@implementation FederalRepresentative

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if(self != nil) {
        self.bioguide = [data valueForKey:@"bioguide_id"];
        self.firstName = [data valueForKey:@"first_name"];
        self.lastName = [data valueForKey:@"last_name"];
        self.fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
        self.nickname = [data valueForKey:@"nickname"];
        self.bioguide = [data valueForKey:@"bioguide_id"];
        self.phone = [data valueForKey:@"phone"];
        self.party = [data valueForKey:@"party"];
        self.email = [data valueForKey:@"oc_email"];
        self.twitter = [data valueForKey:@"twitter_id"];
        self.districtNumber = [data valueForKey:@"district"];
        self.stateCode = [data valueForKey:@"state"];
        self.nextElection = [self formatElectionDate:[data valueForKey:@"term_end"]];
        [self formatTitle:[data valueForKey:@"title"]];
        self.photoURL = [self createPhotoURLFromBioguide:self.bioguide];
        self.gender = [data valueForKey:@"gender"];
        return self;
    }
    return self;
}

- (NSURL *)createPhotoURLFromBioguide:(NSString *)bioguide {
    NSString *dataUrl = [NSString stringWithFormat:@"https://theunitedstates.io/images/congress/225x275/%@.jpg", bioguide];
    NSURL *url = [NSURL URLWithString:dataUrl];
    return url;
}

- (NSString*)formatElectionDate:(NSString*)termEnd {
    if ([termEnd isEqualToString:@"2019-01-03"]) {
        return @"6 Nov 2018";
    }
    else if ([termEnd isEqualToString:@"2017-01-03"]) {
        return @"8 Nov 2016";
    }
    else {
        return @"3 Nov 2020";
    }
}

- (void)formatTitle:(NSString*)data {
    if ([data isEqualToString:@"Sen"]) {
        self.title = @"Senator";
        self.shortTitle = @"Sen.";
    }
    else {
        self.title = @"Representative";
        self.shortTitle = @"Rep.";
    }
}

@end
