//
//  BuddyVideo.m
//  BuddySDK
//
//  Created by Ryan Brandenburg on 5/22/13.
//
//

#import "BuddyVideo.h"
#import "BuddyVideos.h"
#import "BuddyUtility.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyWebWrapper.h"
#import "BuddyClient_Exn.h"

@implementation BuddyVideo

@synthesize client;
@synthesize authUser;

@synthesize videoId;
@synthesize friendlyName;
@synthesize mimeType;
@synthesize fileSize;
@synthesize appTag;
@synthesize owner;
@synthesize latitude;
@synthesize longitude;
@synthesize uploadDate;
@synthesize lastTouchDate;
@synthesize videoUrl;

- (id)initVideo:(BuddyClient *)localClient authUser:(BuddyAuthenticatedUser *)localAuthUser  videoList:(NSDictionary *)videoList
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    if (videoList == nil || [videoList count] == 0)
    {
        return self;
    }
    client = (BuddyClient *)localClient;
    authUser = (BuddyAuthenticatedUser *)localAuthUser;
    videoId = [BuddyUtility NSNumberFromStringLong :[videoList objectForKey:@"videoID"]];
    friendlyName = [BuddyUtility stringFromString :[videoList objectForKey:@"friendlyName"]];
    mimeType = [BuddyUtility stringFromString: [videoList objectForKey:@"mimeType"]];
    fileSize = [BuddyUtility NSNumberFromStringInt: [videoList objectForKey:@"fileSize"]];
    appTag = [BuddyUtility stringFromString:[videoList objectForKey:@"appTag"]];
    owner = [BuddyUtility NSNumberFromStringLong:[videoList objectForKey:@"owner"]];
    latitude = [BuddyUtility doubleFromString:[videoList objectForKey:@"latitude"]];
    longitude = [BuddyUtility doubleFromString:[videoList objectForKey:@"longitude"]];
    uploadDate = [BuddyUtility dateFromString:[videoList objectForKey:@"uploadDate"]];
    lastTouchDate =[BuddyUtility dateFromString:[videoList objectForKey:@"lastTouchDate"]];
    videoUrl = [BuddyUtility stringFromString:[videoList objectForKey:@"videoUrl"]];
    
    return self;
}
-(void)editVideo:(NSString *)localFriendlyName
    localAppTag:(NSString *)localAppTag
       callback:(BuddyVideoEditVideoCallback)callback
{
    [[client webService] Videos_Video_EditInfo:authUser.token VideoID:self.videoId FriendlyName:localFriendlyName AppTag:localAppTag callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
           {
               if (callback)
               {
                   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
               }
           } copy]];
}

-(void)deleteVideo:(BuddyVideoDeleteVideoCallback)callback
{
    [[client webService] Videos_Video_DeleteVideo:authUser.token VideoID:self.videoId callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
       {
           if(callback)
           {
               callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
           }
       } copy]];
}

@end
