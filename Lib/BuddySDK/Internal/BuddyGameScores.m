
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

#import "BuddyGameScores.h"
#import "BuddyClient_Exn.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"
#import "BuddyWebWrapper.h"


/// <summary>
/// Represents a class that can be used to add, retrieve or delete game scores for any user in the system.
/// </summary>

@implementation BuddyGameScores

@synthesize client;
@synthesize authUser;
@synthesize user;

- (id)initGameScores:(BuddyClient *)localClient
			authUser:(BuddyAuthenticatedUser *)localAuthUser
				user:(BuddyUser *)localUser
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyGameScores"];

	self = [super init];
	if (!self)
	{
		return nil;
	}

	client = localClient;
	user = localUser;
	authUser = localAuthUser;

	return self;
}

- (void)dealloc
{
	client = nil;
	user = nil;
	authUser = nil;
}

- (NSArray *)makeScoresList:(NSArray *)data
{
	NSMutableArray *scores = [[NSMutableArray alloc] init];

	if (data && [data isKindOfClass:[NSArray class]])
	{
		int i = (int)[data count];
		for (int j = 0; j < i; j++)
		{
			NSDictionary *dict = (NSDictionary *)[data objectAtIndex:(unsigned int)j];
			if (dict && [dict count] > 0)
			{
				BuddyGameScore *score = [[BuddyGameScore alloc] initGameScore:dict];
				if (score)
				{
					[scores addObject:score];
				}
			}
		}
	}

	return scores;
}

- (void)getAll:(BuddyGameScoresGetAllCallback)callback
{
	NSNumber *recordLimit = [NSNumber numberWithInt:100];

    [self getAll:recordLimit state:nil callback:callback];
}

- (void)getAll:(NSNumber *)recordLimit
         state:(NSObject *)state
      callback:(BuddyGameScoresGetAllCallback)callback
{
	[BuddyUtility checkRecordLimitParam:recordLimit functionName:@"BuddyGameScores"];

	NSString *userId;
	if (authUser == nil)
	{
		userId = [NSString stringWithFormat:@"%d", [user.userId intValue]];
	}
	else
	{
		userId = authUser.token;
	}

	__block BuddyGameScores *_self = self;

	[[client webService] Game_Score_GetScoresForUser:userId RecordLimit:recordLimit RESERVED:@"" state:state
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
																	  data = [_self makeScoresList:jsonArray];
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

- (void)deleteAll:(NSObject *)state
         callback:(BuddyGameScoresDeleteAllCallback)callback
{
	NSString *userId;

	if (authUser == nil)
	{
		userId = [NSString stringWithFormat:@"%d", [user.userId intValue]];
	}
	else
	{
		userId = authUser.token;
	}

	[[client webService] Game_Score_DeleteAllScoresForUser:userId RESERVED:@"" state:state
												  callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
															{
																if (callback)
																{
																	callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
																}
															} copy]];
}

- (void)add:(double)score
   callback:(BuddyGameScoresAddCallback)callback
{
    [self add:score board:nil rank:nil latitude:0.0 longitude:0.0 oneScorePerPlayer:FALSE appTag:nil state:nil callback:callback];
}

- (void)add:(double)score
      board:(NSString *)board
       rank:(NSString *)rank
   latitude:(double)latitude
        longitude:(double)longitude
oneScorePerPlayer:(BOOL)oneScorePerPlayer
           appTag:(NSString *)appTag
            state:(NSObject *)state
         callback:(BuddyGameScoresAddCallback)callback
{
	NSString *userId;

    [BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyGameScores"];
     
	if (authUser == nil)
	{
		userId = [NSString stringWithFormat:@"%d", [user.userId intValue]];
	}
	else
	{
		userId = authUser.token;
	}

	NSNumber *oneScore = (oneScorePerPlayer == TRUE) ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0];

	[[client webService] Game_Score_Add:userId ScoreLatitude:latitude ScoreLongitude:longitude ScoreRank:rank ScoreValue:score ScoreBoardName:board ApplicationTag:appTag OneScorePerPlayerBit:oneScore RESERVED:@"" state:state
							   callback:[^(BuddyCallbackParams *callbackParams, id jsonArray)
										 {
											 if (callback)
											 {
												 callback([[BuddyBoolResponse alloc] initWithResponse:callbackParams]);
											 }
										 } copy]];
}

@end