//
//  TestBlob.m
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 5/23/13.
//
//

#import "TestBlob.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"

@implementation TestBlob

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
    
    STAssertNotNil(self.buddyClient, @"TestIdentity failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];
    
    self.buddyClient = nil;
    self.user = nil;
}

- (void)alogin
{
    [self.buddyClient login:Token state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
        {
            if (response.isCompleted)
            {
                self.user = response.result;
                NSLog(@"alogin OK user: %@", self.user.toString);
            }
            else
            {
                STFail(@"alogin failed !response.isCompleted");
            }
            bwaiting = false;
        } copy]];
}

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:15];
    
    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

-(void)testBlobGetInfo
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_Identity"];
    
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    if (!self.user)
    {
        STFail(@"testIdentityParsing login failed.");
        return;
    }
    [self.user.blobs performSelector:]
}


@end
