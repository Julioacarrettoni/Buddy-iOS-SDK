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

#import "BuddyPhotoAlbum.h"
#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"


/// <summary>
/// Represent a single Buddy photo album. Albums are collections of photo that can be manipulated by their owner (the user that created the album). Albums
/// can be public in which case other users can see them (but not modify).
/// </summary>

@implementation BuddyPhotoAlbum

@synthesize pictures;
@synthesize albumId;
@synthesize authUser;

- (id)initWithClient:(BuddyClient *)client
			authUser:(BuddyAuthenticatedUser *)localAuthUser
			 albumId:(NSNumber *)localAlbumId
			pictures:(NSArray *)localPictures;
{
	[BuddyUtility checkForNilClientAndUser:client user:localAuthUser name:@"BuddyPhotoAlbum"];

	self = [super initWithClient:client userId:localAuthUser.userId albumName:nil];

	if (!self)
	{
		return nil;
	}

	authUser = localAuthUser;
	albumId = localAlbumId;
	pictures = localPictures;

	return self;
}

- (id)initWithClient:(BuddyClient *)client
			authUser:(BuddyAuthenticatedUser *)localAuthUser
			 albumId:(NSNumber *)localAlbumId
{
	[BuddyUtility checkForNilUser:localAuthUser name:@"BuddyPhotoAlbum"];

	self = [super initWithClient:client userId:localAuthUser.userId albumName:nil];
	if (!self)
	{
		return nil;
	}

	authUser = localAuthUser;
	albumId = localAlbumId;
	pictures = [[NSArray alloc] init];

	return self;
}

- (void)delete:(NSObject *)state
	  callback:(BuddyPhotoAlbumDeleteCallback)callback
{
	[[self.client webService] Pictures_PhotoAlbum_Delete:self.authUser.token PhotoAlbumID:albumId state:state
												callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														  {
															  if (callback)
															  {
																  callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
															  }
														  } copy]];
}

- (void)InternalAddPicture:(NSString *)encodedValue
				   comment:(NSString *)comment
				  latitude:(double)latitude
				 longitude:(double)longitude
					appTag:(NSString *)appTag
					 state:(NSObject *)state
				  callback:(void (^)(BuddyPictureResponse *response))block
{
	NSMutableString *path = [[NSMutableString alloc] init];

	[path appendFormat:@"?%@", kPictures_Photo_Add];

	NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
            [BuddyUtility encodeValue:self.client.appName], @"BuddyApplicationName",
            [BuddyUtility encodeValue:self.client.appPassword], @"BuddyApplicationPassword",
            [BuddyUtility encodeValue:self.authUser.token], @"UserToken",
            [NSString stringWithFormat:@"%.5f", latitude], @"Latitude",
            [NSString stringWithFormat:@"%.5f", longitude], @"Longitude",
            [NSString stringWithFormat:@"%d", [self.albumId intValue]], @"AlbumID",
            encodedValue, @"bytesFullPhotoData",
            [BuddyUtility encodeValue:comment], @"PhotoComment",
            [BuddyUtility encodeValue:appTag], @"ApplicationTag",
            @"", @"RESERVED",
            nil];

	__block BuddyPhotoAlbum *_self = self;

	[[self.client webService] directPost:kPictures_Photo_Add path:path
								  params:dictParams
								   state:state
								callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
										  {
											  if (callbackParams.isCompleted && block)
											  {
												  if (callbackParams.dataResult && [BuddyUtility isAStandardError:callbackParams.dataResult] == FALSE)
												  {
													  NSNumber *pictureId = [NSNumber numberWithInt:[callbackParams.dataResult intValue]];
													  [_self.authUser getPicture:pictureId state:state callback:block];
												  }
												  else
												  {
													  block([[BuddyPictureResponse alloc] initWithError:callbackParams reason:callbackParams.dataResult]);
												  }
											  }
											  else
											  {
												  if (block)
												  {
													  block([[BuddyPictureResponse alloc] initWithError:callbackParams reason:callbackParams.exception.reason]);
												  }
											  }
											  _self = nil;
										  } copy]];
}

