//
//  TestAppMetaData.m
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 5/26/13.
//
//

#import "TestAppMetaData.h"
#import "BuddyDataResponses.h"
#import "BuddyClient.h"
#import "BuddyBoolResponse.h"
#import "BuddyMetaDataSum.h"

@implementation TestAppMetaData

static NSString *AppName = @"Buddy iOS SDK test app";
static NSString *AppPassword = @"8C9E044D-7DB7-42DE-A376-16460B58008E";
static bool bwaiting = false;
static NSString *Token = @"UT-76444f9f-4a4b-4d3d-ba5c-7a82b5dbb5a5";

@synthesize buddyUser;
@synthesize buddyClient;

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
                 self.buddyUser = response.result;
             }
             else
             {
                 STFail(@"alogin failed !response.isCompleted || !response.result");
             }
             bwaiting = false;
         } copy]];
}

- (void)testMetaData
{
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
//    int icount =1;
//    while (icount != 0) {
//        bwaiting = true;
//        [self addMetaData];
//        [self waitloop];
//        
//        bwaiting = true;
//        [self addMetaData2];
//        [self waitloop];
//        
//        bwaiting = true;
//        [self sumMetaData];
//        [self waitloop];
//        
//        bwaiting = true;
//        [self batchSumMetaData];
//        [self waitloop];
//        
//        icount--;
//    }
}

- (void)addMetaData
{
    __block TestAppMetaData *_self = self;
    [_self.buddyClient.metadata set:@"TestKey1" value:@"124" latitude:0.0 longitude:0.0 appTag:@"AppTag" callback:[^(BuddyBoolResponse *response)
       {
           if(response.isCompleted)
           {
               NSLog(@"addMetaData1 OK");
           }
           else
           {
               STFail(@"addMetaData1 failed !response.isCompleted");
           }
           bwaiting = false;
       } copy]];
}

- (void)addMetaData2
{
    __block TestAppMetaData *_self =self;
    [_self.buddyClient.metadata set:@"TestKey2" value:@"5235" callback:[^(BuddyBoolResponse *response)
        {
            if(response.isCompleted)
            {
                NSLog(@"addMetaData2 OK");
            }
            else
            {
                STFail(@"addMetaData2 failed !response.isCompleted");
            }
            bwaiting = false;
        } copy]];
}

-(void)sumMetaData
{
    __block TestAppMetaData *_self = self;
    [_self.buddyClient.metadata sum:@"TestKey%" callback:[^(BuddyMetadataSumResponse *response)
        {
            if(response.isCompleted)
            {
                if(response.result.total != 5359)
                {
                    STFail(@"sumMetaData should have had 5359 as total");
                }
            }else
            {
                STFail(@"sumMetaData failed !response.isCompleted");
            }
        } copy]];
}

-(void)batchSumMetaData
{
    __block TestAppMetaData *_self = self;
    [_self.buddyClient.metadata batchSum:@"TestKey%;TestKey1" callback:[^(BuddyArrayResponse *response)
        {
            if(response.isCompleted)
            {
                [response.result objectAtIndex:0];
            }else
            {
                STFail(@"BatchSumData failed !response.isCompleted");
            }
        } copy]];
}

@end
