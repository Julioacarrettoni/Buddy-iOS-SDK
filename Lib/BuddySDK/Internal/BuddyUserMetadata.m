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
/// Represents an object used to access and modify user metadata items. You need an AuthenticatedUser to access this class.
/// </summary>

@implementation BuddyUserMetadata

@synthesize client;
@synthesize token;

- (id)initUserMetadata:(BuddyClient *)localClient
				 token:(NSString *)localToken
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyUserMetadata"];
	[BuddyUtility checkForToken:localToken functionName:@"BuddyUserMetadata"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	token = localToken;
	client = localClient;

	return self;
}

- (void)dealloc
{
	client = nil;
	token = nil;
}

- (NSDictionary *)makeMetadataItemDictionary:(NSArray *)data
{
	return [self makeMetadataItemDictionary:data latitude:0.0 longitude:0.0];
}

- (NSDictionary *)makeMetadataItemDictionary:(NSArray *)data
									latitude:(double)latitude
								   longitude:(double)longitude
{
	NSMutableDictionary *dictMetadata = [[NSMutableDictionary alloc] init];

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

			NSString *metaKey = [BuddyUtility stringFromString:[dict objectForKey:@"metaKey"]];
			if ([BuddyUtility isNilOrEmpty:metaKey])
			{
				continue;
			}

			if ([dictMetadata objectForKey:metaKey] == nil)
			{
				BuddyMetadataItem *metaItem = [[BuddyMetadataItem alloc] initUserMetaItem:self.client userMeta:self appMetadata:nil token:self.token searchUserMetadata:dict origLatitude:latitude origLongitude:longitude];

				if (metaItem)
				{
					[dictMetadata setObject:metaItem forKey:metaKey];
				}
			}
		}
	}

	return dictMetadata;
}

- (BuddyMetadataItem *)makeMetadataItem:(NSArray *)data
{
	if (data && [data isKindOfClass:[NSArray class]] && [data count] > 0)
	{
		BuddyMetadataItem *metaItem = [[BuddyMetadataItem alloc] initUserMetaItem:self.client userMeta:self appMetadata:nil token:self.token searchUserMetadata:(NSDictionary *)[data objectAtIndex:0] origLatitude:0.0 origLongitude:0.0];

		return metaItem;
	}

	return nil;
}

- (void)getAll:(BuddyUserMetadataGetAllCallback)callback
{
	__block BuddyUserMetadata *_self = self;

	[[client webService] MetaData_UserMetaDataValue_GetAll:token 
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
																			dict = [_self makeMetadataItemDictionary:jsonArray latitude:0.0 longitude:0.0];
																		}
																	}
																	@catch (NSException *ex)
																	{
																		exception = ex;
																	}

																	if (exception)
																	{
																		callback([[BuddyDictionaryResponse alloc] initWithError:exception  apiCall:callbackParams.apiCall]);
																	}
																	else
																	{
																		callback([[BuddyDictionaryResponse alloc] initWithResponse:callbackParams result:dict]);
																	}
																}
																_self = nil;
															} copy]];
}

- (void)checkForKey:(NSString *)key
{
	if ([BuddyUtility isNilOrEmpty:key])
	{
		[BuddyUtility throwNilArgException:@"BuddyUserMetadata" reason:@"key"];
	}
}

- (void) get:(NSString *)key
	   
	callback:(BuddyUserMetadataGetCallback)callback
{
	[self checkForKey:key];

	__block BuddyUserMetadata *_self = self;

	[[client webService] MetaData_UserMetaDataValue_Get:self.token MetaKey:key 
											   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														 {
															 if (callback)
															 {
																 BuddyMetadataItem *metaItem;
																 NSException *exception;
																 @try
																 {
																	 if (callbackParams.isCompleted && jsonArray != nil)
																	 {
																		 metaItem = [_self makeMetadataItem:jsonArray];
																	 }
																 }
																 @catch (NSException *ex)
																 {
																	 exception = ex;
																 }

																 if (exception)
																 {
																	 callback([[BuddyMetadataItemResponse alloc] initWithError:exception  apiCall:callbackParams.apiCall]);
																 }
																 else
																 {
																	 callback([[BuddyMetadataItemResponse alloc] initWithResponse:callbackParams result:metaItem]);
																 }
															 }
															 _self = nil;
														 } copy]];
}

- (void) set:(NSString *)key
	   value:(NSString *)value
	callback:(BuddyUserMetadataSetCallback)callback
{
	[self set:key value:value latitude:0.0 longitude:0.0 appTag:nil  callback:callback];
}