- (void)InternalAddPictureWithWatermark:(NSString *)encodedValue
								comment:(NSString *)comment
							   latitude:(double)latitude
							  longitude:(double)longitude
								 appTag:(NSString *)appTag
					   watermarkMessage:(NSString *)watermarkMessage
								  state:(NSObject *)state
							   callback:(void (^)(BuddyPictureResponse *response))block
{
	NSMutableString *path = [[NSMutableString alloc] init];

	[path appendFormat:@"?%@", kPictures_Photo_AddWithWatermark];

	NSDictionary *dictParams = [NSDictionary dictionaryWithObjectsAndKeys:
            [BuddyUtility encodeValue:self.client.appName], @"BuddyApplicationName",
            [BuddyUtility encodeValue:self.client.appPassword], @"BuddyApplicationPassword",
            [BuddyUtility encodeValue:self.authUser.token], @"UserToken",
            encodedValue, @"bytesFullPhotoData",
            [NSString stringWithFormat:@"%d", [self.albumId intValue]], @"AlbumID",
            [BuddyUtility encodeValue:comment], @"PhotoComment",
            [NSString stringWithFormat:@"%.5f", latitude], @"Latitude",
            [NSString stringWithFormat:@"%.5f", longitude], @"Longitude",
            [BuddyUtility encodeValue:watermarkMessage], @"WatermarkMessage",
            @"", @"RESERVED",
            nil];

	__block BuddyPhotoAlbum *_self = self;

	[[self.client webService] directPost:kPictures_Photo_AddWithWatermark path:path
								  params:dictParams
								   state:state
								callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
										  {
											  if (callbackParams.isCompleted && block)
											  {
												  if (callbackParams.dataResult && [BuddyUtility isAStandardError:callbackParams.dataResult] == FALSE)
												  {
													  NSNumber *pictureId = [NSNumber numberWithInt:[callbackParams.dataResult intValue]];
													  [_self.authUser getPicture:pictureId state:state callback:block];
												  }
												  else
												  {
													  block([[BuddyPictureResponse alloc] initWithError:callbackParams reason:callbackParams.dataResult]);
												  }
											  }
											  else
											  {
												  if (block)
												  {
													  block([[BuddyPictureResponse alloc] initWithError:callbackParams reason:callbackParams.exception.reason]);
												  }
											  }
											  _self = nil;
										  } copy]];
}

- (void)addPicture:(NSData *)blob
		   comment:(NSString *)comment
		  latitude:(double)latitude
		 longitude:(double)longitude
			appTag:(NSString *)appTag
			 state:(NSObject *)state
		  callback:(BuddyPhotoAlbumAddPictureCallback)callback
{
	[BuddyUtility checkBlobParam:blob functionName:@"AddPicture"];

	NSString *encodedValue = [[NSString alloc] initWithBytes:[blob bytes] length:[blob length] encoding:NSStringEncodingConversionAllowLossy];

	NSString *crlfEncodedValues = [encodedValue stringByReplacingOccurrencesOfString:@"\r\n" withString:@"%0D%0A"];

	[self InternalAddPicture:crlfEncodedValues comment:comment latitude:latitude longitude:longitude appTag:appTag state:state callback:callback];
}

- (void)addPicture:(NSData *)blob
		  callback:(BuddyPhotoAlbumAddPictureCallback)callback
{
	[self addPicture:blob comment:nil latitude:0.0 longitude:0.0 appTag:nil state:nil callback:callback];
}

- (void)addPictureWithWatermark:(NSData *)blob
						comment:(NSString *)comment
					   latitude:(double)latitude
					  longitude:(double)longitude
						 appTag:(NSString *)appTag
			   watermarkMessage:(NSString *)watermarkMessage
						  state:(NSObject *)state
					   callback:(BuddyPhotoAlbumAddPictureWithWatermarkCallback)callback
{
	[BuddyUtility checkBlobParam:blob functionName:@"AddPictureWithWatermark"];

	NSString *encodedValue = [[NSString alloc] initWithBytes:[blob bytes] length:[blob length] encoding:NSStringEncodingConversionAllowLossy];

	NSString *crlfEncodedValues = [encodedValue stringByReplacingOccurrencesOfString:@"\r\n" withString:@"%0D%0A"];

	[self InternalAddPictureWithWatermark:crlfEncodedValues comment:comment latitude:latitude longitude:longitude appTag:appTag watermarkMessage:watermarkMessage state:state callback:callback];
}

- (void)addPictureWithWatermark:(NSData *)blob
			   watermarkMessage:(NSString *)watermarkMessage
					   callback:(BuddyPhotoAlbumAddPictureWithWatermarkCallback)callback
{
	[self addPictureWithWatermark:blob comment:nil latitude:0.0 longitude:0.0 appTag:nil watermarkMessage:watermarkMessage state:nil callback:callback];
}

- (NSData *)encodeToBase64:(NSData *)blob
{
	NSData *encodedBlob = [[NSData alloc] init];

	if (blob)
	{
        encodedBlob = [BuddyUtility encodeToBase64:blob];
	}

	return encodedBlob;
}

@end