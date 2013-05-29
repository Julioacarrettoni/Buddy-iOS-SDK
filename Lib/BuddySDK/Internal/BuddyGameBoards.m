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
/// Represents an object the can be used to retrieve Buddy Game Boards and Scores.
/// </summary>

@implementation BuddyGameBoards

@synthesize client;

- (id)initWithClient:(BuddyClient *)localClient
{
	[BuddyUtility checkForNilClient:localClient name:@"BuddyGameBoards"];

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

- (void)getHighScores:(NSString *)boardName
			 callback:(BuddyGameBoardsGetScoresCallback)callback
{
	NSNumber *recordLimit = [NSNumber numberWithInt:100];

	[self getHighScores:boardName recordLimit:recordLimit  callback:callback];
}

- (void)getHighScores:(NSString *)boardName
		  recordLimit:(NSNumber *)recordLimit
				
			 callback:(BuddyGameBoardsGetScoresCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:boardName])
	{
		[BuddyUtility throwNilArgException:@"BuddyGameBoards" reason:@"boardName"];
	}

	[BuddyUtility checkRecordLimitParam:recordLimit functionName:@"BuddyGameBoards"];

	__block BuddyGameBoards *_self = self;

	[[client webService] Game_Score_GetBoardHighScores:boardName RecordLimit:recordLimit RESERVED:@"" 
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
																		data = [_self makeScores:jsonArray];
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

- (void)getLowScores:(NSString *)boardName
			callback:(BuddyGameBoardsGetScoresCallback)callback
{
	NSNumber *recordLimit = [NSNumber numberWithInt:100];

	[self getLowScores:boardName recordLimit:recordLimit callback:callback];
}

- (void)getLowScores:(NSString *)boardName
		 recordLimit:(NSNumber *)recordLimit
			callback:(BuddyGameBoardsGetScoresCallback)callback
{
	if ([BuddyUtility isNilOrEmpty:boardName])
	{
		[BuddyUtility throwNilArgException:@"BuddyGameBoards" reason:@"boardName"];
	}

	[BuddyUtility checkRecordLimitParam:recordLimit functionName:@"BuddyGameBoards"];

	__block BuddyGameBoards *_self = self;

	[[client webService] Game_Score_GetBoardLowScores:boardName RecordLimit:recordLimit RESERVED:@""
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
																	   data = [_self makeScores:jsonArray];
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

- (NSArray *)makeScores:(NSArray *)data
{
	NSMutableArray *scores = [[NSMutableArray alloc] init];

	if (data != nil && [data isKindOfClass:[NSArray class]])
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

- (void)  findScores:(BuddyUser *)user
	distanceInMeters:(NSNumber *)distanceInMeters
			latitude:(double)latitude
		   longitude:(double)longitude
		 recordLimit:(NSNumber *)recordLimit
		   boardName:(NSString *)boardName
			 daysOld:(NSNumber *)daysOld
		minimumScore:(NSNumber *)minimumScore
			  appTag:(NSString *)appTag
			   
			callback:(BuddyGameBoardsFindScoresCallback)callback
{
	[BuddyUtility latLongCheck:latitude longitude:longitude className:@"BuddyGameBoards"];

	NSString *uid = (user == nil) ? @"-1" : [NSString stringWithFormat:@"%d", [user.userId intValue]];

	if (distanceInMeters == nil)
	{
		distanceInMeters = [[NSNumber alloc] initWithInt:-1];
	}

	if (recordLimit == nil)
	{
		recordLimit = [[NSNumber alloc] initWithInt:100];
	}

	if (boardName == nil)
	{
		boardName = @"";
	}

	if (daysOld == nil)
	{
		daysOld = [[NSNumber alloc] initWithInt:999999];
	}

	if (minimumScore == nil)
	{
		minimumScore = [[NSNumber alloc] initWithInt:-1];
	}

	__block BuddyGameBoards *_self = self;

	[[client webService] Game_Score_SearchScores:uid SearchDistance:distanceInMeters SearchLatitude:latitude SearchLongitude:longitude RecordLimit:recordLimit SearchBoard:boardName TimeFilter:daysOld MinimumScore:minimumScore AppTag:appTag RESERVED:@"" 
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
																  data = [_self makeScores:jsonArray];
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
