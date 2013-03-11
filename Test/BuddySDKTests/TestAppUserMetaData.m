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

#import "TestBuddySDK.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "TestAppUserMetadata.h"
#import "BuddyClient.h"
#import "BuddyMetadataItem.h"
#import "BuddyMetadataSum.h"


@implementation TestAppUserMetadata

static int totalItems;
static NSString *AppName = @"Buddy iOS SDK test app";
static NSString *AppPassword = @"8C9E044D-7DB7-42DE-A376-16460B58008E";
static bool bwaiting = false;
static NSString *Token = @"UT-76444f9f-4a4b-4d3d-ba5c-7a82b5dbb5a5";

@synthesize buddyClient;
@synthesize user;

- (void)setUp
{
	[super setUp];

	self.buddyClient = [[BuddyClient alloc] initClient:AppName
										   appPassword:AppPassword
											appVersion:@"1"
								  autoRecordDeviceInfo:TRUE];

	STAssertNotNil(self.buddyClient, @"aTestAppUserMetadata failed buddyClient nil");
}

- (void)tearDown
{
	[super tearDown];

	self.buddyClient = nil;
	self.user = nil;
}

- (void)waitloop
{
	NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:30];

	while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)waitloop2
{
	NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:2];

	while ([loopTil timeIntervalSinceNow] > 0)
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}

- (void)alogin
{
	[self.buddyClient login:Token state:nil
				   callback:[^(BuddyAuthenticatedUserResponse *response)
							 {
								 if (response.isCompleted)
								 {
									 self.user = response.result;
									 NSLog(@"alogin OK user: %@", self.user.toString);
								 }
								 else
								 {
									 STFail(@"alogin failed");
								 }
								 bwaiting = false;
							 } copy]];
}

- (void)testUserMetadataDelete
{
	bwaiting = true;
	[self alogin];
	[self waitloop];

	if (self.user == nil)
	{
		bwaiting = true;
		[self alogin];
		[self waitloop];
	}

	if (self.user == nil)
	{
		STFail(@"testUserMetadataDelete failed to login");
		return;
	}

	bwaiting = true;
	[self atestUserMetadataItemSet];
	[self waitloop];

	bwaiting = true;
	[self atestUserMetadataDelete];
	[self waitloop];
}

- (void)testUserMetadataDeleteAll
{
	bwaiting = true;
	[self alogin];
	[self waitloop];

	if (self.user == nil)
	{
		bwaiting = true;
		[self alogin];
		[self waitloop];
	}

	if (self.user == nil)
	{
		STFail(@"testUserMetadataDeleteAll failed to login");
		return;
	}

	bwaiting = true;
	[self atestUserMetadataItemSet];
	[self waitloop];

	bwaiting = true;
	[self atestUserMetadataDeleteAll];
	[self waitloop];
}

- (void)testUserMetadataSetSumFindGetAndBatchSum
{
	bwaiting = true;
	[self alogin];
	[self waitloop];

	if (self.user == nil)
	{
		bwaiting = true;
		[self alogin];
		[self waitloop];
	}
	if (self.user == nil)
	{
		STFail(@"testUserMetadataSetSumFindGetAndBatchSum failed to login");
		return;
	}

	bwaiting = true;
	[self atestUserMetadataItemSet];
	[self waitloop];

	bwaiting = true;
	[self atestUserMetadataSum];
	[self waitloop];

	bwaiting = true;
	[self atestUserMetadataFind];
	[self waitloop];

	bwaiting = true;
	[self atestUserMetadataGet];
	[self waitloop];

	bwaiting = true;
	[self atestUserMetadataBatchSum];
	[self waitloop];
}

- (void)atestUserMetadataDeleteAll
{
	[self userMetadataDeleteAll:self.user.metadata];
}

- (void)userMetadataDeleteAll:(BuddyUserMetadata *)userMetadata
{
	[userMetadata deleteAll:nil
				   callback:[^(BuddyBoolResponse *response)
							 {
								 if (response.isCompleted && response.result == TRUE)
								 {
									 NSLog(@"userMetadataDeleteAll OK");
									 bwaiting = false;
								 }
								 else
								 {
									 STFail(@"userMetadataDeleteAll failed !response.isCompleted || response.result != TRUE");
								 }
							 } copy]];
}

