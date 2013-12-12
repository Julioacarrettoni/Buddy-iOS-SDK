//
//  BuddyClientTests.m
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 7/19/13.
//
//


#import "TestBuddySDK.h"
#import "BuddyClientTests.h"
#import "BuddyClient.h"
#import "BuddyBoolResponse.h"
#import "BuddyDataResponses.h"
#import "BuddyCallbackParams.h"
#import "BuddyGameScores.h"
#import "BuddyGameScore.h"
#import "BuddyGameState.h"
#import "BuddyGameStates.h"
#import "BuddyGamePlayer.h"

@implementation BuddyClientTests

@synthesize buddyClient;

static NSString *AppName = @"Buddy iOS SDK test app";
static NSString *AppPassword = @"8C9E044D-7DB7-42DE-A376-16460B58008E";
static bool bwaiting = false;

- (void)setUp
{
    [super setUp];
    
    self.buddyClient = [[BuddyClient alloc] initClient:AppName
                                           appPassword:AppPassword
                                            appVersion:@"1"
                                  autoRecordDeviceInfo:TRUE];
    
    STAssertNotNil(self.buddyClient, @"BuddyCLientTests setup failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];
    
    self.buddyClient = nil;
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:30];
    
    while(bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)testRequestPasswordReset
{
    NSString *result = @"1";
    
    NSNumber *res = [self.buddyClient performSelector:@selector(isSuccess:) withObject:result];
    
    if([res boolValue] != TRUE)
    {
        STFail(@"testRequestPasswordReset failed");
    }
}

- (void)testResetPassword
{
    NSString *result = @"1";
    
    NSNumber *res = [self.buddyClient performSelector:@selector(isSuccess:) withObject:result];
    
    if([res boolValue] != TRUE)
    {
        STFail(@"testResetPassword failed");
    }
}


- (void)testDeviceId
{
    NSString *deviceId = [self.buddyClient.device id];
    
    if (deviceId == nil || [deviceId length] == 0)
    {
        STFail(@"testDeviceId failed");
    }

    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    if ([[versionCompatibility objectAtIndex:0] intValue] >= 6)
    {
        NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:deviceId];

        if (uuid == nil)
        {
            STFail(@"testDeviceId failed, device id is invalid: %@", deviceId);
        }
    }
    
    NSLog(@"Device Id: %@", deviceId);
}
@end

