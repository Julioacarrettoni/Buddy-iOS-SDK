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

#import "BuddyGameStates.h"
#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"


/// <summary>
/// Represents a class that can be used to add, retrieve or delete game state data for any user in the system.
/// </summary>

@implementation BuddyGameStates

@synthesize client;
@synthesize user;

- (id)initGameStates:(BuddyClient *)localClient
				user:(BuddyUser *)localUser
{
	[BuddyUtility checkForNilClientAndUser:localClient user:localUser name:@"BuddyGameStates"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	user = localUser;

	return self;
}

- (void)dealloc
{
	client = nil;
	user = nil;
}

- (void)   add:(NSString *)gameStateKey
gameStateValue:(NSString *)gameStateValue
      callback:(BuddyGameStatesAddCallback)callback
{
    [self add:gameStateKey gameStateValue:gameStateValue appTag:nil state:nil callback:callback];
}

- (void)checkGamesStateKey:(NSString *)key
{
	if ([BuddyUtility isNilOrEmpty:key])
	{
		[BuddyUtility throwNilArgException:@"BuddyGameStates" reason:@"gameStateKey"];
	}
}

- (void)checkGamesStateValue:(NSString *)value
{
	if ([BuddyUtility isNilOrEmpty:value])
	{
		[BuddyUtility throwNilArgException:@"BuddyGameStates" reason:@"gameStateValue"];
	}
}

- (void)   add:(NSString *)gameStateKey
gameStateValue:(NSString *)gameStateValue
        appTag:(NSString *)appTag
         state:(NSObject *)state
      callback:(BuddyGameStatesAddCallback)callback
{
	[self checkGamesStateKey:gameStateKey];
	[self checkGamesStateValue:gameStateValue];

	NSString *userId = [NSString stringWithFormat:@"%d", [user.userId intValue]];

	[[client webService] Game_State_Add:userId GameStateKey:gameStateKey GameStateValue:gameStateValue ApplicationTag:appTag RESERVED:@"" state:state
                               callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																																							 {
																																								 if (callback)
																																								 {
																																									 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																																								 }
																																							 } copy]];
}

- (void)get:(NSString *)gameStateKey
      state:(NSObject *)state
   callback:(BuddyGameStatesGetCallback)callback
{
	[self checkGamesStateKey:gameStateKey];

	NSString *userId = [NSString stringWithFormat:@"%d", [user.userId intValue]];

	[[client webService] Game_State_Get:userId GameStateKey:gameStateKey RESERVED:@"" state:state
							   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
										 {
											 if (callback)
											 {
												 BuddyGameState *gameState;
												 NSException *exception;
												 @try
												 {
													 if (callbackParams.isCompleted && jsonArray != nil)
													 {
														 if ([jsonArray isKindOfClass:[NSArray class]] && [jsonArray count] > 0)
														 {
															 NSDictionary *dict = (NSDictionary *)[jsonArray objectAtIndex:0];
															 gameState = [[BuddyGameState alloc] initGame:dict];
														 }
													 }
												 }
												 @catch (NSException *ex)
												 {
													 exception = ex;
												 }

												 if (exception)
												 {
													 callback([[BuddyGameStateResponse alloc] initWithError:exception
                                                                                                   state:callbackParams.state
                                                                                                 apiCall:callbackParams.apiCall]);
												 }
												 else
												 {
													 callback([[BuddyGameStateResponse alloc]initCompletedWithResponse:callbackParams
																											 result:gameState]);
												 }
											 }
										 } copy]];
}

- (void)update:(NSString *)gameStateKey
gameStateValue:(NSString *)gameStateValue
      callback:(BuddyGameStatesUpdateCallback)callback
{
    [self update:gameStateKey gameStateValue:gameStateValue newAppTag:nil state:nil callback:callback];
}

- (void)update:(NSString *)gameStateKey
gameStateValue:(NSString *)gameStateValue
     newAppTag:(NSString *)newAppTag
         state:(NSObject *)state
      callback:(BuddyGameStatesUpdateCallback)callback
{
	[self checkGamesStateKey:gameStateKey];
	[self checkGamesStateValue:gameStateValue];

	NSString *userId = [NSString stringWithFormat:@"%d", [user.userId intValue]];

	[[client webService] Game_State_Update:userId GameStateKey:gameStateKey GameStateValue:gameStateValue ApplicationTag:newAppTag RESERVED:@"" state:state
                                  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
																																								   {
																																									   if (callback)
																																									   {
																																										   callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																																									   }
																																								   } copy]];
}

- (void)remove:(NSString *)gameStateKey
         state:(NSObject *)state
      callback:(BuddyGameStatesRemoveCallback)callback
{
	[self checkGamesStateKey:gameStateKey];

	NSString *userId = [NSString stringWithFormat:@"%d", [user.userId intValue]];

	[[client webService] Game_State_Remove:userId GameStateKey:gameStateKey RESERVED:@"" state:state
								  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
											{
												if (callback)
												{
													callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
												}
											} copy]];
}

- (NSDictionary *)makeGameStateList:(NSArray *)data
{
	NSMutableDictionary *dictOut = [[NSMutableDictionary alloc] init];

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

			NSString *stateKey = [BuddyUtility stringFromString:[dict objectForKey:@"stateKey"]];
			if ([BuddyUtility isNilOrEmpty:stateKey])
			{
				continue;
			}

			if ([dictOut objectForKey:stateKey] == nil)
			{
				BuddyGameState *gameState = [[BuddyGameState alloc] initGame:dict];
				if (gameState)
				{
					[dictOut setObject:gameState forKey:stateKey];
				}
			}
		}
	}
	return dictOut;
}

- (void)getAll:(NSObject *)state
      callback:(BuddyGameStatesGetAllCallback)callback
{
	NSString *userId = [NSString stringWithFormat:@"%d", [user.userId intValue]];

	__block BuddyGameStates *_self = self;

	[[client webService] Game_State_GetAll:userId RESERVED:@"" state:state
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
															dict = [_self makeGameStateList:jsonArray];
														}
													}
													@catch (NSException *ex)
													{
														exception = ex;
													}

													if (exception)
													{
														callback([[BuddyDictionaryResponse alloc] initWithError:exception
                                                                                                       state:callbackParams.state
                                                                                                     apiCall:callbackParams.apiCall]);
													}
													else
													{
														callback([[BuddyDictionaryResponse alloc] initWithResponse:callbackParams result:dict]);
													}
												}
												_self = nil;
											} copy]];
}

@end