- (void)atestUserMetadataDelete
{
	[self userMetadataDelete:self.user.metadata];
}

- (void)userMetadataDelete:(BuddyUserMetadata *)userMetadata
{
	[userMetadata delete:@"Xmas" state:nil
				callback:[^(BuddyBoolResponse *response)
						  {
							  if (response.isCompleted && response.result == TRUE)
							  {
								  bwaiting = false;
							  }
							  else
							  {
								  STFail(@"atestUserMetadataDelete failed !response.isCompleted || response.result != TRUE");
							  }
						  } copy]];
}

- (void)atestUserMetadataItemSet
{
	[self userMetadataItemSet:self.user.metadata];
}

- (void)userMetadataItemSet:(BuddyUserMetadata *)userMetadata
{
	[userMetadata set:@"Xmas" value:@"20" latitude:0.0 longitude:0.0 appTag:nil state:nil callback:nil];
	[userMetadata set:@"Xmas1" value:@"20" latitude:0.0 longitude:0.0 appTag:nil state:nil callback:nil];
	[userMetadata set:@"Xmas2" value:@"20" latitude:0.0 longitude:0.0 appTag:nil state:nil callback:nil];

	[self waitloop2];
}

- (void)atestUserMetadataBatchSum
{
	[self userMetadataBatchSum:self.user.metadata];
}

- (void)atestUserMetadataGet
{
	[self userMetadataGet:self.user.metadata];
}

- (void)userMetadataGet:(BuddyUserMetadata *)userMetadata
{
	[userMetadata get:@"Xmas" state:nil
			 callback:[^(BuddyMetadataItemResponse *response)
					   {
						   if (response.isCompleted && response.result != nil)
						   {
							   NSLog(@"Key: %@  value: %@", response.result.key, response.result.value);
							   bwaiting = false;
						   }
						   else
						   {
							   STFail(@"userMetadataGet failed !response.isCompleted || response.result == nil");
						   }
					   } copy]];
}

- (void)atestUserMetadataFind
{
	[self userMetadataFind:self.user.metadata];
}

- (void)userMetadataFind:(BuddyUserMetadata *)userMetadata
{
	NSNumber *searchDistance = [NSNumber numberWithInt:99999999];

	[userMetadata find:searchDistance latitude:0 longitude:0
			  callback:[^(BuddyDictionaryResponse *response)
						{
							if (response.isCompleted && response.result != nil)
							{
								if ([response.result count] == 0)
								{
									STFail(@"userMetadataFind failed no results");
								}
								bwaiting = false;
							}
							else
							{
								STFail(@"userMetadataFind failed !response.isCompleted || response.result == nil");
								bwaiting = false;
							}
						} copy]];
}

- (void)userMetadataBatchSum:(BuddyUserMetadata *)userMetadata
{
	[userMetadata batchSum:@"Xmas;Xmas1;Xmas2"
				  callback:[^(BuddyArrayResponse *response)
							{
								if (response.isCompleted && response.result != nil)
								{
									if ([response.result count] == 0)
									{
										STFail(@"userMetadataBatchSum failed no results");
									}
								}
								else
								{
									STFail(@"userMetadataBatchSum failed !response.isCompleted || response.result == nil");
								}
								bwaiting = false;
							} copy]];
}

- (void)atestUserMetadataSum
{
	[self userMetadataSum:self.user.metadata];
}

- (void)userMetadataSum:(BuddyUserMetadata *)userMetadata
{
	[userMetadata set:@"test1 count1" value:@"20" latitude:0.0 longitude:0.0 appTag:nil state:nil callback:nil];
	[userMetadata set:@"test1 count2" value:@"20" latitude:0.0 longitude:0.0 appTag:nil state:nil callback:nil];
	[userMetadata set:@"test2 count1" value:@"20" latitude:0.0 longitude:0.0 appTag:nil state:nil callback:nil];
	[userMetadata set:@"test2 count2" value:@"20" latitude:0.0 longitude:0.0 appTag:nil state:nil callback:nil];

	[self waitloop2];

	[userMetadata sum:@"test1 count" withinDistance:nil latitude:0.0 longitude:0.0 updatedMinutesAgo:nil withAppTag:nil state:nil
			 callback:[^(BuddyMetadataSumResponse *response)
					   {
						   STAssertNotNil(response, @"userMetadataSum failed response = nil");

						   if (response.isCompleted && response.result != nil)
						   {
							   NSLog(@"userMetadataSum OK total: %f", response.result.total);
						   }
						   else
						   {
							   STFail(@"userMetadataSum failed !response.isCompleted || response.result == nil");
						   }
						   bwaiting = false;
					   } copy]];
}

