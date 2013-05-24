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
/// Represents a player in a game. The Player object tracks game specific items such as board, ranks, and other data specific to building game leader boards and other game related constructs.
/// </summary>

@implementation BuddyGamePlayers

@synthesize authUser;
@synthesize client;

- (id)initWithAuthUser:(BuddyClient *)localClient
			  authUser:(BuddyAuthenticatedUser *)localAuthUser
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyGamePlayers"];

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

- (void)  add:(NSString *)name
		board:(NSString *)board
		 rank:(NSString *)rank
	 latitude:(double)latitude
	longitude:(double)longitude
	   appTag:(NSString *)appTag
		
	 callback:(BuddyPlayersAddCallback)callback
{
	[BuddyUtility checkNameParam:name functionName:@"BuddyGamePlayers"];

	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyGamePlayers"];

	[[client webService] Game_Player_Add:authUser.token PlayerName:name PlayerLatitude:latitude PlayerLongitude:longitude PlayerRank:rank PlayerBoardName:board ApplicationTag:appTag RESERVED:@"" 
								callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
										  {
											  if (callback)
											  {
												  callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
											  }
										  } copy]];
}

- (void) add:(NSString *)name
	callback:(BuddyPlayersAddCallback)callback
{
	[self add:name board:nil rank:nil latitude:0.0 longitude:0.0 appTag:nil  callback:callback];
}

- (void)update:(NSString *)name
		 board:(NSString *)board
		  rank:(NSString *)rank
	  latitude:(double)latitude
	 longitude:(double)longitude
		appTag:(NSString *)appTag
		 
	  callback:(BuddyPlayersUpdateCallback)callback
{
	[BuddyUtility checkNameParam:name functionName:@"BuddyGamePlayers"];

	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyGamePlayers"];

	[[client webService] Game_Player_Update:authUser.token PlayerName:name PlayerLatitude:latitude PlayerLongitude:longitude PlayerRank:rank PlayerBoardName:board ApplicationTag:appTag RESERVED:@"" 
								   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
											 {
												 if (callback)
												 {
													 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
												 }
											 } copy]];
}

- (void)update:(NSString *)name
	  callback:(BuddyPlayersUpdateCallback)block
{
	[self update:name board:nil rank:nil latitude:0.0 longitude:0.0 appTag:nil  callback:block];
}

- (void)delete:(BuddyPlayersDeleteCallback)callback
{
	[[client webService] Game_Player_Delete:authUser.token RESERVED:@"" 
								   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
											 {
												 if (callback)
												 {
													 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
												 }
											 } copy]];
}

- (void)getInfo:(BuddyPlayersGetInfoCallback)callback
{
	__block BuddyGamePlayers *_self = self;

	[[client webService] Game_Player_GetPlayerInfo:authUser.token RESERVED:@"" 
										  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
													{
														if (callback)
														{
															BuddyGamePlayer *player;
															NSException *exception;
															@try
															{
																if (callbackParams.isCompleted && jsonArray != nil &&
																	[jsonArray isKindOfClass:[NSArray class]] &&
																	[jsonArray count] > 0)
																{
																	NSDictionary *dict = [jsonArray objectAtIndex:0];
																	if (dict && [dict count] > 0)
																	{
																		player = [[BuddyGamePlayer alloc] initWithUser:_self.authUser gamePlayerInfo:dict];
																	}
																}
															}
															@catch (NSException *ex)
															{
																exception = ex;
															}

															if (exception)
															{
																callback([[BuddyGamePlayerResponse alloc] initWithError:exception
																												  
																												apiCall:callbackParams.apiCall]);
															}
															else
															{
																callback([[BuddyGamePlayerResponse alloc] initCompletedWithResponse:callbackParams
																															 result:player]);
															}
														}
														_self = nil;
													} copy]];
}

- (NSArray *)makePlayerList:(NSArray *)data
{
	NSMutableArray *playerList = [[NSMutableArray alloc] init];

	if (data != nil && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyGamePlayer *player = [[BuddyGamePlayer alloc] initWithUser:authUser gamePlayerInfoSearchResults:dict];
				if (player)
				{
					[playerList addObject:player];
				}
			}
		}
	}
	return playerList;
}

- (void)               find:(NSNumber *)searchDistanceInMeters
				   latitude:(double)latitude
				  longitude:(double)longitude
				recordLimit:(NSNumber *)recordLimit
				  boardName:(NSString *)boardName
	onlyForLastNumberOfDays:(NSNumber *)onlyForLastNumberOfDays
					 appTag:(NSString *)appTag
					  
				   callback:(BuddyPlayersFindCallback)callback
{
	if (searchDistanceInMeters == nil)
	{
		searchDistanceInMeters = [NSNumber numberWithInt:-1];
	}

	if (recordLimit == nil)
	{
		recordLimit = [NSNumber numberWithInt:10];
	}

	if (onlyForLastNumberOfDays == nil)
	{
		onlyForLastNumberOfDays = [NSNumber numberWithInt:-1];
	}

	__block BuddyGamePlayers *_self = self;

	[[client webService] Game_Player_SearchPlayers:authUser.token SearchDistance:searchDistanceInMeters SearchLatitude:latitude SearchLongitude:longitude RecordLimit:recordLimit SearchBoard:boardName TimeFilter:onlyForLastNumberOfDays ApplicationTag:appTag RESERVED:@"" 
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
																	data = [_self makePlayerList:jsonArray];
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