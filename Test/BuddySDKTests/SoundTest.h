//
//  SoundTest.h
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 5/28/13.
//
//

#import <SenTestingKit/SenTestingKit.h>

@class BuddyClient;
@class BuddyAuthenticatedUser;
@class BuddySounds;

@interface SoundTest : SenTestCase

@property (nonatomic, strong) BuddyClient *buddyClient;

@property (nonatomic, strong) BuddyAuthenticatedUser *user;

@end