- (void)testAppSum
{
	[self aAppSetMetadataValues];

	bwaiting = true;
	[self atestAppSumAdd];
	[self waitloop];

	bwaiting = true;
	[self aAppMetadataBatchSum];
	[self waitloop];
}

- (void)aAppSetMetadataValues
{
	[self.buddyClient.metadata set:@"test1" value:@"20" latitude:0.0 longitude:0.0 appTag:nil state:nil callback:nil];
	[self.buddyClient.metadata set:@"test2" value:@"20" latitude:0.0 longitude:0.0 appTag:nil state:nil callback:nil];

	[self waitloop2];
	[self waitloop2];
}

- (void)atestAppSumAdd
{
	[self.buddyClient.metadata sum:@"test" withinDistance:nil latitude:0.0 longitude:0.0 updatedMinutesAgo:nil withAppTag:nil state:nil
						  callback:[^(BuddyMetadataSumResponse *response)
									{
										STAssertNotNil(response, @"atestAppSumAdd failed response = nil");

										if (response.isCompleted && response.result != nil)
										{
											NSLog(@"atestAppSumAdd keyName: %@ total: %f", response.result.keyName, response.result.total);
										}
										else
										{
											STFail(@"atestAppSumAdd failed !response.isCompleted || response.result == nil");
										}
										bwaiting = false;
									} copy]];
}

- (void)aAppMetadataBatchSum
{
	[self.buddyClient.metadata batchSum:@"test;test1;test2"
							   callback:[^(BuddyArrayResponse *response)
										 {
											 if (response.isCompleted && response.result != nil)
											 {
												 if ([response.result count] != 3)
												 {
													 STFail(@"aAppMetadataBatchSum failed expected 3 values returned");
												 }
											 }
											 else
											 {
												 STFail(@"aAppMetadataBatchSum failed !response.isCompleted || response.result == nil");
											 }
											 bwaiting = false;
										 } copy]];
}

- (void)testApplicationMetadataValueGetAll
{
	bwaiting = true;
	[self aApplicationMetadataValueGetAll];
	[self waitloop];
}

- (void)aApplicationMetadataValueGetAll
{
	NSString *key = @"a string";

	[self.buddyClient.metadata getAll:key
							 callback:[^(BuddyDictionaryResponse *response)
									   {
										   STAssertNotNil(response, @"ApplicationMetadataValueGetAll failed response nil");
										   if (response.isCompleted && response.result)
										   {
											   NSString *value = (NSString *)response.state;

											   if (![value isEqualToString:@"a string"])
											   {
												   STFail(@"aApplicationMetadataValueGetAll failed result");
											   }

											   totalItems = [response.result count];
											   NSLog(@"aApplicationMetadataValueGetAll OK count: %d", [response.result count]);
										   }
										   else
										   {
											   STFail(@"aApplicationMetadataValueGetAll failed !response.isCompleted || response.result == nil");
										   }
										   bwaiting = false;
									   } copy]];
}

