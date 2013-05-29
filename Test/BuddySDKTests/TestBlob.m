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
#import "BuddyAuthenticatedUser.h"
#import "BuddyBlobs.h"
#import "BuddyBlob.h"


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

- (void)testBlob
{
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    int icount =1;
    while (icount != 0) {
//        bwaiting = true;
//        BuddyBlob* blob = [self addBlob];
//        [self waitloop];
//        
//        bwaiting = true;
//        [self getBlobInfo:blob];
//        [self waitloop];
//        
//        bwaiting = true;
//        [self getBlob:blob];
//        [self waitloop];
//    
//        bwaiting = true;
//        [self getBlobList:blob];
//        [self waitloop];
//        
//        bwaiting = true;
//        [self getMyBlobList:blob];
//        [self waitloop];
//        
//        bwaiting = true;
//        [self searchBlobs:blob];
//        [self waitloop];
//        
//        bwaiting = true;
//        [self searchMyBlobs:blob];
//        [self waitloop];
        
        icount--;
    }
}

-(BuddyBlob*)addBlob
{
    NSString* str = @"testData";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    __block BuddyBlob * blob = nil;
    
    __block TestBlob *_self = self;
    [_self.user.blobs addBlob:@"friendlyName" appTag:@"Tag" latitude:0.0 longtidue:0.0 mimeType:@"video/mp4" blobData:data callback:[^(BuddyBlobResponse *response)
         {
             if(response.isCompleted)
             {
                 NSLog(@"addBlob OK");
                 blob = response.result;
             }
             else
             {
                 STFail(@"addBlob failed !response.isCompleted");
             }
         } copy]];
    [self waitloop];
    return blob;
}

-(void)getBlobInfo:(BuddyBlob *)blob
{
    __block TestBlob *_self = self;
    [_self.user.blobs getBlobInfo:blob.blobId callback:[^(BuddyBlobResponse *response)
        {
            if(response.isCompleted && response.result)
            {
                NSLog(@"getBlobInfo OK");
            }
            else
            {
                STFail(@"getBlobInfo failed !response.isCompleted");
            }
        } copy]];
}

-(void)getBlob:(BuddyBlob *)blob
{
    __block TestBlob *_self = self;
    [_self.user.blobs getBlob:blob.blobId callback:^(NSData *data){
        if(!data || data.length < 1)
        {
            STFail(@"getBlob failed ");
        }
    }];
}

-(void)searchBlobs:(BuddyBlob *)blob
{
    __block TestBlob *_self = self;
    [_self.user.blobs searchBlobs:@"friendlyName" mimeType:@"video/mp4" appTag:@"Tag" searchDistance:10 searchLatitude:0.0 searchLongitude:0.0 timeFilter:5 recordLimit:10 callback:[^(BuddyArrayResponse *response)
             {
                 if(response.isCompleted)
                 {
                     [response.result objectAtIndex:0];
                 }else
                 {
                     STFail(@"searchBlobs failed !response.isCompleted");
                 }
             } copy]];
}

-(void)searchMyBlobs:(BuddyBlob *)blob
{
    __block TestBlob *_self = self;
    [_self.user.blobs searchMyBlobs:@"friendlyName" mimeType:@"video/mp4" appTag:@"Tag" searchDistance:10 searchLatitude:0.0 searchLongitude:0.0 timeFilter:5 recordLimit:10 callback:[^(BuddyArrayResponse *response)
           {
               if(response.isCompleted)
               {
                   [response.result objectAtIndex:0];
               }else
               {
                   STFail(@"searchBlobs failed !response.isCompleted");
               }
           } copy]];

}

-(void)getMyBlobList:(BuddyBlob *)blob
{
    __block TestBlob *_self = self;
    [_self.user.blobs getMyBlobList:10 callback:[^(BuddyArrayResponse *response)
         {
             if(response.isCompleted)
             {
                 [response.result objectAtIndex:0];
             }else
             {
                 STFail(@"searchBlobs failed !response.isCompleted");
             }
         } copy]];
}

-(void)getBlobList:(BuddyBlob *)blob
{
    __block TestBlob *_self = self;
    [_self.user.blobs getBlobList:blob.owner recordLimit:10 callback:[^(BuddyArrayResponse *response)
         {
             if(response.isCompleted)
             {
                 [response.result objectAtIndex:0];
             }else
             {
                 STFail(@"searchBlobs failed !response.isCompleted");
             }
         } copy]];
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
