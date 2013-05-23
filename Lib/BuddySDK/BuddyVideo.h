//
//  BuddyVideo.h
//  BuddySDK
//
//  Created by Ryan Brandenburg on 5/22/13.
//
//

#import <Foundation/Foundation.h>

typedef void (^BuddyVideoGetVideoCallback)(NSData * response);

typedef void (^BuddyVideoEditVideoCallback)(BuddyBoolResponse * response);

typedef void (^BuddyVideoDeleteVideoCallback)(BuddyBoolResponse * response);


/// <summary>
/// Represents a Video object.
/// </summary>
@interface BuddyVideo : NSObject

/// <summary>
/// Gets the VideoID for this video
/// </summary>
@property (readonly, nonatomic, strong) NSNumber *videoId;


/// <summary>
/// Gets the FriendlyName for this video
/// </summary>
@property (readonly, nonatomic, strong) NSString *friendlyName;

@property (readonly, nonatomic, strong) NSString *mimeType;

@property (readonly, nonatomic, strong) NSNumber *fileSize;

@property (readonly, nonatomic, strong) NSString *appTag;

@property (readonly, nonatomic, strong) NSNumber *owner;

@property (readonly, nonatomic, assign) double latitude;

@property (readonly, nonatomic, assign) double longitude;

@property (readonly, nonatomic, strong) NSDate *uploadDate;

@property (readonly, nonatomic, strong) NSDate *lastTouchDate;

//TODO: figure out a better return type
-(void)getVideo:(BuddyVideoGetVideoCallback)callback;

-(void)editVideo:(NSString *)friendlyName
         appTag:(NSString *)appTag
       callback:(BuddyVideoEditVideoCallback)callback;

-(void)deleteBlob:(BuddyVideoDeleteVideoCallback)callback;


@end
