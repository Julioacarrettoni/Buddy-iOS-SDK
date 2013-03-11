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
/// Represents a single user check-in location.
/// <code>

@implementation BuddyCheckInLocation

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize checkinDate = _checkinDate;
@synthesize placeName = _placeName;
@synthesize comment = _comment;
@synthesize appTag = _appTag;

- (id)initCheckInLocation:(NSDictionary *)profile
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	if (profile && [profile isKindOfClass:[NSDictionary class]])
	{
		_latitude = [BuddyUtility doubleFromString:[profile objectForKey:@"latitude"]];
		_longitude = [BuddyUtility doubleFromString:[profile objectForKey:@"longitude"]];
		_placeName = [BuddyUtility stringFromString:[profile objectForKey:@"placeName"]];
		_checkinDate = [BuddyUtility dateFromString:[profile objectForKey:@"createdDate"]];
	}

	_comment = @"";
	_appTag =  @"";

	return self;
}

@end
