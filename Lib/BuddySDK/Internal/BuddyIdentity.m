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
/// Represents a class that can access identity values for a user or search for values across the entire app. Identity values can be used to share public
/// information between users, for example hashes of email address that can be used to check whether a certain user is in the system.
/// </summary>

@implementation BuddyIdentity

@synthesize client;
@synthesize token;

- (id)initIdentity:(BuddyClient *)localClient
			 token:(NSString *)localToken
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyIdentity"];
	[BuddyUtility checkForToken:localToken functionName:@"BuddyIdentity"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	token = localToken;

	return self;
}

- (void)dealloc
{
	client = nil;
	token = nil;
}

- (NSArray *)makeIdentitySearchList:(NSArray *)data
{
	NSMutableArray *identitySearchList = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyIdentityItemSearchResult *idItem = [[BuddyIdentityItemSearchResult alloc] initSearchItem:dict];
				if (idItem)
				{
					[identitySearchList addObject:idItem];
				}
			}
		}
	}
	return identitySearchList;
}

- (NSArray *)makeIdentityList:(NSArray *)data
{
	NSMutableArray *identityList = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyIdentityItem *idItem = [[BuddyIdentityItem alloc] initIdentityItem:dict];
				if (idItem)
				{
					[identityList addObject:idItem];
				}
			}
		}
	}
	return identityList;
}

- (void)getAll:(BuddyIdentityGetAllCallback)callback
{
	__block BuddyIdentity *_self = self;

	[[client webService] UserAccount_Identity_GetMyList:token RESERVED:@"" 
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
																		 data = [_self makeIdentityList:jsonArray];
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

- (void)checkForNilValue:(NSString *)value
{
	if ([BuddyUtility isNilOrEmpty:value])
	{
		[BuddyUtility throwNilArgException:@"BuddyIdentity" reason:@"value"];
	}
}

- (void) add:(NSString *)value
	   
	callback:(BuddyIdentityAddCallback)callback
{
	[self checkForNilValue:value];

	[[client webService] UserAccount_Identity_AddNewValue:token IdentityValue:value RESERVED:@"" 
												 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														   {
															   if (callback)
															   {
																   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
															   }
														   } copy]];
}

- (void)remove:(NSString *)value
		 
	  callback:(BuddyIdentityRemoveCallback)callback
{
	[self checkForNilValue:value];

	[[client webService] UserAccount_Identity_RemoveValue:token IdentityValue:value RESERVED:@"" 
												 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														   {
															   if (callback)
															   {
																   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
															   }
														   } copy]];
}

- (void)checkForValues:(NSString *)values
				 
			  callback:(BuddyIdentityCheckForValuesCallback)callback
{
	[self checkForNilValue:values];

	__block BuddyIdentity *_self = self;

	[[client webService] UserAccount_Identity_CheckForValues:token IdentityValue:values RESERVED:@"" 
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
																			  data = [_self makeIdentitySearchList:jsonArray];
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