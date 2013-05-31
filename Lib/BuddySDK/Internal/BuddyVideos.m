//
//  BuddyVideos.m
//  BuddySDK
//
//  Created by Ryan Brandenburg on 5/22/13.
//
//

#import "BuddyVideos.h"
#import "BuddyVideo.h"
#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"

@implementation BuddyVideos

@synthesize client;
@synthesize authUser;

-(void)dealloc
{
    client =nil;
    authUser=nil;
}

-(id)initVideos:(BuddyClient *)localClient
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

-(NSArray *)makeVideosList:(NSArray *)data
{
    NSMutableArray *videos = [[NSMutableArray alloc] init];
    
    if(data && [data isKindOfClass:[NSArray class]])
    {
        int i = (int)[data count];
        for (int j = 0; j < i; j++)
        {
            NSDictionary *dict = (NSDictionary *) [data objectAtIndex:(unsigned int)j];
            if(dict && [dict count] > 0)
            {
                BuddyVideo * video = [[BuddyVideo alloc] initVideo:self.client authUser:self.authUser videoList:(NSDictionary *)dict];
                if(video)
                {
                    [videos addObject:video];
                }
            }
        }
    }
    
    return videos;
}

-(void)addVideo:(NSString *)friendlyName
         appTag:(NSString *)appTag
       latitude:(double)latitude
      longitude:(double)longitude
       mimeType:(NSString *)mimeType
      videoData:(NSData *)videoData
       callback:(BuddyVideoAddVideoCallback)callback
{
    __block BuddyVideos *_self = self;
    
    [[client webService] Videos_Video_AddVideo:authUser.token FriendlyName:friendlyName AppTag:appTag Latitude:latitude Longitude:longitude ContentType:mimeType VideoData:videoData callback:[^(BuddyCallbackParams *callbackParams, id jsonArray){
        if (callbackParams.isCompleted && callback)
        {
            if ([BuddyUtility isAStandardError:callbackParams.stringResult] == FALSE)
            {
                NSNumber *videoId = [NSNumber numberWithInt:[callbackParams.stringResult intValue]];
                
                [_self getVideoInfo:videoId callback:[^(BuddyVideoResponse *result2)
                                                                {
                                                                    callback(result2);
                                                                    _self = nil;
                                                                } copy]];
            }
            else
            {
                callback([[BuddyVideoResponse alloc] initWithError:callbackParams reason:callbackParams.stringResult]);
                _self = nil;
                
            }
        }
        else
        {
            if (callback)
            {
                callback([[BuddyVideoResponse alloc] initWithError:callbackParams reason:callbackParams.exception.reason]);
            }
            _self = nil;
        }
    } copy]];

}

-(void)getVideoInfo:(NSNumber*)videoID
          callback:(BuddyVideoGetVideoInfoCallback)callback
{
    if (videoID == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyVideos.GetVideoInfo" reason:@"videoId"];
	}
    
    [[client webService] Videos_Video_GetVideoInfo:authUser.token VideoID:videoID callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
           {
               BuddyVideo *video;
               NSException *exception;
               @try
               {
                   if (callbackParams.isCompleted && jsonArray != nil && [jsonArray count] > 0)
                   {
                       NSDictionary *dict = (NSDictionary *)[jsonArray objectAtIndex:0];
                       if (dict && [dict count] > 0)
                       {
                           video = [[BuddyVideo alloc] initVideo:client authUser:authUser videoList:dict];
                       }
                   }
               }
               @catch (NSException *ex)
               {
                   exception = ex;
               }
               
               if (exception)
               {
                   callback([[BuddyVideoResponse alloc] initWithError:exception
                                                             apiCall:callbackParams.apiCall]);
               }
               else
               {
                   callback([[BuddyVideoResponse alloc] initWithResponse:callbackParams
                                                                 result:video]);
               }
           } copy]];
}

-(void)searchMyVideos:(NSString *)friendlyName
            mimeType:(NSString *)mimeType
              appTag:(NSString *)appTag
      searchDistance:(int)searchDistance
      searchLatitude:(double)searchLatitude
     searchLongitude:(double)searchLongitude
          timeFilter:(int)timeFilter
         recordLimit:(int)recordLimit
            callback:(BuddyVideoVideoListCallback)callback
{
    __block BuddyVideos *_self = self;
    
    [[client webService] Videos_Video_SearchMyVideos: authUser.token FriendlyName:friendlyName MimeType:mimeType AppTag:appTag SearchDistance:searchDistance SearchLatitude:searchLatitude SearchLongitude:searchLongitude TimeFilter:timeFilter RecordLimit:recordLimit callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
            {
                if (callback)
                {
                    NSArray *data;
                    NSException *exception;
                    @try
                    {
                        if (callbackParams.isCompleted && jsonArray != nil)
                        {                                                                                                                                                                                                                                                                                                            data = [_self makeVideosList:jsonArray];
                        }
                    }
                    @catch (NSException *ex)
                    {
                        exception = ex;
                    }
                    
                    if (exception)
                    {
                        callback([[BuddyArrayResponse alloc] initWithError:exception                                                                                                                                                                                                                                                                                                                      apiCall:callbackParams.apiCall]);
                    }
                    else
                    {                                                                                                                                                                                                                                                                                                        callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams                                                                                                                                                                                                                                                                                                                                                       result:data]);
                    }
                }
                _self = nil;
            } copy]];
}

