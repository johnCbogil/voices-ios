//
//  ActionDetailTopTableViewCell.m
//  Voices
//
//  Created by John Bogil on 6/10/17.
//  Copyright © 2017 John Bogil. All rights reserved.
//

#import "ActionDetailTopTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ActionDetailTopTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *actionTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupImageButton;
@property (nonatomic)BOOL isDescriptionExpanded;

@end

// TODO: RENAME THIS CLASS

@implementation ActionDetailTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self configureActionTitleLabel];
}

- (void)initWithAction:(Action *)action andGroup:(Group *)group {
    
    [self fetchGroupLogoForImageURL:group.groupImageURL];
    self.actionTitleLabel.text = action.title;
}

- (void)configureActionTitleLabel {
    
    self.actionTitleLabel.backgroundColor = [UIColor whiteColor];
    self.actionTitleLabel.font = [UIFont voicesBoldFontWithSize:21];
    self.actionTitleLabel.numberOfLines = 0;
}

- (void)fetchGroupLogoForImageURL:(NSURL *)url {
    
    self.groupImageButton.backgroundColor = [UIColor clearColor];
    self.groupImageButton.imageView.contentMode = UIViewContentModeScaleToFill;
    self.groupImageButton.layer.cornerRadius = kButtonCornerRadius;
    self.groupImageButton.clipsToBounds = YES;
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:url
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [self.groupImageButton.imageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed: kGroupDefaultImage] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
        [UIView animateWithDuration:.25 animations:^{
            [self.groupImageButton setBackgroundImage:image forState:UIControlStateNormal];
        }];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSError * _Nonnull error) {
        [UIView animateWithDuration:.25 animations:^{
            [self.groupImageButton setBackgroundImage:[UIImage imageNamed:kGroupDefaultImage] forState:UIControlStateNormal];
        }];
    }];
}

- (IBAction)groupImageButtonDidPress:(id)sender {
    // Add observer to push to GroupDetailViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:@"presentGroupDetailViewController" object:nil];
}

@end
