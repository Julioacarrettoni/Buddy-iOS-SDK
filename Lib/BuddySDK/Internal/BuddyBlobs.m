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
#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"

/// <summary>
/// Represents a class that can be used to add, retrieve and manage blobs for the current user.
/// </summary>

@implementation BuddyBlobs

@synthesize client;
@synthesize authUser;

-(void)dealloc
{
    client =nil;
    authUser=nil;
}

-(id)initBlobs:(BuddyClient *)localClient
      authUser:(BuddyAuthenticatedUser *)localAuthUser
{
    self = [super init];
    if(!self)
    {
        return nil;
    }

    client = (BuddyClient *)localClient;
    authUser = (BuddyAuthenticatedUser *)localAuthUser;

    return self;
}

-(NSArray *)makeBlobsList:(NSArray *)data
{
    NSMutableArray *blobs = [[NSMutableArray alloc] init];
    
    if(data && [data isKindOfClass:[NSArray class]])
    {
        int i = (int)[data count];
        for (int j = 0; j < i; j++)
        {
            NSDictionary *dict = (NSDictionary *) [data objectAtIndex:(unsigned int)j];
            if(dict && [dict count] > 0)
            {
                BuddyBlob * blob = [[BuddyBlob alloc] initBlob:self.client authUser:self.authUser blobList:(NSDictionary *)dict];
                if(blob)
                {
                    [blobs addObject:blob];
                }
            }
        }
    }
        
    return blobs;
}

-(void)getBlob:(NSNumber *)blobID
callback:(void(^)(NSData *))callback
{
    [[client webService] Blobs_Blob_GetBlob:authUser.token BlobID:blobID callback:^(BuddyCallbackParams *callbackParams, NSData *data) {
        callback(data);
    }];
}

-(void)getBlobInfo:(NSNumber*)blobID
          callback:(BuddyBlobGetBlobInfoCallback)callback
{
    if (blobID == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyBlobs.GetBlobInfo" reason:@"blobId"];
	}
    
    [[client webService] Blobs_Blob_GetBlobInfo:authUser.token BlobID:blobID callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
        {
            BuddyBlob *blob;
            NSException *exception;
            @try
            {
                if (callbackParams.isCompleted && jsonArray != nil && [jsonArray count] > 0)
                {
                    NSDictionary *dict = (NSDictionary *)[jsonArray objectAtIndex:0];
                    if (dict && [dict count] > 0)
                    {
                        blob = [[BuddyBlob alloc] initBlob:client authUser:authUser blobList:dict];
                    }
                }
            }
            @catch (NSException *ex)
            {
                exception = ex;
            }
            
            if (exception)
            {
                callback([[BuddyBlobResponse alloc] initWithError:exception
                                                          apiCall:callbackParams.apiCall]);
            }
            else
            {
                callback([[BuddyBlobResponse alloc] initWithResponse:callbackParams
                                                              result:blob]);
            }
        } copy]];
}

-(void)searchMyBlobs:(NSString *)friendlyName
            mimeType:(NSString *)mimeType
              appTag:(NSString *)appTag
      searchDistance:(int)searchDistance
      searchLatitude:(double)searchLatitude
     searchLongitude:(double)searchLongitude
          timeFilter:(int)timeFilter
         recordLimit:(int)recordLimit
            callback:(BuddyBlobBlobListCallback)callback
{
    __block BuddyBlobs *_self = self;
    
    [[client webService] Blobs_Blob_SearchMyBlobs: authUser.token FriendlyName:friendlyName MimeType:mimeType AppTag:appTag SearchDistance:searchDistance SearchLatitude:searchLatitude SearchLongitude:searchLongitude TimeFilter:timeFilter RecordLimit:recordLimit callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
        {
            if (callback)
              {
                  NSArray *data;
                  NSException *exception;
                  @try
                  {
                      if (callbackParams.isCompleted && jsonArray != nil)
                      {                                                                                                                                                                                                                                                                                                            data = [_self makeBlobsList:jsonArray];
                      }
                  }
                  @catch (NSException *ex)
                  {
                      exception = ex;
                  }
                  
                  if (exception)
                  {
                      callback([[BuddyArrayResponse alloc] initWithError:exception                                                                                                                                                                                                                                                                                                                                   apiCall:callbackParams.apiCall]);
                  }
                  else
                  {                                                                                                                                                                                                                                                                                                        callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams                                                                                                                                                                                                                                                                                                                                                       result:data]);
                  }
              }
            _self = nil;
        } copy]];
}