-(void)searchVideos:(NSString *)friendlyName
          mimeType:(NSString *)mimeType
            appTag:(NSString *)appTag
    searchDistance:(int)searchDistance
    searchLatitude:(double)searchLatitude
   searchLongitude:(double)searchLongitude
        timeFilter:(int)timeFilter
       recordLimit:(int)recordLimit
          callback:(BuddyVideoVideoListCallback)callback
{
    __block BuddyVideos *_self = self;
    
    [[client webService] Videos_Video_SearchVideos: authUser.token FriendlyName:friendlyName MimeType:mimeType AppTag:appTag SearchDistance:searchDistance SearchLatitude:searchLatitude SearchLongitude:searchLongitude TimeFilter:timeFilter RecordLimit:recordLimit callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
          {
              if (callback)
              {                                                                                                                                                                                                                                                                       NSArray *data;                                                                                                                                                                                                                                                                                                    NSException *exception;                                                                                                                                                                                                                                                                                            @try                                                                                                                                                                                                                                                                                                    {
                      if (callbackParams.isCompleted && jsonArray != nil)
                      {                                                                                                                                                                                                                                                                                                            data = [_self makeVideosList:jsonArray];
                      }
                  }
                  @catch (NSException *ex)
                  {
                      exception = ex;
                  }
                  if (exception)
                  {
                      callback([[BuddyArrayResponse alloc] initWithError:exception                                                                                                                                                                                                                                                                                                                            apiCall:callbackParams.apiCall]);
                  }
                  else
                  {                                                                                                                                                                                                                                                                                                        callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams                                                                                                                                                                                                                                                                                                                                                       result:data]);
                  }
              }
              _self = nil;
          } copy]];
}

-(void)getVideoList:(NSNumber*)userID
       recordLimit:(int)recordLimit
          callback:(BuddyVideoVideoListCallback)callback
{
    __block BuddyVideos *_self = self;
    
    [[client webService] Videos_Video_GetVideoList:authUser.token UserID:userID RecordLimit:recordLimit callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
           {
               if (callback)
               {                                                                                                                                                                                                                                                                       NSArray *data;                                                                                                                                                                                                                                                                                                    NSException *exception;                                                                                                                                                                                                                                                                                            @try                                                                                                                                                                                                                                                                                                    {
                   if (callbackParams.isCompleted && jsonArray != nil)
                   {                                                                                                                                                                                                                                                                                                            data = [_self makeVideosList:jsonArray];
                   }
               }
                   @catch (NSException *ex)
                   {
                       exception = ex;
                   }
                   if (exception)
                   {
                       callback([[BuddyArrayResponse alloc] initWithError:exception                                                                                                                                                                                                                                                                                                                                     apiCall:callbackParams.apiCall]);
                   }
                   else
                   {                                                                                                                                                                                                                                                                                                        callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams                                                                                                                                                                                                                                                                                                                                                       result:data]);
                   }
               }
               _self = nil;
           } copy]];
}

-(void)getMyVideoList:(int)recordLimit
            callback:(BuddyVideoVideoListCallback)callback
{
    __block BuddyVideos *_self = self;
    [[client webService] Videos_Video_GetMyVideoList:authUser.token RecordLimit:recordLimit callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
           {
               if (callback)
               {                                                                                                                                                                                                                                                                       NSArray *data;                                                                                                                                                                                                                                                                                                    NSException *exception;                                                                                                                                                                                                                                                                                            @try                                                                                                                                                                                                                                                                                                    {
                   if (callbackParams.isCompleted && jsonArray != nil)
                   {                                                                                                                                                                                                                                                                                                            data = [_self makeVideosList:jsonArray];
                   }
               }
                   @catch (NSException *ex)
                   {
                       exception = ex;
                   }
                   if (exception)
                   {
                       callback([[BuddyArrayResponse alloc] initWithError:exception                                                                                                                                                                                                                                                                                                                                       apiCall:callbackParams.apiCall]);
                   }
                   else
                   {                                                                                                                                                                                                                                                                                                        callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams                                                                                                                                                                                                                                                                                                                                                       result:data]);
                   }
               }
               _self = nil;
           } copy]];
}

@end
