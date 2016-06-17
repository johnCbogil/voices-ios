//
//  CacheManager.h
//  Voices
//
//  Created by John Bogil on 9/9/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+(CacheManager *) sharedInstance;
- (void)saveRepsToCache:(NSArray *)representatives forKey:(NSString *)key;
- (NSArray *)fetchRepsFromCache:(NSString *)representativeType;

@end