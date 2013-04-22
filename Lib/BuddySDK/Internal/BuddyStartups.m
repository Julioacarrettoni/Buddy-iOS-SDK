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

@implementation BuddyStartups

@synthesize client;
@synthesize authUser;

- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyStartups"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	authUser = localAuthUser;

	return self;
}

- (NSArray *)makeBuddyStartupList:(NSArray *)data
{
	NSMutableArray *startupArray = [[NSMutableArray alloc] init];

	if (data != nil && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict != nil && [dict count] > 0)
			{
				BuddyStartup *startup = [[BuddyStartup alloc] initStartup:client authUser:authUser startupDetails:dict];
				if (startup)
				{
					[startupArray addObject:startup];
				}
			}
		}
	}

	return startupArray;
}

- (NSArray *)makeBuddyMetroAreaList:(NSArray *)data
{
	NSMutableArray *metroAreaArray = [[NSMutableArray alloc] init];

	if (data != nil && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict != nil && [dict count] > 0)
			{
				BuddyMetroArea *metroArea = [[BuddyMetroArea alloc] initMetroArea:client authUser:authUser metroAreaDetails:dict];
				if (metroArea)
				{
					[metroAreaArray addObject:metroArea];
				}
			}
		}
	}

	return metroAreaArray;
}

- (void)       find:(NSNumber *)searchDistanceInMeters
		   latitude:(double)latitude
		  longitude:(double)longitude
	numberOfResults:(NSNumber *)numberOfResults
	  searchForName:(NSString *)searchForName
			  state:(NSObject *)state
		   callback:(BuddyStartupsFindCallback)callback
{
	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyStartups"];

	if (searchDistanceInMeters == nil || [searchDistanceInMeters intValue]  < 0)
	{
		[BuddyUtility throwNilArgException:@"BuddyStartups" reason:@"searchDistanceMeters"];
	}

	if (numberOfResults == nil || [numberOfResults intValue]  < 0)
	{
		[BuddyUtility throwNilArgException:@"BuddyStartups" reason:@"numberOfResults"];
	}

	__block BuddyStartups *_self = self;

	NSString *distance = [searchDistanceInMeters stringValue];

	[[client webService] StartupData_Location_Search:authUser.token SearchDistance:distance Latitude:latitude Longitude:longitude RecordLimit:numberOfResults SearchName:searchForName state:state
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
																	  data = [_self makeBuddyStartupList:jsonArray];
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
													  } copy] ];
}

- (void)       find:(NSNumber *)searchDistanceInMeters
		   latitude:(double)latitude
		  longitude:(double)longitude
	numberOfResults:(NSNumber *)numberOfResults
		   callback:(BuddyStartupsFindCallback)callback
{
	[self find:searchDistanceInMeters latitude:latitude longitude:longitude numberOfResults:numberOfResults searchForName:nil state:nil callback:callback];
}

- (void)getMetroAreaList:(NSObject *)state
				callback:(BuddyStartupsGetMetroAreaListCallback)callback
{
	__block BuddyStartups *_self = self;

	[[client webService] StartupData_Location_GetMetroList:state
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
																			data = [_self makeBuddyMetroAreaList:jsonArray];
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
															} copy] ];
}

- (void)getFromMetroArea:(NSString *)metroName
			 recordLimit:(int)recordLimit
				   state:(NSObject *)state
				callback:(BuddyStartupsGetFromMetroAreaCallback)callback
{
	[BuddyUtility checkNameParam:metroName functionName:@"BuddyStartups"];

	if (recordLimit < 0)
	{
		[NSException raise:NSInvalidArgumentException format:@"%@: %@ can't be smaller than zero.", @"BuddyStartups", @"recordLimit"];
	}

	__block BuddyStartups *_self = self;

	[[client webService] StartupData_Location_GetFromMetroArea:authUser.token MetroName:metroName RecordLimit:recordLimit state:state
													  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																{
																	NSArray *data;
																	NSException *exception;
																	@try
																	{
																		if (callbackParams.isCompleted && jsonArray != nil)
																		{
																			data = [_self makeBuddyStartupList:jsonArray];
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

																	_self = nil;
																} copy] ];
}

@end