- (void)testUserMetadataValueGetAll
{
	bwaiting = true;
	[self alogin];
	[self waitloop];

	if (self.user == nil)
	{
		bwaiting = true;
		[self alogin];
		[self waitloop];
	}

	if (self.user == nil)
	{
		STFail(@"testUserMetadataValueGetAll failed to login");
		return;
	}

	bwaiting = true;
	[self atestUserMetadataDeleteAll];
	[self waitloop];

	[self aAppSetMetadataValues];

	bwaiting = true;
	[self aUserMetadataValueGetAll];
	[self waitloop];

	if (totalItems > 0)
	{
		STFail(@"testUserMetadataValueGetAll totalItems > 0");
	}

	bwaiting = true;
	[self atestUserMetadataItemSet];
	[self waitloop];

	bwaiting = true;
	[self aUserMetadataValueGetAll];
	[self waitloop];

	if (totalItems == 0)
	{
		STFail(@"testUserMetadataValueGetAll totalItems == 0");
	}

	bwaiting = true;
	[self atestUserMetadataDeleteAll];
	[self waitloop];

	bwaiting = true;
	[self aUserMetadataValueGetAll];
	[self waitloop];

	if (totalItems > 0)
	{
		STFail(@"testUserMetadataValueGetAll totalItems > 0");
	}
}

- (void)aUserMetadataValueGetAll
{
	[self.user.metadata getAll:nil
					  callback:[^(BuddyDictionaryResponse *response)
								{
									STAssertNotNil(response, @"UserMetadataValueGetAll failed response nil");
									if (response.isCompleted && response.result)
									{
										totalItems = [response.result count];
										NSLog(@"aUserMetadataValueGetAll OK total: %d", totalItems);
									}
									else
									{
										STFail(@"aUserMetadataValueGetAll failed !response.isCompleted || !response.result");
									}
									bwaiting = false;
								} copy]];
}

- (void)testApplicationMetadataValueSetGetDelete
{
	bwaiting = true;
	[self alogin];
	[self waitloop];

	if (self.user == nil)
	{
		bwaiting = true;
		[self alogin];
		[self waitloop];
	}

	if (self.user == nil)
	{
		STFail(@"testApplicationMetadataValueSetGetDelete failed to login");
		return;
	}


	bwaiting = true;
	[self aApplicationMetadataValueSet:@"Xmas" value:@"Tree"];
	[self waitloop];

	bwaiting = true;
	[self aApplicationMetadataValueGet:@"Xmas" value:@"Tree"];
	[self waitloop];

	bwaiting = true;
	[self aApplicationMetadataValueSearch];
	[self waitloop];

	bwaiting = true;
	[self aApplicationMetadataValueDelete:@"Xmas"];
	[self waitloop];

	bwaiting = true;
	[self aApplicationMetadataValueSet:@"Xmas" value:@"FairyTree"];
	[self waitloop];

	bwaiting = true;
	[self aApplicationMetadataValueGetModifyAndDelete:@"Xmas" value:@"FairyTree"];
	[self waitloop];

	bwaiting = true;
	[self aApplicationMetadataValueGetAll];
	[self waitloop];

	if (totalItems == 0)
	{
		STFail(@"testApplicationMetadataValueSetGetDelete totalItems == 0");
	}

	bwaiting = true;
	[self aApplicationMetadataValueDeleteAll];
	[self waitloop];

	bwaiting = true;
	[self atestUserMetadataItemSet];
	[self waitloop];

	bwaiting = true;
	[self aApplicationMetadataValueGetAll];
	[self waitloop];

	if (totalItems > 0)
	{
		STFail(@"testApplicationMetadataValueSetGetDelete totalItems > 0");
	}
}

- (void)aApplicationMetadataValueDeleteAll
{
	[self.buddyClient.metadata deleteAll:nil
								callback:[^(BuddyBoolResponse *response)
										  {
											  STAssertNotNil(response, @"aApplicationMetadataValueDeleteAll failed response nil");
											  if (response.isCompleted && response.result == TRUE)
											  {
												  NSLog(@"aApplicationMetadataValueDeleteAll OK");
											  }
											  else
											  {
												  STFail(@"aApplicationMetadataValueDeleteAll failed !response.isCompleted ||response.result != TRUE");
											  }
											  bwaiting = false;
										  } copy]];
}

- (void)aApplicationMetadataValueSet:(NSString *)name value:(NSString *)val
{
	__block TestAppUserMetadata *_self = self;

	[_self.buddyClient.metadata set:name value:val latitude:0.0 longitude:0.0 appTag:nil state:nil
						   callback:[^(BuddyBoolResponse *response)
									 {
										 STAssertNotNil(response, @"aApplicationMetadataValueSet failed response nil");
										 if (!response.isCompleted || !response.result)
										 {
											 STFail(@"aApplicationMetadataValueSet failed !response.isCompleted || !response.result");
										 }
										 bwaiting = false;
									 } copy]];
}

