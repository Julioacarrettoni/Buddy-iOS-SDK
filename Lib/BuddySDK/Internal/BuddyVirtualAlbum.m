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

#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"


/// <summary>
/// Represents a single virtual album. Unlike normal photo albums any user may add existing photos to a virtual album.
/// Only the owner of the virtual album can delete the album however.
/// </summary>

@implementation BuddyVirtualAlbum

@synthesize client;
@synthesize authUser;
@synthesize pictures;
@synthesize virtualAlbumId;
@synthesize name;
@synthesize thumbnailUrl;
@synthesize ownerUserId;
@synthesize applicationTag;
@synthesize createdOn;
@synthesize lastUpdated;
@synthesize _pictures;

- (void)dealloc
{
	client = nil;
	authUser = nil;
}

- (void)addInfo:(NSDictionary *)vInfo
{
	if (vInfo)
	{
		virtualAlbumId = [BuddyUtility NSNumberFromStringInt:[vInfo objectForKey:@"virtualAlbumID"]];
		applicationTag = [BuddyUtility stringFromString:[vInfo objectForKey:@"applicationTag"]];
		createdOn = [BuddyUtility buddyDate:[vInfo objectForKey:@"createdDateTime"]];
		lastUpdated = [BuddyUtility buddyDate:[vInfo objectForKey:@"lastUpdatedDateTime"]];
		ownerUserId = [BuddyUtility NSNumberFromStringInt:[vInfo objectForKey:@"userID"]];
		thumbnailUrl = [BuddyUtility stringFromString:[vInfo objectForKey:@"photoAlbumThumbnail"]];
	}
}

- (id)   initWithAuthUser:(BuddyClient *)localClient
				 authUser:(BuddyAuthenticatedUser *)localAuthUser
	virtualPhotoAlbumInfo:(NSDictionary *)virtualPhotoAlbumInfo
				 pictures:(NSArray *)localPictures
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyVirtualAlbum"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	authUser = localAuthUser;

	[self addInfo:virtualPhotoAlbumInfo];
	_pictures = [[NSMutableArray alloc] init];

	[self addPictures:localPictures];
	pictures = _pictures;
	return self;
}

- (void)addPictures:(NSArray *)data
{
	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict == nil || [dict count] == 0)
			{
				continue;
			}

			BuddyPicture *picture = [[BuddyPicture alloc] initPicture:self.client authUser:self.authUser photoList:dict];
			if (picture)
			{
				[_pictures addObject:picture];
			}
		}
	}
}

- (void)delete:(BuddyVirtualAlbumDeleteCallback)callback
{
	[[client webService] Pictures_VirtualAlbum_DeleteAlbum:authUser.token VirtualAlbumID:self.virtualAlbumId RESERVED:@"" 
												  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															{
																if (callback)
																{
																	callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																}
															} copy]];
}

- (void)addPicture:(BuddyPicturePublic *)picture
			 
		  callback:(BuddyVirtualAlbumAddPictureCallback)callback
{
	[self checkPicture:picture];

	[[client webService] Pictures_VirtualAlbum_AddPhoto:authUser.token VirtualAlbumID:self.virtualAlbumId ExistingPhotoID:picture.photoId RESERVED:@"" 
											   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														 {
															 if (callback)
															 {
																 if ([BuddyUtility isAStandardError:callbackParams.stringResult])
																 {
																	 callback([[BuddyBoolResponse alloc] initWithError:callbackParams]);
																 }
																 else
																 {
																	 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams localResult:TRUE]);
																 }
															 }
														 } copy]];
}

- (void)addPictureBatch:(NSArray *)pictureBatch
				  
			   callback:(BuddyVirtualAlbumAddPictureBatchCallback)callback
{
	if (pictureBatch == nil || [pictureBatch count] == 0)
	{
		[BuddyUtility throwNilArgException:@"BuddyVirtualAlbum" reason:@"pictureBatch"];
	}

	NSMutableString *batch = [[NSMutableString alloc] init];

	int count = (int)[pictureBatch count];
	for (int j = 0; j < count; j++)
	{
		BuddyPicturePublic *picture = (BuddyPicturePublic *)[pictureBatch objectAtIndex:(unsigned int) j];
		[batch appendFormat:@"%d;", [picture.photoId intValue]];
	}

	NSUInteger lastChar = [batch length] - 1;
	NSRange rangeOfLastChar = [batch rangeOfComposedCharacterSequenceAtIndex:lastChar];
	NSString *batched = [batch substringToIndex:rangeOfLastChar.location];

	[[client webService] Pictures_VirtualAlbum_AddPhotoBatch:authUser.token VirtualAlbumID:self.virtualAlbumId ExistingPhotoIDBatchString:batched RESERVED:@"" 
													callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															  {
																  if (callback)
																  {
																	  BOOL result = FALSE;
																	  if (callbackParams.isCompleted)
																	  {
																		  result = TRUE;
																	  }

																	  callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams localResult:result]);
																  }
															  } copy]];
}

- (void)removePicture:(BuddyPicturePublic *)picture
				
			 callback:(BuddyVirtualAlbumRemovePictureCallback)callback
{
	[self checkPicture:picture];

	[[client webService] Pictures_VirtualAlbum_RemovePhoto:authUser.token VirtualAlbumID:self.virtualAlbumId ExistingPhotoID:picture.photoId RESERVED:@"" 
												  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															{
																if (callback)
																{
																	callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																}
															} copy]];
}

- (void)update:(NSString *)newName
	  callback:(BuddyVirtualAlbumUpdateCallback)callback
{
	[self update:newName newAppTag:nil  callback:callback];
}

- (void)update:(NSString *)newName
	 newAppTag:(NSString *)newAppTag
		 
	  callback:(BuddyVirtualAlbumUpdateCallback)callback
{
	[BuddyUtility checkNameParam:newName functionName:@"BuddyVirtualAlbum"];

	[[client webService] Pictures_VirtualAlbum_Update:authUser.token VirtualPhotoAlbumID:self.virtualAlbumId NewAlbumName:newName NewAppTag:newAppTag RESERVED:@"" 
											 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													   {
														   if (callback)
														   {
															   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
														   }
													   } copy]];
}

- (void)updatePicture:(BuddyPicturePublic *)picture
		   newComment:(NSString *)newComment
			 callback:(BuddyVirtualAlbumUpdatePictureCallback)callback;
{
	[self updatePicture:picture newComment:newComment newAppTag:nil  callback:callback];
}

- (void)updatePicture:(BuddyPicturePublic *)picture
		   newComment:(NSString *)newComment
			newAppTag:(NSString *)newAppTag
				
			 callback:(BuddyVirtualAlbumUpdatePictureCallback)callback
{
	[self checkPicture:picture];

	[[client webService] Pictures_VirtualAlbum_UpdatePhoto:authUser.token ExistingPhotoID:picture.photoId NewPhotoComment:newComment NewAppTag:newAppTag RESERVED:@"" 
												  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															{
																if (callback)
																{
																	callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																}
															} copy]];
}

- (void)checkPicture:(BuddyPicturePublic *)picture
{
	if (picture == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyVirtualAlbum" reason:@"picture"];
	}
}

@end