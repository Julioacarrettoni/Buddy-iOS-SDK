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


#import "ClientServiceJSON.h"
#import "AFJSONRequestOperation.h"


@implementation ClientServiceJSON

+ (ClientServiceJSON *)sharedClient
{
	static ClientServiceJSON *_sharedClient = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken,
				  ^{
					  _sharedClient = [[ClientServiceJSON alloc] initWithBaseURL:[NSURL URLWithString:kBuddyAPIBaseURL]];
				  });

	return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
	self = [super initWithBaseURL:url];
	if (!self)
	{
		return nil;
	}

	[self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
	return self;
}

@end