- (void)aApplicationMetadataValueGet:(NSString *)name value:(NSString *)val
{
	[self.buddyClient.metadata get:name state:nil
						  callback:[^(BuddyMetadataItemResponse *response)
									{
										STAssertNotNil(response, @"aApplicationMetadataValueGet failed response nil");
										if (response.isCompleted && response.result)
										{
											if (![response.result.value isEqualToString:val])
											{
												STFail(@"aApplicationMetadataValueGet failed ![response.result.value isEqualToString:value]");
											}
											else
											{
	                                            // unused variables to help make code coverage results more accurate
												BuddyMetadataItem *bItm = response.result;
												double dub;
												NSString *tmp;

												tmp = bItm.key;
												tmp = bItm.value;
												dub = bItm.latitude;
												dub = bItm.longitude;
												NSDate *date = bItm.lastUpdateOn;
												tmp = bItm.applicationTag;
												dub = bItm.distanceOriginLatitude;
												dub = bItm.distanceOriginLongitude;
												dub = bItm.distanceInKilometers;
												dub = bItm.distanceInMeters;
												dub = bItm.distanceInMiles;
												dub = bItm.distanceInYards;
												date = nil;
											}
										}
										else
										{
											STFail(@"aApplicationMetadataValueGet failed !response.isCompleted || !response.result");
										}
										bwaiting = false;
									} copy]];
}

- (void)aApplicationMetadataValueGetModifyAndDelete:(NSString *)name value:(NSString *)val
{
	[self.buddyClient.metadata get:name state:nil
						  callback:[^(BuddyMetadataItemResponse *response)
									{
										STAssertNotNil(response, @"aApplicationMetadataValueGetModifyAndDelete failed response nil");
										if (response.isCompleted && response.result)
										{
											if (![response.result.value isEqualToString:val])
											{
												STFail(@"ApplicationMetadataValueGetModifyAndDelete failed ![response.result.value isEqualToString:value]");
												bwaiting = false;
											}
											else
											{
												[self aModifyMetadataItem2:response.result];
											}
										}
										else
										{
											STFail(@"aApplicationMetadataValueGetModifyAndDelete failed !response.isCompleted || !response.result");
											bwaiting = false;
										}
									} copy]];
}

- (void)aModifyMetadataItem:(BuddyMetadataItem *)metadataItem
{
	__block BuddyMetadataItem *_metadataItem = metadataItem;

	[metadataItem set:@"newvalue"
			 callback:[^(BuddyBoolResponse *response)
					   {
						   STAssertNotNil(response, @"aModifyMetadataItem2 failed response nil");
						   if (!response.isCompleted || !response.result)
						   {
							   STFail(@"aModifyMetadataItem failed !response.isCompleted || !response.result");
							   bwaiting = false;
						   }
						   else
						   {
							   [self aModifyMetadataItem2:_metadataItem];
						   }
					   } copy]];
}

- (void)aModifyMetadataItem2:(BuddyMetadataItem *)metadataItem
{
	__block BuddyMetadataItem *_metadataItem = metadataItem;

	[metadataItem set:@"anothervalue" latitude:0.0 longitude:0.0 appTag:@"apptag" state:nil
			 callback:[^(BuddyBoolResponse *response)
					   {
						   STAssertNotNil(response, @"aModifyMetadataItem2 failed response nil");
						   if (!response.isCompleted || !response.result)
						   {
							   STFail(@"aModifyMetadataItem2 failed !response.isCompleted || !response.result");
						   }

						   [self aDeleteMetadataItem:_metadataItem];
					   } copy]];
}

- (void)aDeleteMetadataItem:(BuddyMetadataItem *)metadataItem
{
	[metadataItem delete:nil
				callback:[^(BuddyBoolResponse *response)
						  {
							  STAssertNotNil(response, @"aDeleteMetadataItem failed response nil");
							  if (!response.isCompleted || !response.result)
							  {
								  STFail(@"aDeleteMetadataItem failed !response.isCompleted || !response.result");
							  }
							  bwaiting = false;
						  } copy]];
}

