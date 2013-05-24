//
//  BuddyVideos.h
//  BuddySDK
//
//  Created by Ryan Brandenburg on 5/22/13.
//
//

#import <Foundation/Foundation.h>

@class BuddyNSNumberResponse;
@class BuddyVideoResponse;
@class BuddyArrayResponse;

typedef void (^BuddyVideoAddVideoCallback)(BuddyVideoResponse * response);

typedef void (^BuddyVideoGetVideoCallback) (BuddyArrayResponse * response);

typedef void (^BuddyVideoGetVideoInfoCallback)(BuddyVideoResponse * response);

typedef void (^BuddyVideoVideoListCallback)(BuddyArrayResponse * response);

@interface BuddyVideos : NSObject

-(void)addVideo:(NSString *)friendlyName
         appTag:(NSString *)appTag
       latitude:(double)latitude
      longtidue:(double)longitude
       mimeType:(NSString *)mimeType
      videoData:(NSData *)videoData
          state:(NSObject *)state
       callback:(BuddyVideoAddVideoCallback)callback;

-(void)getVideo:(NSNumber *)videoID
          state:(NSObject *)state
       callback:(BuddyVideoGetVideoCallback)callback;

-(void)getVideoInfo:(NSNumber *)videoID
              state:(NSObject *)state
           callback:(BuddyVideoGetVideoInfoCallback)callback;

-(void)searchMyVideos:(NSString *)friendlyName
             mimeType:(NSString *)mimeType
               appTag:(NSString *)appTag
       searchDistance:(int)searchDistance
       searchLatitude:(double)searchLatitude
      searchLongitude:(double)searchLongitude
           timeFilter:(int)timeFilter
          recordLimit:(int)recordLimit
                state:(NSObject *)state
            callback:(BuddyVideoVideoListCallback)callback;

-(void)searchVideos:(NSString *)friendlyName
           mimeType:(NSString *)mimeType
             appTag:(NSString *)appTag
     searchDistance:(int)searchDistance
     searchLatitude:(double)searchLatitude
    searchLongitude:(double)searchLongitude
         timeFilter:(int)timeFilter
        recordLimit:(int)recordLimit
              state:(NSObject *)state
           callback:(BuddyVideoVideoListCallback)callback;

-(void)getVideoList:(NSNumber *)userID
        recordLimit:(int)recordLimit
              state:(NSObject *)state
           callback:(BuddyVideoVideoListCallback)callback;

-(void)getMyVideoList:(int)recordLimit
                state:(NSObject *)state
             callback:(BuddyVideoVideoListCallback)callback;
@end
