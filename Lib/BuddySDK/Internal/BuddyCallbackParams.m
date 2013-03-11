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


#import "BuddyCallbackParams.h"
#import "BuddyUtility.h"


@implementation BuddyCallbackParams

@synthesize exception;
@synthesize isCompleted;
@synthesize state;
@synthesize dataResult;
@synthesize apiCall;

- (id)initTrueWithState:(NSObject *)localState
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	isCompleted = TRUE;
	exception = nil;
	state = localState;
	dataResult = @"";
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callback
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	isCompleted = FALSE;

	NSString *errorName = (callback.apiCall == nil) ? @"Unknown" : callback.apiCall;
	NSString *errorString = (callback.isCompleted) ? callback.dataResult : callback.exception.reason;
	exception = [BuddyUtility processStandardErrors:errorString name:errorName];
	state = callback.state;

	return self;
}

- (id)initWithParam:(BOOL)succeeded
		  exception:(NSException *)localException
			  state:(NSObject *)localState
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	isCompleted = succeeded;
	exception = localException;
	state = localState;
	dataResult = @"";
    
	return self;
}

- (id)initWithError:(NSException *)localException
			  state:(NSObject *)localState
			apiCall:(NSString *)localApiCall
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	isCompleted = FALSE;
	exception = localException;
	state = localState;
	apiCall = localApiCall;
    
	return self;
}

- (id)initWithParam:(BOOL)succeeded
			apiCall:(NSString *)localApiCall
		  exception:(NSException *)localException
			  state:(NSObject *)localState
		 dataResult:(NSString *)localDataResult
{
	self = [super init];
	if (!self)
	{
		return nil;
	}

	isCompleted = succeeded;
	exception = localException;
	state = localState;
	dataResult = localDataResult;
    apiCall = localApiCall;
    
	return self;
}

- (void)dealloc
{
    exception = nil;
	dataResult = nil;
    apiCall = nil;
}

@end