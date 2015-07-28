//
//  RepManager.h
//  v2
//
//  Created by John Bogil on 7/27/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Congressperson.h"

@interface RepManager : NSObject
+(RepManager *) sharedInstance;
@property (strong, nonatomic) NSArray *listOfCongressmen;
@property (strong, nonatomic) NSArray *listofStateLegislators;
- (void)createCongressmen:(void(^)(void))successBlock
                     onError:(void(^)(NSError *error))errorBlock;
- (void)createStateLegislators:(void(^)(void))successBlock
                       onError:(void(^)(NSError *error))errorBlock;
- (void)assignPhotos:(Congressperson*)congressperson withCompletion:(void(^)(void))successBlock
             onError:(void(^)(NSError *error))errorBlock;
@end