-(void)searchBlobs:(NSString *)friendlyName
            mimeType:(NSString *)mimeType
              appTag:(NSString *)appTag
      searchDistance:(int)searchDistance
      searchLatitude:(double)searchLatitude
     searchLongitude:(double)searchLongitude
          timeFilter:(int)timeFilter
         recordLimit:(int)recordLimit
            callback:(BuddyBlobBlobListCallback)callback
{
    __block BuddyBlobs *_self = self;
    
    [[client webService] Blobs_Blob_SearchBlobs: authUser.token FriendlyName:friendlyName MimeType:mimeType AppTag:appTag SearchDistance:searchDistance SearchLatitude:searchLatitude SearchLongitude:searchLongitude TimeFilter:timeFilter RecordLimit:recordLimit  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
        {
            if (callback)
            {                                                                                                                                                                                                                                                                       NSArray *data;                                                                                                                                                                                                                                                                                                    NSException *exception;                                                                                                                                                                                                                                                                                            @try                                                                                                                                                                                                                                                                                                    {
                    if (callbackParams.isCompleted && jsonArray != nil)
                    {                                                                                                                                                                                                                                                                                                            data = [_self makeBlobsList:jsonArray];
                    }
                }
                @catch (NSException *ex)
                {
                    exception = ex;
                }
                if (exception)
                {
                    callback([[BuddyArrayResponse alloc] initWithError:exception                                                                                                                                                                                                                                                                                                                             apiCall:callbackParams.apiCall]);
                }
                else
                {                                                                                                                                                                                                                                                                                                        callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams                                                                                                                                                                                                                                                                                                                                                       result:data]);
                }
            }
            _self = nil;
        } copy]];
}

-(void)getBlobList:(NSNumber*)userID
       recordLimit:(int)recordLimit
          callback:(BuddyBlobBlobListCallback)callback
{
    __block BuddyBlobs *_self = self;
    
    [[client webService] Blobs_Blob_GetBlobList:authUser.token UserID:userID RecordLimit:recordLimit  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
        {
            if (callback)
            {                                                                                                                                                                                                                                                                       NSArray *data;                                                                                                                                                                                                                                                                                                    NSException *exception;                                                                                                                                                                                                                                                                                            @try                                                                                                                                                                                                                                                                                                    {
                    if (callbackParams.isCompleted && jsonArray != nil)
                    {                                                                                                                                                                                                                                                                                                            data = [_self makeBlobsList:jsonArray];
                    }
                }
                @catch (NSException *ex)
                {
                    exception = ex;
                }
                if (exception)
                {
                    callback([[BuddyArrayResponse alloc] initWithError:exception                                                                                                                                                                                                                                                                                                                                             apiCall:callbackParams.apiCall]);
                }
                else
                {                                                                                                                                                                                                                                                                                                        callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams                                                                                                                                                                                                                                                                                                                                                       result:data]);
                }
            }
            _self = nil;
        } copy]];
}

-(void)getMyBlobList:(int)recordLimit
                callback:(BuddyBlobBlobListCallback)callback
{
    __block BuddyBlobs *_self = self;
    [[client webService] Blobs_Blob_GetMyBlobList:authUser.token RecordLimit:recordLimit  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
       {
           if (callback)
           {                                                                                                                                                                                                                                                                       NSArray *data;                                                                                                                                                                                                                                                                                                    NSException *exception;                                                                                                                                                                                                                                                                                            @try                                                                                                                                                                                                                                                                                                    {
               if (callbackParams.isCompleted && jsonArray != nil)
               {                                                                                                                                                                                                                                                                                                            data = [_self makeBlobsList:jsonArray];
               }
           }
               @catch (NSException *ex)
               {
                   exception = ex;
               }
               if (exception)
               {
                   callback([[BuddyArrayResponse alloc] initWithError:exception                                                                                                                                                                                                                                                                                                apiCall:callbackParams.apiCall]);
               }
               else
               {                                                                                                                                                                                                                                                                                                        callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams                                                                                                                                                                                                                                                                                                                                                       result:data]);
               }
           }
           _self = nil;
       } copy]];
}

-(void)addBlob:(NSString *)friendlyName
        appTag:(NSString *)appTag
      latitude:(double)latitude
     longitude:(double)longitude
      mimeType:(NSString *)mimeType
      blobData:(NSData *)blobData
      callback:(BuddyBlobAddBlobCallback)callback
        
{
    __block BuddyBlobs *_self = self;
    
    [[client webService] Blobs_Blob_AddBlob:authUser.token FriendlyName:friendlyName AppTag:appTag Latitude:latitude Longitude:longitude ContentType:mimeType BlobData:blobData callback:[^(BuddyCallbackParams *callbackParams, id jsonArray){
        if (callbackParams.isCompleted && callback)
        {
            if ([BuddyUtility isAStandardError:callbackParams.stringResult] == FALSE)
            {
                NSNumber *blobId = [NSNumber numberWithInt:[callbackParams.stringResult intValue]];
                
                [_self getBlobInfo:blobId callback:[^(BuddyBlobResponse *result2)
                    {
                        callback(result2);
                        _self = nil;
                    } copy]];
            }
            else
            {
                callback([[BuddyBlobResponse alloc] initWithError:callbackParams reason:callbackParams.stringResult]);
                _self = nil;

            }
        }
        else
        {
            if (callback)
            {
                callback([[BuddyBlobResponse alloc] initWithError:callbackParams reason:callbackParams.exception.reason]);
            }
            _self = nil;
        }
    } copy]];
}

@end