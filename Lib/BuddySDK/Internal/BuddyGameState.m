
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

#import "BuddyGameState.h"
#import "BuddyClient_Exn.h"
#import "BuddyUtility.h"


/// <summary>
/// Represents a single game state object.
/// </summary>

@interface BuddyGameState ()

@property (readonly, nonatomic, strong) NSNumber *gameStateId;

@end

@implementation BuddyGameState

@synthesize appTag;
@synthesize addedOn;
@synthesize gameStateId;
@synthesize key;
@synthesize value;

- (id)initGame:(NSDictionary *)gameList;
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	if (gameList && [gameList count] > 0)
	{
		appTag = [BuddyUtility stringFromString:[gameList objectForKey:@"appTag"]];
		addedOn = [BuddyUtility dateFromString:[gameList objectForKey:@"stateDateTime"]];
		key = [BuddyUtility stringFromString:[gameList objectForKey:@"stateKey"]];
		value = [BuddyUtility stringFromString:[gameList objectForKey:@"stateValue"]];
		gameStateId = [BuddyUtility NSNumberFromStringInt:[gameList objectForKey:@"stateID"]];
	}

	return self;
}

@end