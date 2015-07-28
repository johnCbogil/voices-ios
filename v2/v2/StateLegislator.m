//
//  StateLegislator.m
//  v2
//
//  Created by John Bogil on 7/24/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "StateLegislator.h"

@implementation StateLegislator
- (id)initWithData:(NSDictionary*)data {
    self = [super init];
    if(self != nil) {

        self.firstName = [data valueForKey:@"first_name"];
        self.lastName = [data valueForKey:@"last_name"];
        self.phone = [[data valueForKey:@"offices"]valueForKey:@"phone"][0];
        self.photoURL = [data valueForKey:@"photo_url"];
        return self;
    }
    return self;
}
@end
