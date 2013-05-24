//
//  TestBlob.h
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 5/23/13.
//
//

#import <SenTestingKit/SenTestingKit.h>

@class BuddyClient;
@class BuddyAuthenticatedUser;


@interface TestBlob : SenTestCase

@property (nonatomic, strong) BuddyClient *BuddyClient;

@property (nonatomic, strong) BuddyAuthenticatedUser *user;

@end
