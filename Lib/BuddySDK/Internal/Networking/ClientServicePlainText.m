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


#import "ClientServicePlainText.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"


@implementation ClientServicePlainText

+ (ClientServicePlainText *)sharedClient
{
	static ClientServicePlainText *_sharedClient = nil;
	static dispatch_once_t onceToken;

	if (_sharedClient == nil)
	{
		dispatch_once(&onceToken,
					  ^{
						  _sharedClient = [[ClientServicePlainText alloc] initWithBaseURL:[NSURL URLWithString:kBuddyAPIBaseURLSSL]];
					  });
	}

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
	[self setDefaultHeader:@"Accept" value:@"text/plain"];
	[self setDefaultHeader:@"Cache-Control" value:@"no-cache"];
	[self setDefaultHeader:@"Pragma" value:@"no-cache"];

	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:true];

	return self;
}

- (void)setSSLType:(BOOL)ssl
{
	if (ssl)
	{
		[self setBuddyBaseURL:[NSURL URLWithString:kBuddyAPIBaseURLSSL]];
	}
	else
	{
		[self setBuddyBaseURL:[NSURL URLWithString:kBuddyAPIBaseURL]];
	}
}

- (void)enableNetworkActivityDisplay
{
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:true];
}

- (void)disableNetworkActivityDisplay
{
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:false];
}

@end