- (void)  set:(NSString *)key
		value:(NSString *)value
	 latitude:(double)latitude
	longitude:(double)longitude
	   appTag:(NSString *)appTag
		
	 callback:(BuddyUserMetadataSetCallback)callback
{
	[self checkForKey:key];

	if (value == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyUserMetadata" reason:@"value"];
	}

	[[client webService] MetaData_UserMetaDataValue_Set:self.token MetaKey:key MetaValue:value MetaLatitude:latitude MetaLongitude:longitude ApplicationTag:appTag RESERVED:@"" 
											   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														 {
															 if (callback)
															 {
																 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
															 }
														 } copy]];
}

- (void)delete:(NSString *)key
		 
	  callback:(BuddyUserMetadataDeleteCallback)callback
{
	[self checkForKey:key];

	[[client webService] MetaData_UserMetaDataValue_Delete:self.token
												   MetaKey:key 
												  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															{
																if (callback)
																{
																	callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																}
															} copy]];
}

- (void)deleteAll:(BuddyUserMetadataDeleteAllCallback)callback
{
	[[client webService] MetaData_UserMetaDataValue_DeleteAll:self.token
														
													 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															   {
																   if (callback)
																   {
																	   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																   }
															   } copy]];
}

- (void) find:(NSNumber *)searchDistanceMeters
	 latitude:(double)latitude
	longitude:(double)longitude
	 callback:(BuddyUserMetadataFindCallback)callback
{
	[self find:searchDistanceMeters latitude:latitude longitude:longitude numberOfResults:nil withKey:nil withValue:nil updatedMinutesAgo:nil searchAsFloat:FALSE sortAscending:FALSE disableCache:TRUE  callback:callback];
}

- (void)         find:(NSNumber *)searchDistanceMeters
			 latitude:(double)latitude
			longitude:(double)longitude
	  numberOfResults:(NSNumber *)numberOfResults
			  withKey:(NSString *)withKey
			withValue:(NSString *)withValue
	updatedMinutesAgo:(NSNumber *)updatedMinutesAgo
		searchAsFloat:(BOOL)searchAsFloat
		sortAscending:(BOOL)sortAscending
		 disableCache:(BOOL)disableCache
				
			 callback:(BuddyUserMetadataFindCallback)callback
{
	if (searchDistanceMeters == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyUserMetadata" reason:@"searchDistanceMeters"];
	}

	if (numberOfResults == nil)
	{
		numberOfResults = [NSNumber numberWithInt:10];
	}

	if (updatedMinutesAgo == nil)
	{
		updatedMinutesAgo = [NSNumber numberWithInt:-1];
	}

	NSString *updateTime = [NSString stringWithFormat:@"%d", [updatedMinutesAgo intValue]];
	NSNumber *searchAsFloatInt = [NSNumber numberWithInt:(searchAsFloat == TRUE) ? 1:0];
	NSNumber *sortAscendingInt = [NSNumber numberWithInt:(sortAscending == TRUE) ? 1:0];
	NSString *disableCacheString = [NSString stringWithString:(disableCache == TRUE) ? @"true":@""];

	__block BuddyUserMetadata *_self = self;

	[[client webService] MetaData_UserMetaDataValue_Search:self.token SearchDistance:searchDistanceMeters Latitude:latitude Longitude:longitude RecordLimit:numberOfResults MetaKeySearch:withKey MetaValueSearch:withValue TimeFilter:updateTime SortValueAsFloat:searchAsFloatInt SortDirection:sortAscendingInt DisableCache:disableCacheInt 
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
																			dict = [_self makeMetadataItemDictionary:jsonArray
																											latitude:latitude
																										   longitude:longitude];
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

- (void) sum:(NSString *)forKeys
	callback:(BuddyUserMetadataSumCallback)callback
{
	[self sum:forKeys withinDistance:nil latitude:0.0 longitude:0.0 updatedMinutesAgo:nil withAppTag:nil  callback:callback];
}

- (void)          sum:(NSString *)forKeys
	   withinDistance:(NSNumber *)withinDistance
			 latitude:(double)latitude
			longitude:(double)longitude
	updatedMinutesAgo:(NSNumber *)updatedMinutesAgo
		   withAppTag:(NSString *)appTag
				
			 callback:(BuddyUserMetadataSumCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:forKeys])
	{
		[BuddyUtility throwNilArgException:@"BuddyUserMetadata" reason:@"forKeys"];
	}

	if (withinDistance == nil)
	{
		withinDistance = [NSNumber numberWithInt:-1];
	}

	if (updatedMinutesAgo == nil)
	{
		updatedMinutesAgo = [NSNumber numberWithInt:-1];
	}

	NSString *updateTime = [NSString stringWithFormat:@"%d", [updatedMinutesAgo intValue]];
	__block NSString *_forKeys = forKeys;

	[[client webService] MetaData_UserMetaDataValue_Sum:self.token MetaKey:forKeys SearchDistance:withinDistance Latitude:latitude Longitude:longitude TimeFilter:updateTime ApplicationTag:appTag RESERVED:@"" 
											   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														 {
															 if (callback)
															 {
																 BuddyMetadataSum *metaSum;
																 NSException *exception;
																 @try
																 {
																	 if (callbackParams.isCompleted && jsonArray != nil)
																	 {
																		 if ([jsonArray isKindOfClass:[NSArray class]] && [jsonArray count] > 0)
																		 {
																			 NSString *keysString = [[NSString alloc] initWithString:_forKeys];
																			 metaSum = [[BuddyMetadataSum alloc]
												  initMetadataSum:[jsonArray objectAtIndex:0] keyName:keysString];
																		 }
																	 }
																 }
																 @catch (NSException *ex)
																 {
																	 exception = ex;
																 }

																 if (exception)
																 {
																	 callback([[BuddyMetadataSumResponse alloc] initWithError:exception
																														
																													  apiCall:callbackParams.apiCall]);
																 }
																 else
																 {
																	 callback([[BuddyMetadataSumResponse alloc] initWithResponse:callbackParams
																														  result:metaSum]);
																 }
															 }

															 _forKeys = nil;
														 } copy]];
}

