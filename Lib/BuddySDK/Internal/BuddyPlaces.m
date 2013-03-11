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
/// Represents an object that can be used to search for physical locations around the user.
/// </summary>

@implementation BuddyPlaces

@synthesize client;
@synthesize authUser;

- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyPlaces"];

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

- (void) find:(NSNumber *)searchDistanceInMeters
	 latitude:(double)latitude
	longitude:(double)longitude
	 callback:(BuddyPlacesFindCallback)callback
{
	NSNumber *numberOfResults = [NSNumber numberWithInt:100];
	NSNumber *searchCategoryId = [NSNumber numberWithInt:-1];

	[self find:searchDistanceInMeters latitude:latitude longitude:longitude numberOfResults:numberOfResults searchForName:@"" searchCategoryId:searchCategoryId state:nil callback:callback];
}

- (void)        find:(NSNumber *)searchDistanceInMeters
			latitude:(double)latitude
		   longitude:(double)longitude
	 numberOfResults:(NSNumber *)numberOfResults
	   searchForName:(NSString *)searchForName
	searchCategoryId:(NSNumber *)searchCategoryId
			   state:(NSObject *)state
			callback:(BuddyPlacesFindCallback)callback
{
	[self checkNSNumber:searchDistanceInMeters reason:@"searchDistanceInMeters can't be smaller or equal to zero."];

	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyPlaces"];

	if (!numberOfResults || [numberOfResults intValue] == 0)
	{
		numberOfResults = [NSNumber numberWithInt:10];
	}

	NSString *categoryId = @"";
	if (searchCategoryId != nil && [searchCategoryId intValue] != -1)
	{
		categoryId = [searchCategoryId stringValue];
	}

	__block BuddyPlaces *_self = self;

	[[client webService] GeoLocation_Location_Search:authUser.token SearchDistance:searchDistanceInMeters Latitude:latitude Longitude:longitude RecordLimit:numberOfResults SearchName:searchForName SearchCategoryID:categoryId state:state
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
																	  data = [_self makeBuddyPlaceList:jsonArray];
																  }
															  }
															  @catch (NSException *ex)
															  {
																  exception = ex;
															  }

															  if (exception)
															  {
																  callback([[BuddyArrayResponse alloc] initWithError:exception
																											   state:callbackParams.state
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

- (NSArray *)makeBuddyPlaceList:(NSArray *)data
{
	NSMutableArray *places = [[NSMutableArray alloc] init];

	if (data != nil && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict != nil && [dict count] > 0)
			{
				BuddyPlace *place = [[BuddyPlace alloc] initPlace:client authUser:authUser placeDetails:dict];
				if (place)
				{
					[places addObject:place];
				}
			}
		}
	}

	return places;
}

- (BuddyPlace *)makeBuddyPlace:(NSArray *)data
{
	if (data && [data isKindOfClass:[NSArray class]] && [data count] > 0)
	{
		NSDictionary *dict = (NSDictionary *)[data objectAtIndex:0];
		if (dict != nil && [dict count] > 0)
		{
			BuddyPlace *place = [[BuddyPlace alloc] initPlace:client authUser:authUser placeDetails:dict];
			return place;
		}
	}
	return nil;
}

- (NSDictionary *)makeCategoryDictionary:(NSArray *)data
{
	NSMutableDictionary *dictCategory = [[NSMutableDictionary alloc] init];

	if (data != nil && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict != nil && [dict count] > 0)
			{
				NSString *categoryId = [BuddyUtility stringFromString:[dict objectForKey:@"categoryID"]];
				NSString *categoryName = [BuddyUtility stringFromString:[dict objectForKey:@"categoryName"]];
				if (![BuddyUtility isNilOrEmpty:categoryId] && categoryName != nil)
				{
					[dictCategory setObject:categoryName forKey:categoryId];
				}
			}
		}
	}

	return dictCategory;
}

- (void)getCategories:(NSObject *)state
			 callback:(BuddyPlacesGetCategoriesCallback)block
{
	__block BuddyPlaces *_self = self;

	[[client webService] GeoLocation_Category_GetList:authUser.token state:state
											 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													   {
														   if (block)
														   {
															   NSDictionary *dict;
															   NSException *exception;
															   @try
															   {
																   if (callbackParams.isCompleted && jsonArray != nil)
																   {
																	   dict = [_self makeCategoryDictionary:jsonArray];
																   }
															   }
															   @catch (NSException *ex)
															   {
																   exception = ex;
															   }

															   if (exception)
															   {
																   block([[BuddyDictionaryResponse alloc] initWithError:exception
																												  state:callbackParams.state
																												apiCall:callbackParams.apiCall]);
															   }
															   else
															   {
																   block([[BuddyDictionaryResponse alloc] initWithResponse:callbackParams
																													result:dict]);
															   }
														   }
														   _self = nil;
													   } copy]];
}

- (void) get:(NSNumber *)placeId
	callback:(BuddyPlacesGetCallback)callback
{
	[self get:placeId latitude:0.0 longitude:0.0 state:nil callback:callback];
}

- (void)  get:(NSNumber *)placeId
	 latitude:(double)latitude
	longitude:(double)longitude
		state:(NSObject *)state
	 callback:(BuddyPlacesGetCallback)callback
{
	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyPlaces"];

	__block BuddyPlaces *_self = self;

	[[client webService] GeoLocation_Location_GetFromID:authUser.token ExistingGeoID:placeId Latitude:latitude Longitude:longitude RESERVED:@"" state:state
											   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														 {
															 if (callback)
															 {
																 BuddyPlace *place;
																 NSException *exception;
																 @try
																 {
																	 if (callbackParams.isCompleted && jsonArray != nil)
																	 {
																		 place = [_self makeBuddyPlace:jsonArray];
																	 }
																 }
																 @catch (NSException *ex)
																 {
																	 exception = ex;
																 }

																 if (exception)
																 {
																	 callback([[BuddyPlaceResponse alloc] initWithError:exception state:callbackParams.state apiCall:callbackParams.apiCall]);
																 }
																 else
																 {
																	 callback([[BuddyPlaceResponse alloc] initWithResponse:callbackParams result:place]);
																 }
															 }
															 _self = nil;
														 } copy]];
}

- (void)checkNSNumber:(NSNumber *)number reason:(NSString *)reason
{
	if (number == nil || [number intValue] <= 0)
	{
		@throw [NSException exceptionWithName:@"BuddyPlaces" reason:reason userInfo:nil];
	}
}

@end