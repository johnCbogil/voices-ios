//
//  VoicesConstants.m
//  Voices
//
//  Created by John Bogil on 3/8/16.
//  Copyright © 2016 John Bogil. All rights reserved.
//


#import "VoicesConstants.h"

@implementation VoicesConstants

NSString *const kRepTableViewCell = @"RepTableViewCell";

NSString *const kAvenirNextRegular = @"AvenirNext-Regular";
NSString *const kAvenirNextMedium = @"AvenirNext-Medium";
NSString *const kAvenirNextBold = @"AvenirNext-Bold";
//NSString *const kMontserratLight = @"Montserrat-Light";
//NSString *const kOpenSans = @"OpenSans";

NSString *const kSFCongress = @"a0c99640cc894383975eb73b99f39d2f";
NSString *const kSFState = @"a0c99640cc894383975eb73b99f39d2f";
NSString *const kGoogMaps = @"AIzaSyBr8fizIgU0OF53heFICd3ak5Yp1EJpviE";

NSString *const kFederalRepresentative = @"FederalRepresentative";
NSString *const kStateRepresentative = @"StateRepresentative";
NSString *const kNYCRepresentative = @"NYCRepresentative";

NSString *const kCreateFederalRepresentatives = @"createFederalRepresentatives";
NSString *const kCreateStateRepresentatives = @"createStateRepresentatives";
NSString *const kCreateNYCRepresentatives = @"createNYCRepresentatives";

NSString *const kCityCouncilZip = @"CouncilDistrictsJSON";
NSString *const kCityCouncilJSON = @"City Council Districts.geojson";
NSString *const kCouncilMemberDataJSON = @"CouncilMemberData";
NSString *const kNYCExtraRepsJSON = @"nycExtraReps";

CGFloat const kButtonCornerRadius = 3.f;

NSString *const kActionEmptyStateTopLabel = @"You haven't received any actions yet.";
NSString *const kActionEmptyStateBottomLabel = @"To receive actions from advocacy groups, tap the + button above to follow groups.";
NSString *const kGroupEmptyStateTopLabel = @"You don't follow any groups yet.";
NSString *const kGroupEmptyStateBottomLabel = @"To follow groups, tap the + button above.";

NSString *const kLocalRepsMissing = @"Local officials are not available in this area yet.";

NSString *const kGroupDefaultImage = @"VoicesIcon";
NSString *const kRepDefaultImageMale = @"MissingRepMale";
NSString *const kRepDefaultImageFemale = @"MissingRepFemale";

#pragma mark - Reporting

NSString *const kEVENT_DATABASE = @"https://script.google.com/macros/s/AKfycbxBK6HTkA6tTXU09sRF5PHHCq2LpBOFdx4ZH7E4ORf3sG374iU/exec?";
NSString *const kCALL_EVENT = @"CALL_REPRESENTATIVES_EVENT";
NSString *const kTWEET_EVENT = @"TWEET_REPRESENTATIVES_EVENT";
NSString *const kEMAIL_EVENT = @"EMAIL_REPRESENTATIVES_EVENT";
NSString *const kSUBSCRIBE_EVENT = @"SUBSCRIBE_EVENT";
NSString *const kUNSUBSCRIBE_EVENT = @"UNSUBSCRIBE_EVENT";


@end