- (NSArray *)makeMetadataSumArray:(NSArray *)data
{
	NSMutableArray *metaSumArray = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int count = (int)[data count];
		for (int i = 0; i < count; i++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)i];
			if (dict && [dict count] > 0)
			{
				BuddyMetadataSum *metaSum = [[BuddyMetadataSum alloc] initMetadataSum:dict];
				if (metaSum)
				{
					[metaSumArray addObject:metaSum];
				}
			}
		}
	}
	return metaSumArray;
}

- (void)batchSum:(NSString *)forKeys
		callback:(BuddyUserMetadataBatchSumCallback)callback
{
	[self batchSum:forKeys withinDistance:nil latitude:0.0 longitude:0.0 updatedMinutesAgo:nil withAppTag:nil  callback:callback];
}

- (void)     batchSum:(NSString *)forKeys
	   withinDistance:(NSString *)withinDistance
			 latitude:(double)latitude
			longitude:(double)longitude
	updatedMinutesAgo:(NSNumber *)updatedMinutesAgo
		   withAppTag:(NSString *)appTag
				
			 callback:(BuddyUserMetadataBatchSumCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:forKeys])
	{
		[BuddyUtility throwNilArgException:@"BuddyUserMetadata" reason:@"forKeys"];
	}

	if (withinDistance == nil)
	{
		withinDistance = @"-1";
	}

	if (updatedMinutesAgo == nil)
	{
		updatedMinutesAgo = [NSNumber numberWithInt:-1];
	}

	NSMutableString *withinDistanceString;
	if ([withinDistance isEqualToString:@"-1"])
	{
		NSArray *withinDistanceArray = [forKeys componentsSeparatedByString:@";"];

		withinDistanceString = [NSMutableString stringWithString:@"-1"];
		if ([withinDistanceArray count] > 1)
		{
			int j = (int)([withinDistanceArray count] - 1);
			for (int i = 0; i < j; i++)
			{
				[withinDistanceString appendString:@";-1"];
			}
		}
	}
	else
	{
		withinDistanceString = [NSMutableString stringWithString:withinDistance];
	}

	NSString *timeValue = [NSString stringWithFormat:@"%d", [updatedMinutesAgo intValue]];

	__block BuddyUserMetadata *_self = self;

	[[client webService] MetaData_UserMetaDataValue_BatchSum:self.token UserMetaKeyCollection:forKeys SearchDistanceCollection:withinDistanceString Latitude:latitude Longitude:longitude TimeFilter:timeValue ApplicationTag:appTag RESERVED:@"" 
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
																			  data = [_self makeMetadataSumArray:jsonArray];
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

- (void)batchSet:(NSString *)keys
		  values:(NSString *)values
		callback:(BuddyUserMetadataBatchSetCallback)callback
{
	[self batchSet:keys values:values latitude:0.0 longitude:0.0 appTag:nil state:nil callback:callback];
}

- (void)batchSet:(NSString *)keys
		  values:(NSString *)values
		latitude:(double)latitude
	   longitude:(double)longitude
		  appTag:(NSString *)appTag
		   state:(NSObject *)state
		callback:(BuddyUserMetadataBatchSetCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:keys])
	{
		[BuddyUtility throwNilArgException:@"BuddyUserMetadata" reason:@"keys"];
	}

	if ([BuddyUtility isNilOrEmpty:values])
	{
		[BuddyUtility throwNilArgException:@"BuddyUserMetadata" reason:@"values"];
	}

	[[client webService] MetaData_UserMetaDataValue_BatchSet:self.token UserMetaKeyCollection:keys UserMetaValueCollection:values MetaLatitude:latitude MetaLongitude:longitude ApplicationTag:appTag RESERVED:@"" state:state
													callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															  {
																  if (callback)
																  {
																	  callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																  }
															  } copy]];
}

@end
