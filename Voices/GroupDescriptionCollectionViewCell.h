//
//  GroupDescriptionCollectionViewCell.h
//  Voices
//
//  Created by perrin cloutier on 12/5/16.
//  Copyright © 2016 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
@import Firebase;

@interface GroupDescriptionCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) NSString *currentUserID;


@end
