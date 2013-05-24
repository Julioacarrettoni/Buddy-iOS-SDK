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
#import "TestIdentity.h"
#import "BuddyClient.h"
#import "BuddyIdentityItemSearchResult.h"


@implementation TestIdentity

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

    STAssertNotNil(self.buddyClient, @"TestIdentity failed buddyClient nil");
}

- (void)tearDown
{
    [super tearDown];

    self.buddyClient = nil;
    self.user = nil;
}

- (void)alogin
{
    [self.buddyClient login:Token  callback:[^(BuddyAuthenticatedUserResponse *response)
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

- (void)waitloop
{
    NSDate *loopTil = [NSDate dateWithTimeIntervalSinceNow:15];

    while (bwaiting && [loopTil timeIntervalSinceNow] > 0)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopTil];
}


- (void)testIdentityParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_Identity"];

    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testIdentityParsing login failed.");
        return;
    }

    NSArray *dataout = [self.user.identityValues performSelector:@selector(makeIdentityList:) withObject:resArray];
    if ([dataout count] != 3)
    {
        STFail(@"testIdentityParsing failed makeIdentityList expected 3");
    }

    NSArray *dataout1 = [self.user.identityValues performSelector:@selector(makeIdentitySearchList:) withObject:resArray];
    if ([dataout1 count] != 3)
    {
        STFail(@"testIdentityParsingNoData makeIdentitySearchList expects 3 ");
    }
}

- (void)testIdentityParsingMyList
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_IdentityMyList"];

    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testIdentityParsingMyList login failed.");
        return;
    }

    NSArray *dataout = [self.user.identityValues performSelector:@selector(makeIdentityList:) withObject:resArray];

    if ([dataout count] != 3)
    {
        STFail(@"testIdentityParsingMyList failed makeIdentityList expected 3 ");
    }

    NSArray *dataout1 = [self.user.identityValues performSelector:@selector(makeIdentitySearchList:) withObject:resArray];
    if ([dataout1 count] != 3)
    {
        STFail(@"testIdentityParsingMyList makeIdentitySearchList expects 3 ");
    }

    if ([dataout1 count] > 0)
    {
        BuddyIdentityItemSearchResult *bSrc = [dataout1 objectAtIndex:0];
        BOOL found = bSrc.found;
        NSNumber *num = bSrc.belongsToUserId;
        NSString *val = bSrc.value;
        NSDate *date = bSrc.createdOn;
        date = nil;
        num = nil;
        val = nil;
        found = FALSE;
    }
}

- (void)testIdentityParsingNoData
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];

    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testIdentityParsingNoData login failed.");
        return;
    }

    NSArray *dataout = [self.user.identityValues performSelector:@selector(makeIdentityList:) withObject:resArray];
    if ([dataout count] != 0)
    {
        STFail(@"testIdentityParsingNoData failed makeIdentityList expected 0");
    }

    NSArray *dataout1 = [self.user.identityValues performSelector:@selector(makeIdentitySearchList:) withObject:resArray];
    if ([dataout1 count] != 0)
    {
        STFail(@"testIdentityParsingNoData makeIdentitySearchList expects 0 ");
    }
}

- (void)testIdentityParsingBadData
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_IdentityBad"];

    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testIdentityParsingBadData login failed.");
        return;
    }

    NSArray *dataout = [self.user.identityValues performSelector:@selector(makeIdentityList:) withObject:resArray];
    if ([dataout count] != 3)
    {
        STFail(@"testIdentityParsingBadData failed makeIdentityList expected 3");
    }

    NSArray *dataout1 = [self.user.identityValues performSelector:@selector(makeIdentitySearchList:) withObject:resArray];
    if ([dataout1 count] != 3)
    {
        STFail(@"testIdentityParsingBadData makeIdentitySearchList expects 3");
    }
}

- (void)testIdentityParsingEmptyData
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];

    bwaiting = true;
    [self alogin];
    [self waitloop];

    if (!self.user)
    {
        STFail(@"testIdentityParsingEmptyData login failed.");
        return;
    }

    NSArray *dataout = [self.user.identityValues performSelector:@selector(makeIdentityList:) withObject:resArray];
    if ([dataout count] != 0)
    {
        STFail(@"testIdentityParsingEmptyData expects 0");
    }

    NSArray *dataout1 = [self.user.identityValues performSelector:@selector(makeIdentitySearchList:) withObject:resArray];
    if ([dataout1 count] != 0)
    {
        STFail(@"testIdentityParsingEmptyData makeIdentitySearchList expects 0");
    }
}

- (void)atestIdentityRemove:(BuddyAuthenticatedUser *)buddyuser
{
    [self IdentityRemoveTest:buddyuser];
}

- (void)IdentityRemoveTest:(BuddyAuthenticatedUser *)buddyuser
{
    NSObject *state = [[NSObject alloc] init];

    [buddyuser.identityValues remove:@"John Smith" 
                            callback:[^(BuddyBoolResponse *response)
                            {
                                if (response.isCompleted && response.result == TRUE)
                                {
                                    NSLog(@"IdentityRemoveTest OK");
                                }
                                else
                                {
                                    STFail(@"IdentityRemoveTest failed !response.isCompleted || !response.result");
                                }
                                bwaiting = false;
                            } copy]];
}


- (void)atestStateIdentityRemove:(BuddyAuthenticatedUser *)buddyuser
{
    NSString *state = @"John Smith";
    [self StateIdentityRemoveTest:buddyuser ];
}

- (void)StateIdentityRemoveTest:(BuddyAuthenticatedUser *)buddyuser 
{
    [buddyuser.identityValues remove:@"John Smith" 
                            callback:[^(BuddyBoolResponse *response)
                            {
                                NSString *_state = (NSString *) response.state;
                                if ([_state isEqualToString:@"John Smith"])
                                {
                                    NSLog(@"StateIdentityRemoveTest OK %@", _state);
                                }
                                else
                                {
                                    STFail(@"StateIdentityRemoveTest failed !response.state == John Smith");
                                }
                                bwaiting = false;
                            } copy]];
}


@end
