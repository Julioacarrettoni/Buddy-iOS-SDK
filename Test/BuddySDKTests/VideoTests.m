//
//  VideoTests.m
//  BuddySDKTests
//
//  Created by Ryan Brandenburg on 5/28/13.
//
//

#import "VideoTests.h"
#import "TestBuddySDK.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"
#import "BuddyAuthenticatedUser.h"
#import "BuddyVideos.h"
#import "BuddyVideo.h"

@implementation VideoTests

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

- (void)testVideo
{
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    int icount =1;
    while (icount != 0) {
        bwaiting = true;
        BuddyVideo* video = [self addVideo];
        
        bwaiting = true;
        [self getVideoInfo:video];
        [self waitloop];
        
        bwaiting = true;
        [self getVideoList:video];
        [self waitloop];
        
        bwaiting = true;
        [self getMyVideoList];
        [self waitloop];
    
        bwaiting = true;
        [self searchVideos];
        [self waitloop];
        
        bwaiting = true;
        [self searchMyVideos];
        [self waitloop];
        
        bwaiting = true;
        [self editVideo:video];
        [self waitloop];
        
        bwaiting = true;
        [self deleteVideo:video];
        [self waitloop];
        
        icount--;
    }
}

-(void)deleteVideo:(BuddyVideo *)video
{
    [video deleteVideo:[^(BuddyBoolResponse *response)
        {
            if(response.isCompleted)
            {
                NSLog(@"deleteVideo OK");
            }
            else
            {
                STFail(@"deleteVideo failed !response.isCompleted");
            }
        } copy]];
}

-(void)editVideo:(BuddyVideo *)video
{
    [video editVideo:@"friend" localAppTag:@"Tag" callback:[^(BuddyBoolResponse *response)
    {
        if(response.isCompleted)
        {
            NSLog(@"editVideo OK");
        }
        else
        {
            STFail(@"editVideo failed !response.isCOmpleted");
        }
    }copy]];
}

-(BuddyVideo*)addVideo
{
    NSString* str = @"testData";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    __block BuddyVideo * video = nil;
    
    __block VideoTests *_self = self;
    [_self.user.videos addVideo:@"friendlyName" appTag:@"Tag" latitude:0.0 longitude:0.0 mimeType:@"video/mp4" videoData:data callback:[^(BuddyVideoResponse *response)
            {
                if(response.isCompleted)
                {
                    // NSString *url = response.result.videoUrl;
                    NSLog(@"addVideo OK");
                    video = response.result;
                }
                else
                {
                    STFail(@"addVideo failed !response.isCompleted");
                }
            } copy]];
    [self waitloop];
    return video;
}


-(void)getVideoInfo:(BuddyVideo *)video
{
    __block VideoTests *_self = self;
    [_self.user.videos getVideoInfo:video.videoId callback:[^(BuddyVideoResponse *response)
         {
             if(response.isCompleted && response.result)
             {
                 NSLog(@"getVideoInfo OK");
             }
             else{
                 STFail(@"getVideoInfo OK");
             }
         } copy]];
}

-(void)searchVideos
{
    __block VideoTests *_self = self;
    [_self.user.videos searchVideos:@"friendlyName" mimeType:@"video/mp4" appTag:@"Tag" searchDistance:10 searchLatitude:0.0 searchLongitude:0.0 timeFilter:5 recordLimit:10 callback:[^(BuddyArrayResponse *response)
     {
         if(response.isCompleted)
         {
             [response.result objectAtIndex:0];
         }else
         {
             STFail(@"searchVideos failed !response.isCompleted");
         }
     } copy]];
}

-(void)searchMyVideos
{
    __block VideoTests *_self = self;
    [_self.user.videos searchMyVideos:@"friendlyName" mimeType:@"video/mp4" appTag:@"Tag" searchDistance:10 searchLatitude:0.0 searchLongitude:0.0 timeFilter:5 recordLimit:10 callback:[^(BuddyArrayResponse *response)
       {
           if(response.isCompleted)
           {
               [response.result objectAtIndex:0];
           }else
           {
               STFail(@"searchVideos failed !response.isCompleted");
           }
       } copy]];
    
}

-(void)getMyVideoList
{
    __block VideoTests *_self = self;
    [_self.user.videos getMyVideoList:10 callback:[^(BuddyArrayResponse *response)
         {
             if(response.isCompleted)
             {
                 [response.result objectAtIndex:0];
             }else
             {
                 STFail(@"searchVideos failed !response.isCompleted");
             }
         } copy]];
}

-(void)getVideoList:(BuddyVideo *)video
{
    __block VideoTests *_self = self;
    [_self.user.videos getVideoList:video.owner recordLimit:10 callback:[^(BuddyArrayResponse *response)
      {
          if(response.isCompleted)
          {
              [response.result objectAtIndex:0];
          }else
          {
              STFail(@"searchVideos failed !response.isCompleted");
          }
      } copy]];
}
























@end
