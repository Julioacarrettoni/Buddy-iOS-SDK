//
//  BuddyBlobs.h
//  BuddySDK
//
//  Created by Ryan Brandenburg on 5/22/13.
//
//

#import <Foundation/Foundation.h>

@interface BuddyBlobs : NSObject

-(void)addBlob:(NSString *)friendlyName
        appTag:(NSString *)appTag
      latitude:(double)latitude
     longtidue:(double)longitude
      mimeType:(NSString *)mimeType
      blobData:(NSData *)blobData;

-(void)getBlob:(long)blobID;

-(void)getBlobInfo:(long)blobID;

-(void)searchMyBlobs:(NSString *)friendlyName
                 mimeType:(NSString *)mimeType
                   appTag:(NSString *)appTag
           searchDistance:(int)searchDistance
           searchLatitude:(double)searchLatitude
          searchLongitude:(double)searchLongitude
               timeFilter:(int)timeFilter
              recordLimit:(int)recordLimit;

-(void)searchBlobs:(NSString *)friendlyName
                 mimeType:(NSString *)mimeType
                   appTag:(NSString *)appTag
           searchDistance:(int)searchDistance
           searchLatitude:(double)searchLatitude
          searchLongitude:(double)searchLongitude
               timeFilter:(int)timeFilter
              recordLimit:(int)recordLimit;

-(void)getBlobList:(long)userID
       recordLimit:(int)recordLimit;

-(void)getMyBlobList:(int)recordLimit;

@end
