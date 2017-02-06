//
//  ShareCollectionViewController.h
//  Voices
//
//  Created by Daniel Nomura on 2/2/17.
//  Copyright © 2017 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCollectionViewController : UIViewController
@property (strong, nonatomic) NSString *shareString;
@property (strong, nonatomic) NSString *shortenedShareString;
@end

typedef enum {
    Facebook = 1,
    Twitter,
    SMS,
    FBMessenger
} SocialMediaApp;