- (void)aApplicationMetadataValueDelete:(NSString *)name
{
	[self.buddyClient.metadata delete:name state:nil
							 callback:[^(BuddyBoolResponse *response)
									   {
										   STAssertNotNil(response, @"ApplicationMetadataValueDelete failed response nil");
										   if (!response.isCompleted || !response.result)
										   {
											   STFail(@"ApplicationMetadataValueDelete failed !response.isCompleted || !response.result");
										   }
										   bwaiting = false;
									   } copy]];
}

- (void)aApplicationMetadataValueSearch
{
	NSNumber *searchDistance = [NSNumber numberWithInt:10000];

	[self.buddyClient.metadata find:searchDistance latitude:47.5 longitude:-122.5
						   callback:[^(BuddyDictionaryResponse *response)
									 {
										 STAssertNotNil(response, @"aApplicationMetadataValueSearch failed response nil");
										 if (!response.isCompleted || !response.result)
										 {
											 STFail(@"aApplicationMetadataValueSearch failed !response.isCompleted || !response.result");
										 }
										 bwaiting = false;
									 } copy]];
}

- (void)testApplicationMetadataParseGoodDataTest
{
	NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_AppSearchMetadata"];

	NSDictionary *dict = [self.buddyClient.metadata performSelector:@selector(makeMetadataItemDictionary:) withObject:resArray];

	if ([dict count] != 3)
	{
		STFail(@"testApplicationMetadataParseGoodDataTest failed dict should have 3 items");
	}

	BuddyMetadataItem *metaItem = (BuddyMetadataItem *)[dict objectForKey:@"MyValue"];
	BuddyMetadataItem *metaItem1 = (BuddyMetadataItem *)[dict objectForKey:@"MyValue1"];
	BuddyMetadataItem *metaItem2 = (BuddyMetadataItem *)[dict objectForKey:@"MyValue2"];

	if (metaItem == nil)
	{
		STFail(@"testApplicationMetadataParseGoodDataTest failed  metaItem == nil ");
	}

	if (metaItem1 == nil)
	{
		STFail(@"testApplicationMetadataParseGoodDataTest failed  metaItem1 == nil ");
	}

	if (metaItem2 == nil)
	{
		STFail(@"testApplicationMetadataParseGoodDataTest failed  metaItem2 == nil ");
	}

	if (![metaItem1.value isEqualToString:metaItem2.value])
	{
		STFail(@"testApplicationMetadataParseGoodDataTest failed ![metaItem1.value isEqualToString:metaItem2.value]");
	}

	if ([metaItem.value isEqualToString:metaItem2.value])
	{
		STFail(@"testApplicationMetadataParseGoodDataTest failed [metaItem.value isEqualToString:metaItem2.value]");
	}
}

- (void)testApplicationMetadataParseBadDataTest
{
	NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_AppSearchMetadataBad"];

	NSDictionary *dict = [self.buddyClient.metadata performSelector:@selector(makeMetadataItemDictionary:) withObject:resArray];

	if ([dict count] != 1)
	{
		STFail(@"testApplicationMetadataParseBadDataTest failed dict should have 1 valid item");
	}

	BuddyMetadataItem *metaItem = (BuddyMetadataItem *)[dict objectForKey:@"MyValue"];
	BuddyMetadataItem *metaItem1 = (BuddyMetadataItem *)[dict objectForKey:@"MyValue1"];
	BuddyMetadataItem *metaItem2 = (BuddyMetadataItem *)[dict objectForKey:@"MyValue2"];

	if (metaItem != nil)
	{
		STFail(@"testApplicationMetadataParseBadDataTest failed  metaItem == nil ");
	}

	if (metaItem1 == nil)
	{
		STFail(@"testApplicationMetadataParseBadDataTest failed  metaItem1 == nil ");
	}

	if (metaItem2 != nil)
	{
		STFail(@"testApplicationMetadataParseBadDataTest failed  metaItem2 == nil ");
	}
}

