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

#import "BuddyPhotoAlbums.h"
#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"


/// <summary>
/// Represents a object that can be used to interact with an AuthenticatedUser's photo albums.
/// </summary>

@implementation BuddyPhotoAlbums

@synthesize client;
@synthesize authUser;

- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser;
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyPhotoAlbums"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	authUser = localAuthUser;

	return self;
}

- (void)dealloc
{
	client = nil;
	authUser = nil;
}

- (void)create:(NSString *)name
	  callback:(BuddyPhotoAlbumsCreateCallback)callback
{
	[self create:name isPublic:FALSE appTag:nil  callback:callback];
}

- (void)create:(NSString *)name
	  isPublic:(BOOL)isPublic
		appTag:(NSString *)appTag
		 
	  callback:(BuddyPhotoAlbumsCreateCallback)callback
{
	[BuddyUtility checkNameParam:name functionName:@"BuddyPhotoAlbums"];

	NSNumber *publicInt = (isPublic == true) ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];

	__block BuddyPhotoAlbums *_self = self;

	[[client webService] Pictures_PhotoAlbum_Create:authUser.token AlbumName:name PublicAlbumBit:publicInt ApplicationTag:appTag RESERVED:@"" 
										   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													 {
														 if (callbackParams.isCompleted && callback)
														 {
															 NSString *result = callbackParams.stringResult;
															 if (result != nil && [BuddyUtility isAStandardError:result] == FALSE)
															 {
																 NSNumber *albumId = [NSNumber numberWithInt:[result intValue]];
																 [_self get:albumId  callback:[^(BuddyPhotoAlbumResponse *result2)
																										  {
																											  callback(result2);
																											  _self = nil;
																										  } copy]];
															 }
															 else
															 {
																 callback([[BuddyPhotoAlbumResponse alloc] initWithError:callbackParams reason:callbackParams.stringResult]);
																 _self = nil;
															 }
														 }
														 else
														 {
															 if (callback)
															 {
																 callback([[BuddyPhotoAlbumResponse alloc] initWithError:callbackParams reason:callbackParams.exception.reason]);
															 }
															 _self = nil;
														 }
													 } copy]];
}

- (NSDictionary *)makeBuddyPhotoAlbumDictionary:(NSArray *)data
{
	NSMutableDictionary *dictOut = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *dictPhotoAlbum = [[NSMutableDictionary alloc] init];

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

			NSString *albumId = [BuddyUtility stringFromString:[dict objectForKey:@"albumID"]];
			if ([BuddyUtility isNilOrEmpty:albumId] || [albumId isEqualToString:@"0"])
			{
				continue;
			}

			if ([dictOut objectForKey:albumId] == nil)
			{
				NSMutableArray *array = [[NSMutableArray alloc] init];
				[dictOut setObject:array forKey:albumId];
			}

			NSMutableArray *array = (NSMutableArray *)[dictOut objectForKey:albumId];
			if (array != nil)
			{
				BuddyPicture *picture = [[BuddyPicture alloc] initPicture:client authUser:authUser photoList:dict];
				if (picture)
				{
					[array addObject:picture];
				}
			}
		}

		for (id key in dictOut)
		{
			NSMutableArray *array = (NSMutableArray *)[dictOut objectForKey:key];
			NSNumber *albumId = [NSNumber numberWithInt:[key intValue]];

			BuddyPhotoAlbum *photoAlbum = [[BuddyPhotoAlbum alloc] initWithClient:client authUser:authUser albumId:albumId pictures:array];
			if (photoAlbum)
			{
				[dictPhotoAlbum setValue:photoAlbum forKey:key];
			}
		}
	}
	return dictPhotoAlbum;
}

- (BuddyPhotoAlbum *)makeBuddyPhotoAlbum:(NSArray *)data
{
	NSNumber *number = [NSNumber numberWithInt:-1];

	return [self makeBuddyPhotoAlbum:data albumId:number];
}

- (BuddyPhotoAlbum *)makeBuddyPhotoAlbum:(NSArray *)data
								 albumId:(NSNumber *)albumId
{
	NSMutableArray *pictures = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyPicture *picture = [[BuddyPicture alloc] initPicture:client authUser:authUser
																photoList:dict];
				if (picture)
				{
					[pictures addObject:picture];
				}
			}
		}
	}

	BuddyPhotoAlbum *photoAlbum = [[BuddyPhotoAlbum alloc] initWithClient:client authUser:authUser albumId:albumId pictures:pictures];
	return photoAlbum;
}

