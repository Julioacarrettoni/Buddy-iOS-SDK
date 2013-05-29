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

#import "CommerceUnitTests.h"
#import "TestBuddySDK.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"
#import "BuddyCommerce.h"
#import "BuddyStoreItem.h"
#import "BuddyReceipt.h"


@implementation CommerceUnitTests

@synthesize buddyClient;
@synthesize user;

static NSString *AppName = @"Buddy iOS SDK test app";
static NSString *AppPassword = @"8C9E044D-7DB7-42DE-A376-16460B58008E";
static bool bwaiting = false;
static NSString *Token = @"UT-76444f9f-4a4b-4d3d-ba5c-7a82b5dbb5a5";

- (void)setUp
{
	[super setUp];

	self.buddyClient = [[BuddyClient alloc] initClient:AppName
										   appPassword:AppPassword
											appVersion:@"1"
								  autoRecordDeviceInfo:TRUE];

	STAssertNotNil(self.buddyClient, @"CommerceUnitTests failed buddyClient nil");
}

- (void)tearDown
{
	[super tearDown];

	self.buddyClient = nil;
}

- (void)waitloop
{
	NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:30];

	while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)aLogin
{
	[self.buddyClient login:Token callback:[^(BuddyAuthenticatedUserResponse *response)
													  {
														  if (response.isCompleted)
														  {
															  self.user = response.result;
															  NSLog(@"alogin OK user: %@", self.user.toString);
														  }
														  else
														  {
															  STFail(@"alogin failed !response.isCompleted");
														  }
														  bwaiting = false;
													  } copy]];
}

- (void)testStore
{
	NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_CommerceStore"];

	bwaiting = true;
	[self aLogin];
	[self waitloop];
	if (!self.user)
	{
		STFail(@"testStore login failed.");
		return;
	}

	NSArray *dict = [self.user.commerce performSelector:@selector(makeStoreItemList:) withObject:resArray];

	if ([dict count] != 2)
	{
		STFail(@"testStore failed dict should have 2 items");
	}

	resArray = [TestBuddySDK GetTextFileData:@"Test_CommerceStoreBad"];
	dict = [self.user.commerce performSelector:@selector(makeStoreItemList:) withObject:resArray];

	if ([dict count] != 2)
	{
		STFail(@"testStore failed dict should have 2 items");
	}

	resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
	dict = [self.user.commerce performSelector:@selector(makeStoreItemList:) withObject:resArray];
	if ([dict count] != 0)
	{
		STFail(@"testStore failed dict should have 0 items");
	}
}

@end