- (void)testApplicationMetadataNoData
{
	NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];

	NSDictionary *dict = [self.buddyClient.metadata performSelector:@selector(makeMetadataItemDictionary:) withObject:resArray];

	if ([dict count] != 0)
	{
		STFail(@"testApplicationMetadataNoData failed dict should have 0 items");
	}

	resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
	dict = [self.buddyClient.metadata performSelector:@selector(makeMetadataItemDictionary:) withObject:resArray];
	if ([dict count] != 0)
	{
		STFail(@"testApplicationMetadataNoData failed dict Test_EmptyData should have 0 items");
	}
}

- (void)testApplicationMetadataSumTest
{
	NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_MetadataSum"];

	NSArray *dict = [self.buddyClient.metadata performSelector:@selector(makeMetadataSumArray:) withObject:resArray];

	if ([dict count] != 2)
	{
		STFail(@"testApplicationMetadataSumTest failed dict should have 2 item2");
	}

	resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
	dict = [self.buddyClient.metadata performSelector:@selector(makeMetadataSumArray:) withObject:resArray];
	if ([dict count] != 0)
	{
		STFail(@"ttestApplicationMetadataSumTest failed dict should have 0 items");
	}


	resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
	dict = [self.buddyClient.metadata performSelector:@selector(makeMetadataSumArray:) withObject:resArray];
	if ([dict count] != 0)
	{
		STFail(@"testApplicationMetadataSumTest failed dict should have 0 items");
	}
}

- (void)testUserMetadataParseGoodDataTest
{
	NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_AppSearchMetadata"];

	bwaiting = true;
	[self alogin];
	[self waitloop];
	if (!self.user)
	{
		STFail(@"testUserMetadataParseGoodDataTest login failed.");
		return;
	}

	NSDictionary *dict = [self.user.metadata performSelector:@selector(makeMetadataItemDictionary:) withObject:resArray];

	if ([dict count] != 3)
	{
		STFail(@"testUserMetadataParseGoodDataTest failed dict should have 3 items");
	}

	BuddyMetadataItem *metaItem = (BuddyMetadataItem *)[dict objectForKey:@"MyValue"];
	BuddyMetadataItem *metaItem1 = (BuddyMetadataItem *)[dict objectForKey:@"MyValue1"];
	BuddyMetadataItem *metaItem2 = (BuddyMetadataItem *)[dict objectForKey:@"MyValue2"];

	if (metaItem == nil)
	{
		STFail(@"testUserMetadataParseGoodDataTest failed  metaItem == nil");
	}

	if (metaItem1 == nil)
	{
		STFail(@"testUserMetadataParseGoodDataTest failed  metaItem1 == nil");
	}

	if (metaItem2 == nil)
	{
		STFail(@"testUserMetadata_ParseGoodDataTest failed  metaItem2 == nil");
	}

	if (![metaItem1.value isEqualToString:metaItem2.value])
	{
		STFail(@"testUserMetadataParseGoodDataTest failed ![metaItem1.value isEqualToString:metaItem2.value]");
	}

	if ([metaItem.value isEqualToString:metaItem2.value])
	{
		STFail(@"testUserMetadata_ParseGoodDataTest failed [metaItem.value isEqualToString:metaItem2.value]");
	}

	if ([metaItem2 compareTo:metaItem1] == 0)
	{
		STFail(@"[metaItem2 compareTo: metaItem1] == 0 ");
	}
	else
	{
		NSLog(@"[metaItem2 compareTo: metaItem1] != 0 ");
	}

	if ([metaItem2 compareTo:metaItem2] == 0)
	{
		NSLog(@"[metaItem2 compareTo: metaItem2] == 0 ");
	}
	else
	{
		STFail(@"[metaItem2 compareTo: metaItem2] != 0 ");
	}
}

