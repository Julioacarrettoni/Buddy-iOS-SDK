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

#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyCallbackParams.h"


@interface BuddyCallbackParams()

- (id)initWithParam:(BOOL)succeeded
			apiCall:(NSString *)apiCall
		  exception:(NSException *)localException
			  
		 dataResult:(NSData *)localDataResult
            stringResult:(NSString*)localStringResult;

- (id)initWithParam:(BOOL)succeeded
		  exception:(NSException *)localException
			  ;

- (id)initWithError:(NSException *)localException
			  
			apiCall:(NSString *)apiCall;

- (id)initWithError:(BuddyCallbackParams *)callback;

- (id)initTrueWithState:(NSObject *)state;

@end


@interface BuddyDataResponses()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(id)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@interface BuddyBoolResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
           localResult:(BOOL)localResult;

- (id)initUnKnownErrorResponse:(BuddyCallbackParams *)callbackParams 
                     exception:(NSException *)exception;
@end


@interface BuddyStringResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(NSString *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@interface BuddyArrayResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(NSArray *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@interface BuddyDictionaryResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(NSDictionary *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@class BuddyVirtualAlbum;

@interface BuddyVirtualAlbumResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyVirtualAlbum *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end

@class BuddyVideo;

@interface BuddyVideoResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyVideo *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;

- (id)initWithError:(NSString *)apiCall
			 reason:(NSString *)errorString
			  state:(NSObject *)state;

@end

@class BuddyBlob;

@interface BuddyBlobResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyBlob *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;

- (id)initWithError:(NSString *)apiCall
			 reason:(NSString *)errorString
			  state:(NSObject *)state;

@end

@class BuddyMetadataSum;

@interface BuddyMetadataSumResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyMetadataSum *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@class BuddyPhotoAlbum;

@interface BuddyPhotoAlbumResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyPhotoAlbum *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@class BuddyPicture;

@interface BuddyPictureResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyPicture *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;

@end


@class BuddyGamePlayer;

@interface BuddyGamePlayerResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyGamePlayer *)data;

- (id)initCompletedWithResponse:(BuddyCallbackParams *)callbackParams
						 result:(BuddyGamePlayer *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@class BuddyAuthenticatedUser;

@interface BuddyAuthenticatedUserResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyAuthenticatedUser *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@class BuddyPlace;

@interface BuddyPlaceResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyPlace *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@class BuddyGameState;

@interface BuddyGameStateResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyGameState *)data;

- (id)initCompletedWithResponse:(BuddyCallbackParams *)callbackParams
						 result:(BuddyGameState *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@interface BuddyNSNumberResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(NSNumber *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@interface BuddyMetadataItemResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyMetadataItem *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;

@end


@interface BuddyUserResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyUser *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;

@end


@interface BuddyMessageGroupResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyMessageGroup *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end


@interface BuddyDateResponse()

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(NSDate *)data;

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString;


@end
