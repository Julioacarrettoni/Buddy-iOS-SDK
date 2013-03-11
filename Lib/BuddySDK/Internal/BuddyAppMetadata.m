
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
/// Represents a collection of application level metadata items. You can access this class through the BuddyClient object.
/// </summary>

@implementation BuddyAppMetadata

@synthesize client;

- (id)initWithClient:(BuddyClient *)localClient
{
    [BuddyUtility checkForNilClient:localClient name:@"BuddyAppMetadata"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;

	return self;
}

- (void)dealloc
{
	client = nil;
}

- (NSDictionary *)makeMetadataItemDictionary:(NSArray *)data
{
	return [self makeMetadataItemDictionary:data latitude:0.0 longitude:0.0];
}

- (NSDictionary *)makeMetadataItemDictionary:(NSArray *)data latitude:(double)latitude longitude:(double)longitude
{
	NSMutableDictionary *dictMetadataItems = [[NSMutableDictionary alloc] init];

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

			if ([dictMetadataItems objectForKey:metaKey] == nil)
			{
				BuddyMetadataItem *metaItem = [[BuddyMetadataItem alloc] initAppMetaItem:self.client
																				userMeta:nil
																			 appMetadata:self
																				   token:nil
																	   searchAppMetadata:dict
																			origLatitude:latitude
																		   origLongitude:longitude];
				if (metaItem)
				{
					[dictMetadataItems setObject:metaItem forKey:metaKey];
				}
			}
		}
	}

	return dictMetadataItems;
}

- (BuddyMetadataItem *)makeMetadataItem:(NSArray *)data
{
	if (data && [data isKindOfClass:[NSArray class]] && [data count] > 0)
	{
		BuddyMetadataItem *metaItem = [[BuddyMetadataItem alloc] initAppMetaItem:self.client
																		userMeta:nil
																	 appMetadata:self
																		   token:nil
															   searchAppMetadata:(NSDictionary *)[data objectAtIndex:0]
																	origLatitude:0.0
																   origLongitude:0.0];

		return metaItem;
	}

	return nil;
}

- (void)getAll:(NSObject *)state
      callback:(BuddyAppMetadataGetAllCallback)callback
{
	__block BuddyAppMetadata *_self = self;

	[[client webService] MetaData_ApplicationMetaDataValue_GetAll:state
														 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																   {
																	   if (callback)
																	   {
																		   NSDictionary *dictMetaItems;
																		   NSException *exception;
																		   @try
																		   {
																			   if (callbackParams.isCompleted && jsonArray != nil)
																			   {
																				   dictMetaItems = [_self makeMetadataItemDictionary:jsonArray latitude:0.0 longitude:0.0];
																			   }
																		   }
																		   @catch (NSException *ex)
																		   {
																			   exception = ex;
																		   }

																		   if (exception)
																		   {
																			   callback([[BuddyDictionaryResponse alloc] initWithError:exception state:callbackParams.state apiCall:callbackParams.apiCall]);
																		   }
																		   else
																		   {
																			   callback([[BuddyDictionaryResponse alloc] initWithResponse:callbackParams result:dictMetaItems]);
																		   }
																	   }
																	   _self = nil;
																   } copy]];
}

- (void)checkForKey:(NSString *)key
{
	if ([BuddyUtility isNilOrEmpty:key])
	{
		[BuddyUtility throwNilArgException:@"BuddyAppMetadata" reason:@"key"];
	}
}

- (void)checkForValue:(NSString *)value
{
	if ([BuddyUtility isNilOrEmpty:value])
	{
		[BuddyUtility throwNilArgException:@"BuddyAppMetadata" reason:@"value"];
	}
}

- (void)get:(NSString *)key
      state:(NSObject *)state
   callback:(BuddyAppMetadataGetCallback)callback
{
	[self checkForKey:key];

	__block BuddyAppMetadata *_self = self;

	[[client webService] MetaData_ApplicationMetaDataValue_Get:key state:state
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
																			callback([[BuddyMetadataItemResponse alloc] initWithError:exception state:callbackParams.state apiCall:callbackParams.apiCall]);
																		}
																		else
																		{
																			callback([[BuddyMetadataItemResponse alloc] initWithResponse:callbackParams result:metaItem]);
																		}
																	}
																	_self = nil;
																} copy]];
}

