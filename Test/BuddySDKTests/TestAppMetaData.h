//
//  TestAppMetaData.h
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 5/26/13.
//
//

#import <SenTestingKit/SenTestingKit.h>

@class BuddyClient;
@class BuddyAuthenticatedUser;
@class BuddyAuthenticatedUserResponse;

@interface TestAppMetaData : SenTestCase

@property (nonatomic, strong) BuddyClient *buddyClient;

@property (nonatomic, strong) BuddyAuthenticatedUser *buddyUser;

@end
