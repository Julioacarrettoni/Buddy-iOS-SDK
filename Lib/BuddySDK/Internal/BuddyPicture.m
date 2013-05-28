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

#import "BuddyClient.h"
#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"


/// <summary>
/// Represents a single picture on the Buddy Platform. Pictures can be accessed through an AuthenticatedUser, either by using the photoAlbums property to retrieve
/// pictures that belong to the user, or using the SearchForAlbums method to find public pictures.
/// </summary>

@implementation BuddyPicture

@synthesize authUser;

- (void)dealloc
{
	authUser = nil;
}

- (id)initPicture:(BuddyClient *)client
		 authUser:(BuddyAuthenticatedUser *)localAuthUser
		photoList:(NSDictionary *)data;
{
	[BuddyUtility checkForNilClient:client name:@"BuddyPicture"];

	if (data == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyPicture" reason:@"Photolist"];
	}

	self = [super initPicturePublic:client
							fullUrl:[BuddyUtility stringFromString:[data objectForKey:@"fullPhotoURL"]]
					   thumbnailUrl:[BuddyUtility stringFromString:[data objectForKey:@"thumbnailPhotoURL"]]
						   latitude:[BuddyUtility doubleFromString:[data objectForKey:@"latitude"]]
						  longitude:[BuddyUtility doubleFromString:[data objectForKey:@"longitude"]]
							comment:[BuddyUtility stringFromString:[data objectForKey:@"photoComment"]]
							 appTag:[BuddyUtility stringFromString:[data objectForKey:@"applicationTag"]]
							addedOn:[BuddyUtility dateFromString:[data objectForKey:@"photoAdded"]]
							photoId:[BuddyUtility NSNumberFromStringInt:[data objectForKey:@"photoID"]]
							   user:(BuddyUser *)localAuthUser];
	if (!self)
	{
		return nil;
	}

	authUser = localAuthUser;

	return self;
}

- (NSDictionary *)makeFilterDictionary:(NSArray *)data
{
	NSMutableDictionary *dictOut = [[NSMutableDictionary alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				NSString *filterName = [dict objectForKey:@"filterName"];
				NSString *parameterList = [dict objectForKey:@"parameterList"];

				if (![BuddyUtility isNilOrEmpty:filterName] && parameterList != nil)
				{
					[dictOut setObject:parameterList forKey:filterName];
				}
				else
				{
					if (![BuddyUtility isNilOrEmpty:filterName])
					{
						[dictOut setObject:@"" forKey:filterName];
					}
				}
			}
		}
	}

	return dictOut;
}

- (void)supportedFilters:(BuddyPictureSupportedFiltersCallback)callback
{
	__block BuddyPicture *_self = self;

	[[self.client webService] Pictures_Filters_GetList:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														{
															if (callback)
															{
																NSDictionary *dict;
																NSException *exception;
																@try
																{
																	if (callbackParams.isCompleted && jsonArray != nil)
																	{
																		dict = [_self makeFilterDictionary:jsonArray];
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

- (void)delete:(BuddyPictureDeleteCallback)callback
{
	[BuddyUtility checkForToken:authUser.token functionName:@"BuddyPicture"];

	[[self.client webService] Pictures_Photo_Delete:authUser.token PhotoAlbumPhotoID:self.photoId 
										   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray) {
														 if (callback)
														 {
															 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
														 }
													 } copy]];
}

- (void)applyFilter:(NSString *)filterName
	   filterParams:(NSString *)filterParams
			  
		   callback:(BuddyPictureApplyFilterCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:filterName])
	{
		[BuddyUtility throwNilArgException:@"BuddyPicture" reason:@"filtername"];
	}

	NSNumber *photoReplace = [NSNumber numberWithInt:0];

	__block BuddyPicture *_self = self;

	[[self.client webService] Pictures_Filters_ApplyFilter:authUser.token ExistingPhotoID:self.photoId FilterName:filterName FilterParameters:filterParams ReplacePhoto:photoReplace 
												  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray) {
																if (callbackParams.isCompleted && callback)
																{
																	NSString *dataResult = callbackParams.stringResult;
																	if (dataResult != nil && [BuddyUtility isAStandardError:dataResult] == FALSE)
																	{
																		NSNumber *picID = [NSNumber numberWithInt:[dataResult intValue]];
																		[_self.authUser getPicture:picID  callback:callback];
																	}
																	else
																	{
																		callback([[BuddyPictureResponse alloc] initWithError:callbackParams reason:dataResult]);
																	}
																}
																else
																{
																	if (callback)
																	{
																		callback([[BuddyPictureResponse alloc] initWithError:callbackParams reason:callbackParams.exception.reason]);
																	}
																}
																_self = nil;
															} copy]];
}

- (void)setAppTag:(NSString *)appTag
			
		 callback:(BuddyPictureSetAppTagCallback)callback
{
	[[self.client webService] Pictures_Photo_SetAppTag:authUser.token PhotoAlbumPhotoID:self.photoId
										ApplicationTag:appTag
												 
											  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray) {
															if (callback)
															{
																callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
															}
														} copy]];
}

@end
