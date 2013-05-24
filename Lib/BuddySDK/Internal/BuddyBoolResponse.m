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

#import "BuddyBoolResponse.h"
#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"


/// <summary>
/// Represents a callback response.
/// </summary>

@implementation BuddyBoolResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams

{
	if (callbackParams.isCompleted && [callbackParams.stringResult isEqualToString:@"1"])
	{
		self = [super initWithParam:TRUE exception:nil state:callbackParams.state];
		result = TRUE;
	}
	else
	{
		NSString *apiCall = (callbackParams.apiCall == nil) ? @"Unknown" : callbackParams.apiCall;
		NSString *errorString = (callbackParams.isCompleted) ? callbackParams.stringResult : callbackParams.exception.reason;
		NSException *exception = [BuddyUtility processStandardErrors:errorString name:apiCall];

		self = [super initWithParam:FALSE exception:exception state:callbackParams.state];
		if (!self)
		{
			return nil;
		}

		result = FALSE;
	}

	return self;
}

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
           localResult:(BOOL)localResult
{
	if (callbackParams.isCompleted)
	{
		self = [super initWithParam:TRUE exception:nil state:callbackParams.state];
		result = localResult;
	}
	else
	{
		NSString *errorString = (callbackParams.isCompleted) ? callbackParams.stringResult : callbackParams.exception.reason;
		NSException *exception = [BuddyUtility processStandardErrors:errorString name:callbackParams.apiCall];

		self = [super initWithParam:FALSE exception:exception state:callbackParams.state];
		if (!self)
		{
			return nil;
		}

        result = FALSE;
	}

	return self;
}

- (id)initUnKnownErrorResponse:(BuddyCallbackParams *)callbackParams 
                     exception:(NSException *)exception
{
    self = [super initWithParam:FALSE exception:exception state:callbackParams.state];
    if (!self)
    {
        return nil;
    }
    
    result = FALSE;

    return self;
}


@end
