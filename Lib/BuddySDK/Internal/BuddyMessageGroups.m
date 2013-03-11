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
/// Represents an object that can be used to create or query message groups for the app.
/// </summary>

@implementation BuddyMessageGroups

@synthesize authUser;
@synthesize client;

- (id)initWithUser:(BuddyClient *)localClient
		  authUser:(BuddyAuthenticatedUser *)localAuthUser
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyMessageGroups"];

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
	 openGroup:(BOOL)openGroup
	  callback:(BuddyMessageGroupsCreateCallback)callback
{
	[self create:name openGroup:openGroup appTag:nil state:nil callback:callback];
}

- (void)create:(NSString *)name
	 openGroup:(BOOL)openGroup
		appTag:(NSString *)appTag
		 state:(NSObject *)state
	  callback:(BuddyMessageGroupsCreateCallback)callback
{
	[BuddyUtility checkNameParam:name functionName:@"BuddyMessageGroups"];

	NSString *openGroupString = (openGroup == TRUE) ? @"1" : @"0";

	__block BuddyMessageGroups *_self = self;

	[[client webService] GroupMessages_Manage_CreateGroup:authUser.token GroupName:name GroupSecurity:openGroupString ApplicationTag:appTag RESERVED:@"" state:state
												 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														   {
															   if (callback)
															   {
																   BuddyMessageGroup *messageGroup;
																   if (callbackParams.isCompleted && [BuddyUtility isAStandardError:callbackParams.dataResult] == FALSE)
																   {
																	   NSNumber *groupId = [BuddyUtility NSNumberFromStringInt:callbackParams.dataResult];
																	   messageGroup = [[BuddyMessageGroup alloc] initMessageGroup:_self.client authUser:_self.authUser groupId:groupId name:name];
																   }

																   callback([[BuddyMessageGroupResponse alloc] initWithResponse:callbackParams
																														 result:messageGroup]);
															   }
															   _self = nil;
														   } copy]];
}

- (void)checkIfExists:(NSString *)name
				state:(NSObject *)state
			 callback:(BuddyMessageGroupsCheckIfExistsCallback)callback
{
	[BuddyUtility checkNameParam:name functionName:@"BuddyMessageGroups"];

	[[client webService] GroupMessages_Manage_CheckForGroup:authUser.token GroupName:name RESERVED:@"" state:state
												   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															 {
																 if (callback)
																 {
																	 BOOL exists = FALSE;
																	 if (callbackParams.isCompleted && [callbackParams.dataResult isEqualToString:@"1"])
																	 {
																		 exists = TRUE;
																	 }

																	 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams
																											  localResult:exists]);
																 }
															 } copy]];
}

- (NSArray *)makeMessageGroupList:(NSArray *)data
{
	NSMutableArray *messageGroupList = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyMessageGroup *message = [[BuddyMessageGroup alloc] initMessageGroup:self.client authUser:self.authUser memberShips:dict];
				if (message)
				{
					[messageGroupList addObject:message];
				}
			}
		}
	}
	return messageGroupList;
}

- (void)getAll:(NSObject *)state
	  callback:(BuddyMessageGroupsGetAllCallback)callback
{
	__block BuddyMessageGroups *_self = self;

	[[client webService] GroupMessages_Membership_GetAllGroups:authUser.token RESERVED:@"" state:state
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
																				data = [_self makeMessageGroupList:jsonArray];
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

- (void)getMy:(NSObject *)state
	 callback:(BuddyMessageGroupsGetMyCallback)callback
{
	__block BuddyMessageGroups *_self = self;

	[[client webService] GroupMessages_Membership_GetMyList:authUser.token RESERVED:@"" state:state
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
																			 data = [_self makeMessageGroupList:jsonArray];
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