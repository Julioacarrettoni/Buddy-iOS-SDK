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
/// Represents a collection of friends. Use the AuthenticatedUser.Friends property to access this object.
/// </summary>

@implementation BuddyFriends

@synthesize client;
@synthesize authUser;
@synthesize requests;

- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localAuthUser name:@"BuddyFriends"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	authUser = localAuthUser;

	requests = [[BuddyFriendRequests alloc] initWithAuthUser:localClient authUser:localAuthUser];

	return self;
}

- (void)dealloc
{
	client = nil;
	authUser = nil;
}

- (NSArray *)makeFriendsList:(NSArray *)data
{
	NSMutableArray *friends = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyUser *user = [[BuddyUser alloc] initWithClientFriendRequests:self.client userProfile:dict userId:self.authUser.userId];
				if (user)
				{
					[friends addObject:user];
				}
			}
		}
	}
	return friends;
}

- (NSArray *)makeBlockedFriendsList:(NSArray *)data
{
	NSMutableArray *friends = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyUser *user = [[BuddyUser alloc] initWithClientBlockedFriend:self.client userProfile:dict];
				if (user)
				{
					[friends addObject:user];
				}
			}
		}
	}
	return friends;
}

- (void)getAll:(BuddyFriendsGetCallback)callback
{
	[self getAll:nil state:nil callback:callback];
}

- (void)getAll:(NSDate *)afterDate
		 state:(NSObject *)state
	  callback:(BuddyFriendsGetCallback)callback
{
	if (afterDate == nil)
	{
		afterDate = [BuddyUtility defaultAfterDate];
	}

	NSString *sdate = [BuddyUtility buddyDateToString:afterDate];

	__block BuddyFriends *_self = self;

	[[client webService] Friends_Friends_GetList:authUser.token FromDateTime:sdate state:state
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
																  data = [_self makeFriendsList:jsonArray];
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

- (void)remove:(BuddyUser *)user
		 state:(NSObject *)state
	  callback:(BuddyFriendsRemoveCallback)callback
{
	[BuddyUtility checkForNilUser:user name:@"BuddyFriends"];

	[[client webService] Friends_Friends_Remove:authUser.token FriendProfileID:user.userId state:state
									   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
												 {
													 if (callback)
													 {
														 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
													 }
												 } copy]];
}

@end