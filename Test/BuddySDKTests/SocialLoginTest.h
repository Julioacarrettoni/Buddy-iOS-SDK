//
//  SocialLoginTest.h
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 6/20/13.
//
//

#import <SenTestingKit/SenTestingKit.h>

@class BuddyClient;
@class BuddyAuthenticatedUser;
@class BuddySounds;

@interface SocialLoginTest : SenTestCase

@property (nonatomic, strong) BuddyClient *buddyClient;

@property (nonatomic, strong) BuddyAuthenticatedUser *user;

@end