- (void) get:(NSNumber *)albumId
	   
	callback:(BuddyPhotoAlbumsGetCallback)callback
{
	if (albumId == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyPhotoAlbums" reason:@"albumId"];
	}

	__block BuddyPhotoAlbums *_self = self;
	__block NSNumber *_albumId = albumId;

	[[client webService] Pictures_PhotoAlbum_Get:authUser.token UserProfileID:authUser.userId PhotoAlbumID:albumId 
										callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
												  {
													  if (callback)
													  {
														  BuddyPhotoAlbum *pAlbum;
														  NSException *exception;
														  @try
														  {
															  if (callbackParams.isCompleted && jsonArray != nil)
															  {
																  pAlbum = [_self makeBuddyPhotoAlbum:jsonArray albumId:_albumId];
															  }
														  }
														  @catch (NSException *ex)
														  {
															  exception = ex;
														  }

														  if (exception)
														  {
															  callback([[BuddyPhotoAlbumResponse alloc] initWithError:exception
																												
																											  apiCall:callbackParams.apiCall]);
														  }
														  else
														  {
															  callback([[BuddyPhotoAlbumResponse alloc] initWithResponse:callbackParams result:pAlbum]);
														  }
													  }
													  _self = nil;
												  } copy]];
}

- (void)getWithName:(NSString *)albumName
			  
		   callback:(BuddyPhotoAlbumsGetCallback)callback
{
	if (albumName == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyPhotoAlbums" reason:@"albumName"];
	}

	__block BuddyPhotoAlbums *_self = self;

	[[client webService] Pictures_PhotoAlbum_GetFromAlbumName:authUser.token UserProfileID:authUser.userId PhotoAlbumName:albumName 
													 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															   {
																   if (callbackParams.isCompleted && callback)
																   {
																	   if (jsonArray != nil && [jsonArray count] > 0)
																	   {
																		   NSDictionary *dict = (NSDictionary *)[jsonArray objectAtIndex:0];
																		   NSNumber *albumId = [BuddyUtility NSNumberFromStringInt:[dict objectForKey:@"albumID"]];

																		   [_self get:albumId  callback:[^(BuddyPhotoAlbumResponse *result2)
																													{
																														callback(result2);
																														_self = nil;
																													} copy]];
																	   }
																	   else
																	   {
																		   callback([[BuddyPhotoAlbumResponse alloc] initWithError:callbackParams
																															reason:callbackParams.stringResult]);
																		   _self = nil;
																	   }
																   }
																   else
																   {
																	   if (callback)
																	   {
																		   callback([[BuddyPhotoAlbumResponse alloc] initWithError:callbackParams reason:callbackParams.exception.reason]);
																	   }
																	   _self = nil;
																   }
															   } copy]];
}

- (void)getAll:(BuddyPhotoAlbumsGetAllCallback)callback
{
	[self getAll:nil  callback:callback];
}

- (void)getAll:(NSDate *)afterDate
		 
	  callback:(BuddyPhotoAlbumsGetAllCallback)callback
{
	if (afterDate == nil)
	{
		afterDate = [BuddyUtility defaultAfterDate];
	}

	NSString *afterDateString = [BuddyUtility buddyDateToString:afterDate];

	__block BuddyPhotoAlbums *_self = self;

	[[client webService] Pictures_PhotoAlbum_GetAllPictures:authUser.token UserProfileID:authUser.userId SearchFromDateTime:afterDateString 
												   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															 {
																 if (callback)
																 {
																	 NSDictionary *dict;
																	 NSException *exception;
																	 @try
																	 {
																		 if (callbackParams.isCompleted && jsonArray != nil)
																		 {
																			 dict = [_self makeBuddyPhotoAlbumDictionary:jsonArray];
																		 }
																	 }
																	 @catch (NSException *ex)
																	 {
																		 exception = ex;
																	 }

																	 if (exception)
																	 {
																		 callback([[BuddyDictionaryResponse alloc] initWithError:exception
																														   
																														 apiCall:callbackParams.apiCall]);
																	 }
																	 else
																	 {
																		 callback([[BuddyDictionaryResponse alloc] initWithResponse:callbackParams
																															 result:dict]);
																	 }
																 }
																 _self = nil;
															 } copy]];
}

@end