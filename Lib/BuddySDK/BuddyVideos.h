//
//  BuddyVideos.h
//  BuddySDK
//
//  Created by Ryan Brandenburg on 5/22/13.
//
//

#import <Foundation/Foundation.h>

@interface BuddyVideos : NSObject

-(void)addVideo:(NSString *)friendlyName
         appTag:(NSString *)appTag
       latitude:(double)latitude
      longtidue:(double)longitude
       mimeType:(NSString *)mimeType
      videoData:(NSData *)videoData;

-(void)getVideo:(long)videoID;

-(void)getVideoInfo:(long)videoID;

-(void)searchMyVideos:(NSString *)friendlyName
             mimeType:(NSString *)mimeType
               appTag:(NSString *)appTag
       searchDistance:(int)searchDistance
       searchLatitude:(double)searchLatitude
      searchLongitude:(double)searchLongitude
           timeFilter:(int)timeFilter
          recordLimit:(int)recordLimit;

-(void)searchVideos:(NSString *)friendlyName
           mimeType:(NSString *)mimeType
             appTag:(NSString *)appTag
     searchDistance:(int)searchDistance
     searchLatitude:(double)searchLatitude
    searchLongitude:(double)searchLongitude
         timeFilter:(int)timeFilter
        recordLimit:(int)recordLimit;

-(void)getVideoList:(long)userID
        recordLimit:(int)recordLimit;

-(void)getMyVideoList:(int)recordLimit;
@end
