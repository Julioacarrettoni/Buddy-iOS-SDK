//
//  SocialLoginTest.m
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 6/20/13.
//
//

#import "SocialLoginTest.h"
#import "BuddyClient.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyAuthenticatedUser.h"

@class BuddyClient;
@class BuddyAuthenticatedUser;

@implementation SocialLoginTest

static NSString *AppName = @"Buddy iOS SDK test app";
static NSString *AppPassword = @"8C9E044D-7DB7-42DE-A376-16460B58008E";
static bool bwaiting = false;
static NSString *Token = @"UT-76444f9f-4a4b-4d3d-ba5c-7a82b5dbb5a5";

@synthesize buddyClient;
@synthesize user;

- (void)setUp
{
    [super setUp];
    
    self.buddyClient = [[BuddyClient alloc] initClient:AppName
                                           appPassword:AppPassword
                                            appVersion:@"1"
                                  autoRecordDeviceInfo:TRUE];
    
    
    STAssertNotNil(self.buddyClient, @"TestFriendRequest failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];
    
    self.buddyClient = nil;
    self.user = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:20];
    
    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)alogin
{
    [self.buddyClient login:Token callback:[^(BuddyAuthenticatedUserResponse *response)
                                             {
                                                 if (response.isCompleted && response.result)
                                                 {
                                                     NSLog(@"Login OK");
                                                     self.user = response.result;
                                                 }
                                                 else
                                                 {
                                                     STFail(@"alogin failed !response.isCompleted || !response.result");
                                                 }
                                                 bwaiting = false;
                                             } copy]];
}

-(void)testSocial
{
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    int icount =1;
    while (icount != 0)
    {
        bwaiting = true;
        [self getSocial];
        [self waitloop];
        
        icount--;
    }
}

-(void)getSocial
{
    [self.buddyClient socialLogin:@"Facebook" providerUserId:@"1345387375" accessToken:@"CAACEdEose0cBABxnBUxWl89GBkg5C8tFj7Cmnwh6UeRDb6OjZCZBjDcKZAX5dZA7d0gm9639kKdZAbOo8Y4GOZBFJCRjRiiQddMo6WXiU8Y42RkzeP6jEdZACVThgb5gZBM4eSpx0aloBZAXumwc5dTyBs0lWVi2ccA4ZD" callback:[^(BuddyAuthenticatedUserResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"Login OK");
        }
        else
        {
            if (![response.exception.reason isEqualToString:@"UserAccount_Profile_SocialLogin: AccessTokenInvalid"])
            {
                STFail(@"SocialLoginFailed");
            }
        }
        bwaiting = false;
    } copy]];
}

@end