- (void)set:(NSString *)key
      value:(NSString *)value
   callback:(BuddyAppMetadataSetCallback)callback
{
    [self set:key value:value latitude:0.0 longitude:0.0 appTag:nil state:nil callback:callback];
}

- (void)set:(NSString *)key
      value:(NSString *)value
   latitude:(double)latitude
  longitude:(double)longitude
     appTag:(NSString *)appTag
      state:(NSObject *)state
   callback:(BuddyAppMetadataSetCallback)callback
{
	[self checkForKey:key];
	[self checkForValue:value];

	[[client webService] MetaData_ApplicationMetaDataValue_Set:key SocketMetaValue:value MetaLatitude:latitude MetaLongitude:longitude ApplicationTag:appTag RESERVED:@"" state:state
													  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																{
																	if (callback)
																	{
																		callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																	}
																} copy]];
}

- (void)delete:(NSString *)key
         state:(NSObject *)state
      callback:(BuddyAppMetadataDeleteCallback)callback
{
	[self checkForKey:key];

	[[client webService] MetaData_ApplicationMetaDataValue_Delete:key state:state
														 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																   {
																	   if (callback)
																	   {
																		   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																	   }
																   } copy]];
}

- (void)deleteAll:(NSObject *)state
         callback:(BuddyAppMetadataDeleteAllCallback)callback
{
	[[client webService] MetaData_ApplicationMetaDataValue_DeleteAll:state
															callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																	  {
																		  if (callback)
																		  {
																			  callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																		  }
																	  } copy]];
}

- (void)find:(NSNumber *)searchDistanceMeters
    latitude:(double)latitude
   longitude:(double)longitude
    callback:(BuddyAppMetadataFindCallback)callback
{
    [self find:searchDistanceMeters latitude:latitude longitude:longitude numberOfResults:nil withKey:nil withValue:nil updatedMinutesAgo:nil valueMin:nil valueMax:nil searchAsFloat:FALSE sortAscending:TRUE disableCache:TRUE state:nil callback:callback];
}

- (void)find:(NSNumber *)searchDistanceMeters
    latitude:(double)latitude
      longitude:(double)longitude
numberOfResults:(NSNumber *)numberOfResults
        withKey:(NSString *)withKey
        withValue:(NSString *)withValue
updatedMinutesAgo:(NSNumber *)updatedMinutesAgo
         valueMin:(NSNumber *)valueMin
         valueMax:(NSNumber *)valueMax
    searchAsFloat:(BOOL)searchAsFloat
    sortAscending:(BOOL)sortAscending
     disableCache:(BOOL)disableCache
            state:(NSObject *)state
         callback:(BuddyAppMetadataFindCallback)callback
{
	if (searchDistanceMeters == nil)
	{
		[BuddyUtility throwNilArgException:@"BuddyAppMetadata" reason:@"searchDistanceMeters"];
	}

	if (numberOfResults == nil)
	{
		numberOfResults = [NSNumber numberWithInt:10];
	}

	if (updatedMinutesAgo == nil)
	{
		updatedMinutesAgo = [NSNumber numberWithInt:-1];
	}

	if (valueMax == nil)
	{
		valueMax = [NSNumber numberWithInt:100];
	}

	if (valueMin == nil)
	{
		valueMin = [NSNumber numberWithInt:0];
	}

	NSString *search = [NSString stringWithFormat:@"%d", [searchDistanceMeters intValue]];
	NSString *updateTime = [NSString stringWithFormat:@"%d", [updatedMinutesAgo intValue]];
	NSNumber *searchAsFloatInt = [NSNumber numberWithInt:(searchAsFloat  == TRUE) ? 1:0];
	NSString *sortAscendingString = [NSString stringWithString:(sortAscending == TRUE) ? @"1":@"0"];
	NSString *disableCacheString = [NSString stringWithString:(disableCache  == TRUE) ? @"1":@"0"];

	__block BuddyAppMetadata *_self = self;
	__block double _latitude = latitude;
	__block double _longitude = longitude;

	[[client webService] MetaData_ApplicationMetaDataValue_SearchData:search Latitude:latitude Longitude:longitude RecordLimit:numberOfResults MetaKeySearch:withKey MetaValueSearch:withValue TimeFilter:updateTime MetaValueMin:valueMin MetaValueMax:valueMax SearchAsFloat:searchAsFloatInt SortResultsDirection:sortAscendingString DisableCache:disableCacheString state:state
															 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																	   {
																		   if (callback)
																		   {
																			   NSDictionary *dictMetaItems;
																			   NSException *exception;

																			   @try
																			   {
																				   if (callbackParams.isCompleted && jsonArray != nil)
																				   {
																					   dictMetaItems = [_self makeMetadataItemDictionary:jsonArray
                                                                                                                                latitude:_latitude
                                                                                                                               longitude:_longitude];
																				   }
																			   }
																			   @catch (NSException *ex)
																			   {
																				   exception = ex;
																			   }

																			   if (exception)
																			   {
																				   callback([[BuddyDictionaryResponse alloc] initWithError:exception state:callbackParams.state apiCall:callbackParams.apiCall]);
																			   }
																			   else
																			   {
																				   callback([[BuddyDictionaryResponse alloc] initWithResponse:callbackParams result:dictMetaItems]);
																			   }
																		   }
																		   _self = nil;
																	   } copy]];
}

