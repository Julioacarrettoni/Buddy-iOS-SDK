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
#import "BuddyUtility.h"


/// <summary>
/// Represents the sum of a collection of metadata items with a similar key.
/// </summary>

@implementation BuddyMetadataSum

@synthesize total;
@synthesize keysCounted;
@synthesize keyName;

- (id)initMetadataSum:(NSDictionary *)data;
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	if (data)
	{
		total = [BuddyUtility doubleFromString:[data objectForKey:@"totalValue"]];
		keysCounted = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"keyCount"]];
		keyName = [BuddyUtility stringFromString:[data objectForKey:@"metaKey"]];
	}

	return self;
}

- (id)initMetadataSum:(NSDictionary *)data
			  keyName:(NSString *)localKeyName
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	if (data)
	{
		total = [BuddyUtility doubleFromString:[data objectForKey:@"totalValue"]];
		keysCounted = [BuddyUtility NSNumberFromStringInt:[data objectForKey:@"keyCount"]];
	}

	keyName = localKeyName;

	return self;
}

@end