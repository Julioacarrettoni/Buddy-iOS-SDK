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

#import "BuddyBlobs.h"
#import "BuddyBlob.h"
#import "BuddyUtility.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyWebWrapper.h"
#import "BuddyClient_Exn.h"

/// <summary>
/// Represents a single blob object
/// </summary>

@implementation BuddyBlob

@synthesize client;
@synthesize authUser;

@synthesize blobId;
@synthesize friendlyName;
@synthesize mimeType;
@synthesize fileSize;
@synthesize appTag;
@synthesize owner;
@synthesize latitude;
@synthesize longitude;
@synthesize uploadDate;
@synthesize lastTouchDate;

- (id)initBlob:(BuddyClient *)localClient authUser:(BuddyAuthenticatedUser *)localAuthUser  blobList:(NSDictionary *)blobList
{
        self = [super init];
        if(!self)
        {
            return nil;
        }
    
        if (blobList == nil || [blobList count] == 0)
        {
            return self;
        }
        client = (BuddyClient *)localClient;
        authUser = (BuddyAuthenticatedUser *)localAuthUser;
        blobId = [BuddyUtility NSNumberFromStringLong :[blobList objectForKey:@"blobID"]];
        friendlyName = [BuddyUtility stringFromString :[blobList objectForKey:@"friendlyName"]];
        mimeType = [BuddyUtility stringFromString: [blobList objectForKey:@"mimeType"]];
        fileSize = [BuddyUtility NSNumberFromStringInt: [blobList objectForKey:@"fileSize"]];
        appTag = [BuddyUtility stringFromString:[blobList objectForKey:@"appTag"]];
        owner = [BuddyUtility NSNumberFromStringLong:[blobList objectForKey:@"owner"]];
        latitude = [BuddyUtility doubleFromString:[blobList objectForKey:@"latitude"]];
        longitude = [BuddyUtility doubleFromString:[blobList objectForKey:@"longitude"]];
        uploadDate = [BuddyUtility dateFromString:[blobList objectForKey:@"uploadDate"]];
        lastTouchDate =[BuddyUtility dateFromString:[blobList objectForKey:@"lastTouchDate"]];
    
        return self;
}

-(void)getBlob:(BuddyBlobGetBlobCallback)callback
{
    [self.authUser.blobs getBlob:self.blobId callback:callback];
}

-(void)editBlob:(NSString *)localFriendlyName
    localAppTag:(NSString *)localAppTag
       callback:(BuddyBlobEditBlobCallback)callback
{
    [[client webService] Blobs_Blob_EditInfo:authUser.token BlobID:self.blobId FriendlyName:localFriendlyName AppTag:localAppTag callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
         {
             if (callback)
             {
                 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
             }
         } copy]];
}

-(void)deleteBlob:(BuddyBlobDeleteBlobCallback)callback
{
    [[client webService] Blobs_Blob_DeleteBlob:authUser.token BlobID:self.blobId callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
            {
                if(callback)
                {
                    callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
                }
            } copy]];
}

@end