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
/// Represents a class that can be used to interact with virtual albums. Unlike normal photo albums any user may add existing photos to a virtual album.
/// Only the owner of the virtual album can delete the album however.
/// </summary>

@implementation BuddyVirtualAlbums

@synthesize client;
@synthesize authUser;

- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyVirtualAlbums"];

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
	  callback:(BuddyVirtualAlbumsCreateCallback)callback
{
	[self create:name appTag:nil  callback:callback];
}

- (void)create:(NSString *)name
		appTag:(NSString *)appTag
		 
	  callback:(BuddyVirtualAlbumsCreateCallback)callback
{
	__block BuddyVirtualAlbums *_self = self;

	[[client webService] Pictures_VirtualAlbum_Create:authUser.token AlbumName:name ApplicationTag:appTag RESERVED:@"" 
											 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													   {
														   if (callbackParams.isCompleted && callback)
														   {
															   if ([BuddyUtility isAStandardError:callbackParams.stringResult] == FALSE)
															   {
																   NSNumber *albumId = [NSNumber numberWithInt:[callbackParams.stringResult intValue]];

																   [_self get:albumId  callback:[^(BuddyVirtualAlbumResponse *result2)
																											{
																												callback(result2);
																												_self = nil;
																											} copy]];
															   }
															   else
															   {
																   callback([[BuddyVirtualAlbumResponse alloc] initWithError:callbackParams reason:callbackParams.stringResult]);
																   _self = nil;
															   }
														   }
														   else
														   {
															   if (callback)
															   {
																   callback([[BuddyVirtualAlbumResponse alloc] initWithError:callbackParams reason:callbackParams.exception.reason]);
															   }
															   _self = nil;
														   }
													   } copy]];
}

- (void) get:(NSNumber *)albumId
	   
	callback:(BuddyVirtualAlbumsGetCallback)callback
{
	if (albumId == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyVirtualAlbums.Get" reason:@"albumId"];
	}

	__block BuddyVirtualAlbums *_self = self;
	__block NSNumber *_albumId = albumId;

	[[client webService] Pictures_VirtualAlbum_GetAlbumInformation:authUser.token VirtualAlbumID:albumId RESERVED:@"" 
														  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																	{
																		if (callbackParams.isCompleted && callback && jsonArray != nil && [jsonArray count] > 0)
																		{
																			[_self getInternal:_albumId virtualAlbumInfo:[jsonArray objectAtIndex:0] 
                                                                                 callback:[^(BuddyVirtualAlbumResponse *result2)
                                                                                           {
                                                                                               callback(result2);
                                                                                               _self = nil;
                                                                                           } copy]];
																		}
																		else
																		{
																			if (callback)
																			{
																				if (callbackParams.isCompleted)
																				{                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 // no virtual album found for the albumId
																					callback([[BuddyVirtualAlbumResponse alloc] initWithResponse:callbackParams result:nil]);
																				}
																				else
																				{
																					callback([[BuddyVirtualAlbumResponse alloc] initWithError:callbackParams reason:(callbackParams.isCompleted) ? callbackParams.stringResult:callbackParams.exception.reason]);
																				}
																			}
																			_self = nil;
																		}
																	} copy]];
}

- (void) getInternal:(NSNumber *)albumId
	virtualAlbumInfo:(NSDictionary *)virtualAlbumInfo
			   
			callback:(void (^)(BuddyVirtualAlbumResponse *response))block
{
	if (albumId == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyVirtualAlbums" reason:@"albumId"];
	}

	__block BuddyVirtualAlbums *_self = self;

	[[client webService] Pictures_VirtualAlbum_Get:authUser.token VirtualPhotoAlbumID:albumId 
										  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													{
														if (block)
														{
															NSException *exception;
															BuddyVirtualAlbum *album;
															@try
															{
																if (callbackParams.isCompleted && jsonArray != nil && [jsonArray isKindOfClass:[NSArray class]])
																{
																	album = [[BuddyVirtualAlbum alloc] initWithAuthUser:_self.client authUser:_self.authUser virtualPhotoAlbumInfo:virtualAlbumInfo pictures:jsonArray];
																}
															}
															@catch (NSException *ex)
															{
																exception = ex;
															}

															if (exception)
															{
																block([[BuddyVirtualAlbumResponse alloc] initWithError:exception  apiCall:callbackParams.apiCall]);
															}
															else
															{
																block([[BuddyVirtualAlbumResponse alloc] initWithResponse:callbackParams result:album]);
															}
														}
														_self = nil;
													} copy]];
}

- (NSArray *)makeVirtualAlbumIdList:(NSArray *)data
{
	NSMutableArray *virtualAlbumIds = [[NSMutableArray alloc] init];

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

			NSString *virtualAlbumId = [BuddyUtility stringFromString:[dict objectForKey:@"virtualAlbumID"]];
			if ([BuddyUtility isNilOrEmpty:virtualAlbumId] || [virtualAlbumId isEqualToString:@"0"])
			{
				continue;
			}

			NSNumber *number = [BuddyUtility NSNumberFromStringInt:virtualAlbumId];
			if ([number intValue] == 0)
			{
				continue;
			}

			[virtualAlbumIds addObject:[BuddyUtility NSNumberFromStringInt:virtualAlbumId]];
		}
	}
	return virtualAlbumIds;
}

- (void)getMy:(BuddyVirtualAlbumsGetMyCallback)callback
{
	__block BuddyVirtualAlbums *_self = self;

	[[client webService] Pictures_VirtualAlbum_GetMyAlbums:authUser.token
												  RESERVED:@""
													 
												  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															{
																if (callback)
																{
																	NSArray *data;
																	NSException *exception;
																	@try
																	{
																		if (callbackParams.isCompleted && jsonArray != nil)
																		{
																			data = [_self makeVirtualAlbumIdList:jsonArray];
																		}
																	}
																	@catch (NSException *ex)
																	{
																		exception = ex;
																	}
																	if (exception)
																	{
																		callback([[BuddyArrayResponse alloc] initWithError:exception
																													 
																												   apiCall:callbackParams.apiCall]);
																	}
																	else
																	{
																		callback([[BuddyArrayResponse alloc] initWithResponse:callbackParams
																													   result:data]);
																	}
																}
																_self = nil;
															} copy]];
}

@end