- (void)testUserMetadataParseBadDataTest
{
	NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_AppSearchMetadataBad"];

	bwaiting = true;
	[self alogin];
	[self waitloop];
	if (!self.user)
	{
		STFail(@"testUserMetadataNoDataTest login failed.");
		return;
	}

	NSDictionary *dict = [self.user.metadata performSelector:@selector(makeMetadataItemDictionary:) withObject:resArray];

	if ([dict count] != 1)
	{
		STFail(@"testUserMetadataParseBadDataTest failed dict should have 1 valid item");
	}

	BuddyMetadataItem *metaItem = (BuddyMetadataItem *)[dict objectForKey:@"MyValue"];
	BuddyMetadataItem *metaItem1 = (BuddyMetadataItem *)[dict objectForKey:@"MyValue1"];
	BuddyMetadataItem *metaItem2 = (BuddyMetadataItem *)[dict objectForKey:@"MyValue2"];

	if (metaItem != nil)
	{
		STFail(@"testUserMetadataParseBadDataTest failed  metaItem == nil ");
	}

	if (metaItem1 == nil)
	{
		STFail(@"testUserMetadataParseBadDataTest failed  metaItem1 == nil ");
	}

	if (metaItem2 != nil)
	{
		STFail(@"testUserMetadataParseBadDataTest failed  metaItem2 == nil ");
	}
}

- (void)testUserMetadataNoDataTest
{
	NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];

	bwaiting = true;
	[self alogin];
	[self waitloop];
	if (!self.user)
	{
		STFail(@"testUserMetadataNoDataTest login failed.");
		return;
	}

	NSDictionary *dict = [self.user.metadata performSelector:@selector(makeMetadataItemDictionary:) withObject:resArray];

	if (dict == nil || [dict count] != 0)
	{
		STFail(@"testUserMetadataNoDataTest failed dict should have 0 items");
	}

	resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
	dict = [self.user.metadata performSelector:@selector(makeMetadataItemDictionary:) withObject:resArray];

	if (dict == nil || [dict count] != 0)
	{
		STFail(@"testUserMetadataNoDataTest failed dict Test_EmptyData should have 0 items");
	}
}

- (void)testUserMetadataSumTest
{
	NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_MetadataSum"];

	bwaiting = true;
	[self alogin];
	[self waitloop];
	if (!self.user)
	{
		STFail(@"testUserMetadataSumTest login failed.");
		return;
	}

	NSArray *dict = [self.user.metadata performSelector:@selector(makeMetadataSumArray:) withObject:resArray];

	if ([dict count] != 2)
	{
		STFail(@"testUserMetadataSumTest failed dict should have 2 item2");
	}

	resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
	dict = [self.user.metadata performSelector:@selector(makeMetadataSumArray:) withObject:resArray];

	if ([dict count] != 0)
	{
		STFail(@"testUserMetadataSumTest failed dict should have 0 items");
	}

	resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
	dict = [self.user.metadata performSelector:@selector(makeMetadataSumArray:) withObject:resArray];
	if ([dict count] != 0)
	{
		STFail(@"testUserMetadataSumTest failed dict should have 0 items");
	}
}

- (void)aUserMetadataValueSet
{
	[self.buddyClient login:Token state:nil
				   callback:[^(BuddyAuthenticatedUserResponse *response)
							 {
								 if (response.isCompleted && response.result)
								 {
									 [self userMetadataSet:response.result.metadata];
								 }
								 bwaiting = false;
							 } copy]];
}

- (void)userMetadataSet:(BuddyUserMetadata *)userMetadata
{
	[userMetadata set:@"Xmas" value:@"Tree" latitude:0.0 longitude:0.0 appTag:nil state:nil
			 callback:[^(BuddyBoolResponse *response)
					   {
						   STAssertNotNil(response, @"UserMetadataSet:  result nil");
						   if (!response.result == TRUE)
						   {
							   STAssertNotNil(response, @"UserMetadataSet:  !response.result == TRUE ");
						   }
						   bwaiting = false;
					   } copy]];
}

- (void)aUserMetadataValueGet
{
	[self.buddyClient login:Token state:nil
				   callback:[^(BuddyAuthenticatedUserResponse *response)
							 {
								 if (response.isCompleted)
								 {
									 [self userMetadataGet:response.result.metadata];
								 }
								 bwaiting = false;
							 } copy]];
}

- (void)aUserMetadataValueDelete
{
	[self.buddyClient login:Token state:nil
				   callback:[^(BuddyAuthenticatedUserResponse *response)
							 {
								 if (response.isCompleted && response.result)
								 {
									 [self userMetadataDelete:response.result.metadata];
								 }
								 bwaiting = false;
							 } copy]];
}

@end