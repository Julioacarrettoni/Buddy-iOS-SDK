//
//  SoundTest.m
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 5/28/13.
//
//



#import "SoundTest.h"
#import "TestBuddySDK.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"
#import "BuddyAuthenticatedUser.h"
#import "BuddyBlobs.h"
#import "BuddyBlob.h"
#import "BuddySounds.h" 

@class BuddyClient;
@class BuddyAuthenticatedUser;
@class BuddySounds;

@implementation SoundTest 

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
    [self.buddyClient login:Token  callback:[^(BuddyAuthenticatedUserResponse *response)
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

-(void)testSound
{
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    int icount =1;
    while (icount != 0)
    {
        bwaiting = true;
        [self getSound];
        [self waitloop];
        
        icount--;
    }
}

-(void)getSound
{
    __block SoundTest *_self = self;
    [_self.buddyClient.sounds getSound:@"european_city_ambience_01_120_loop" quality:Low callback:^(NSData *data){
        if(!data || data.length < 1)
        {
            STFail(@"getSound failed");
        }
    }];
}


@end
