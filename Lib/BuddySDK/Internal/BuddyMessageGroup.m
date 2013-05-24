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
/// Represents a single message group. Message groups are groups of users that can message each other. groups can either be public, with anyone being able
/// to join them, or private - where only the user that create the group can add other users to it.
/// </summary>

@implementation BuddyMessageGroup

@synthesize client;
@synthesize authUser;
@synthesize groupId;
@synthesize name;
@synthesize createdOn;
@synthesize appTag;
@synthesize ownerUserId;
@synthesize memberUserIds;

- (id)initMessageGroup:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
			   groupId:(NSNumber *)localGroupId
				  name:(NSString *)localName;
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyMessageGroup"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	authUser = localAuthUser;
	groupId = localGroupId;
	name = localName;

	return self;
}

- (void)dealloc
{
	client = nil;
	authUser = nil;
}

- (id)initMessageGroup:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
		   memberShips:(NSDictionary *)data
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyMessageGroup"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	authUser = localAuthUser;

	if (data)
	{
		groupId = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"chatGroupID"]];
		name = [BuddyUtility stringFromString:[data objectForKey:@"chatGroupName"]];
		createdOn = [BuddyUtility buddyDate:[data objectForKey:@"createdDateTime"]];
		appTag = [BuddyUtility stringFromString:[data objectForKey:@"applicationTag"]];
		ownerUserId = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"ownerUserID"]];

		NSString *memberIdList = [BuddyUtility stringFromString:[data objectForKey:@"memberUserIDList"]];
		if (memberIdList)
		{
			memberUserIds = [memberIdList componentsSeparatedByString:@";"];
		}
	}

	return self;
}

- (void)join:(BuddyMessageGroupJoinCallback)callback
{
	[[client webService] GroupMessages_Membership_JoinGroup:authUser.token GroupChatID:self.groupId RESERVED:@"" 
												   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															 {
																 if (callback)
																 {
																	 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																 }
															 } copy]];
}

- (void)leave:(BuddyMessageGroupLeaveCallback)callback
{
	[[client webService] GroupMessages_Membership_DepartGroup:authUser.token GroupChatID:self.groupId RESERVED:@"" 
													 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															   {
																   if (callback)
																   {
																	   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																   }
															   } copy]];
}

- (void)addUser:(BuddyUser *)userToAdd
		  
	   callback:(BuddyMessageGroupAddUserCallback)callback
{
	[[client webService] GroupMessages_Membership_AddNewMember:authUser.token GroupChatID:self.groupId UserProfileIDToAdd:userToAdd.userId RESERVED:@"" 
													  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																{
																	if (callback)
																	{
																		callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																	}
																} copy]];
}

- (void)removeUser:(BuddyUser *)userToRemove
			 
		  callback:(BuddyMessageGroupRemoveUserCallback)callback
{
	[[client webService] GroupMessages_Membership_RemoveUser:authUser.token UserProfileIDToRemove:userToRemove.userId GroupChatID:self.groupId RESERVED:@"" 
													callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															  {
																  if (callback)
																  {
																	  callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																  }
															  } copy]];
}

- (NSDictionary *)makeResponseDict:(NSArray *)data
{
	NSMutableDictionary *dictResponse = [[NSMutableDictionary alloc] init];

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

			NSString *memberId = [BuddyUtility stringFromString:[dict objectForKey:@"memberUserIDList"]];
			if ([BuddyUtility isNilOrEmpty:memberId])
			{
				continue;
			}

			NSString *sendResult = [BuddyUtility stringFromString:[dict objectForKey:@"sendResult"]];
			if ([dictResponse objectForKey:memberId] == nil)
			{
				NSNumber *number = [NSNumber numberWithBool:[sendResult isEqualToString:@"1"] ? TRUE:FALSE];
				[dictResponse setObject:number forKey:memberId];
			}
		}
	}

	return dictResponse;
}

- (void)sendMessage:(NSString *)message
		   callback:(BuddyMessageGroupSendMessageCallback)callback
{
	[self sendMessage:message latitude:0.0 longitude:0.0 appTag:nil  callback:callback];
}

- (void)sendMessage:(NSString *)message
		   latitude:(double)latitude
		  longitude:(double)longitude
			 appTag:(NSString *)localAppTag
			  
		   callback:(BuddyMessageGroupSendMessageCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:message] || [message length] > 1000)
	{
		[BuddyUtility throwInvalidArgException:@"BuddyMessageGroup" reason:@"message can't be nil or larger than 1000 characters"];
	}

	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyMessageGroup"];

	__block BuddyMessageGroup *_self = self;

	[[client webService] GroupMessages_Message_Send:authUser.token GroupChatID:self.groupId MessageContent:message Latitude:latitude Longitude:longitude ApplicationTag:localAppTag RESERVED:@"" 
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
																	 dict = [_self makeResponseDict:jsonArray];
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

- (NSArray *)makeGroupMessageList:(NSArray *)data
{
	NSMutableArray *groupMessageArray = [[NSMutableArray alloc] init];

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

			BuddyGroupMessage *message = [[BuddyGroupMessage alloc] initWithData:dict group:self];
			if (message)
			{
				[groupMessageArray addObject:message];
			}
		}
	}
	return groupMessageArray;
}

- (void)getReceived:(BuddyMessageGroupGetReceivedCallback)callback
{
	[self getReceived:nil  callback:callback];
}

- (void)getReceived:(NSDate *)afterDate
			  
		   callback:(BuddyMessageGroupGetReceivedCallback)callback
{
	if (afterDate == nil)
	{
		afterDate = [BuddyUtility defaultAfterDate];
	}

	NSString *afterDateString = [BuddyUtility buddyDateToString:afterDate];
	__block BuddyMessageGroup *_self = self;

	[[client webService] GroupMessages_Message_Get:authUser.token GroupChatID:self.groupId
									  FromDateTime:afterDateString RESERVED:@"" 
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
																	data = [_self makeGroupMessageList:jsonArray];
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

- (void)delete:(BuddyMessageGroupDeleteCallback)callback
{
	[[client webService] GroupMessages_Manage_DeleteGroup:authUser.token GroupChatID:self.groupId RESERVED:@"" 
												 callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
														   {
															   if (callback)
															   {
																   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
															   }
														   } copy]];
}

@end