- (void)sum:(NSString *)forKeys
   callback:(BuddyAppMetadataSumCallback)callback
{
    [self sum:forKeys withinDistance:nil latitude:0.0 longitude:0.0 updatedMinutesAgo:nil withAppTag:nil state:nil callback:callback];
}

- (void)   sum:(NSString *)forKeys
withinDistance:(NSNumber *)withinDistance
      latitude:(double)latitude
        longitude:(double)longitude
updatedMinutesAgo:(NSNumber *)updatedMinutesAgo
       withAppTag:(NSString *)appTag
            state:(NSObject *)state
         callback:(BuddyAppMetadataSumCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:forKeys])
	{
		[BuddyUtility throwNilArgException:@"BuddyAppMetadata" reason:@"forKeys"];
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
	NSString *searchDistance = [NSString stringWithFormat:@"%d", [withinDistance intValue]];

	__block NSString *_forKeys = forKeys;

	[[client webService] MetaData_ApplicationMetaDataValue_Sum:forKeys SearchDistance:searchDistance Latitude:latitude Longitude:longitude TimeFilter:updateTime ApplicationTag:appTag RESERVED:@"" state:state
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
																					NSString *forKeysString = [[NSString alloc] initWithString:_forKeys];
																					metaSum = [[BuddyMetadataSum alloc] initMetadataSum:[jsonArray objectAtIndex:0]
																																keyName:forKeysString];
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
                                                                                                                               state:callbackParams.state
                                                                                                                             apiCall:callbackParams.apiCall]);
																		}
																		else
																		{
																			callback([[BuddyMetadataSumResponse alloc] initWithResponse:callbackParams result:metaSum]);
																		}
																	}
																	_forKeys = nil;
																} copy]];
}

- (NSArray *)makeMetadataSumArray:(NSArray *)data
{
	NSMutableArray *metaSumArray =  [[NSMutableArray alloc] init];

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
        callback:(BuddyAppMetadataBatchSumCallback)callback
{
    [self batchSum:forKeys withinDistance:nil latitude:0.0 longitude:0.0 updatedMinutesAgo:nil withAppTag:nil state:nil callback:callback];
}

- (void)batchSum:(NSString *)forKeys
  withinDistance:(NSString *)withinDistance
        latitude:(double)latitude
        longitude:(double)longitude
updatedMinutesAgo:(NSNumber *)updatedMinutesAgo
       withAppTag:(NSString *)appTag
            state:(NSObject *)state
         callback:(BuddyAppMetadataBatchSumCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:forKeys])
	{
		[BuddyUtility throwNilArgException:@"BuddyAppMetadata" reason:@"forKeys"];
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
		NSArray *arrayString = [forKeys componentsSeparatedByString:@";"];

        withinDistanceString = [NSMutableString stringWithString:@"-1"];
		int j = (int)([arrayString count] - 1);
		for (int i = 0; i < j; i++)
		{
			[withinDistanceString appendString:@";-1"];
		}
	}
	else
	{
        withinDistanceString = [NSMutableString stringWithString:withinDistance];
	}

	__block BuddyAppMetadata *_self = self;

	[[client webService] MetaData_ApplicationMetaDataValue_BatchSum:forKeys SearchDistanceCollection:withinDistanceString Latitude:latitude Longitude:longitude TimeFilter:updatedMinutesAgo ApplicationTag:appTag RESERVED:@"" state:state
														   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																	 {
																		 if (callback)
																		 {
																			 NSException *exception;
																			 NSArray *data;
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

@end