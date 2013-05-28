//
//  TestBlob.m
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 5/23/13.
//
//

#import "TestBlob.h"
#import "TestBuddySDK.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"

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
    
    
    STAssertNotNil(self.buddyClient, @"TestFriendRequest failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];
    
    self.buddyClient = nil;
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

- (void)testBlob
{
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    int icount =1;
    while (icount != 0) {
//        bwaiting = true;
//        [self addBlob];
//        [self waitloop];
//        
//        bwaiting = true;
//        [self getBlobInfo];
//        [self waitloop];
//        
//        bwaiting = true;
//        [self getBlob];
//        [self waitloop];
        icount--;
    
    }
}

-(void)addBlob
{
    __block TestBlob *_self = self;
}

-(void)getBlobInfo
{

}

-(void)getBlob
{

}

- (void)testGetBlobs
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_GetBlobs"];
    
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    if (!self.user)
    {
        STFail(@"testGetBlobs login failed.");
        return;
    }
    
    NSArray *dict = [self.user.blobs performSelector:@selector(makeBlobsList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"Should have been two elements in the dict");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.user.friends performSelector:@selector(makeFriendsList:) withObject:resArray];
    
    if ([dict count] != 0)
    {
        STFail(@"testGetBlobs failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.user.friends performSelector:@selector(makeFriendsList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testGetBlobs failed dict should have 0 items");
    }
}

@end
