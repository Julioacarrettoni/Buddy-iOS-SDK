/*
 * Copyright (C) 2012 Buddy Platform, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */


#import "BuddyVideo.h"
#import "BuddyVideos.h"
#import "BuddyUtility.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyWebWrapper.h"
#import "BuddyClient_Exn.h"

/// <summary>
/// Represents a single Video object
/// </summary>

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
