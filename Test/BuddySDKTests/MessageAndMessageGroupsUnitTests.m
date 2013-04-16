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

#import "MessageAndMessageGroupsUnitTests.h"
#import "TestBuddySDK.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"
#import "BuddyMessageGroups.h"
#import "BuddyMessage.h"
#import "BuddyMessageGroup.h"
#import "BuddyGroupMessage.h"


@implementation MessageAndMessageGroupsUnitTests

@synthesize user;
@synthesize buddyClient;

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
    
    STAssertNotNil(self.buddyClient, @"MessageAndMessageGroupsUnitTests: buddyclient nil");
    
    self.user = nil;
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

- (void)alogin
{
    [self.buddyClient login:Token state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
                                                      {
                                                          if (response.isCompleted)
                                                          {
                                                              self.user = response.result;
                                                          }
                                                          else
                                                          {
                                                              STFail(@"alogin  failed !response.isCompleted");
                                                          }
                                                          bwaiting = false;
                                                      } copy]];
}

- (void)testMessageParsing
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGet"];
    
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    if (!self.user)
    {
        STFail(@"testMessageParsing login failed.");
        return;
    }
    
    NSArray *dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsing failed dict should have 2 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsing failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsing failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGetBad"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsing failed dict should have 2 items");
    }
}

- (void)testMessageParsingTo
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGet"];
    
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    if (!self.user)
    {
        STFail(@"testMessageParsingTo login failed.");
        return;
    }
    
    NSArray *dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsingTo failed dict should have 2 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingTo failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingTo failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGetBad"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsingTo failed dict should have 2 items");
    }
}

- (void)testMessageParsingFrom
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGet"];
    
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    if (!self.user)
    {
        STFail(@"testMessageParsingFrom login failed.");
        return;
    }
    
    NSArray *dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsingFrom failed dict should have 2 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingFrom failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingFrom failed dict should have 0 items");
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_MessageListGetBad"];
    dict = [self.user.messages performSelector:@selector(makeMessageList:) withObject:resArray];
    if ([dict count] != 2)
    {
        STFail(@"testMessageParsingFrom failed dict should have 2 items");
    }
}

- (void)testMessageParsingGroups
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_GroupMessagesMembershipGetAllGroups"];
    
    bwaiting = true;
    [self alogin];
    [self waitloop];
    
    if (!self.user)
    {
        STFail(@"testMessageParsingGroups login failed.");
        return;
    }
    
    NSArray *dict = [self.user.messages.groups performSelector:@selector(makeMessageGroupList:) withObject:resArray];
    if ([dict count] != 3)
    {
        STFail(@"testMessageParsingGroups failed dict should have 3 items");
    }
    else
    {
        BuddyMessageGroup *pMG = (BuddyMessageGroup *) [dict objectAtIndex:0];
        
        NSArray *messageArray = [TestBuddySDK GetTextFileData:@"Test_GroupMessage"];
        if ([messageArray count] > 0)
        {
            NSArray *aryGroupsMessage = [pMG performSelector:@selector(makeGroupMessageList:) withObject:messageArray];
            if ([aryGroupsMessage count] > 0)
            {
                BuddyGroupMessage *bgm = (BuddyGroupMessage *) [aryGroupsMessage objectAtIndex:0];
                NSString *tmp;
                double dub;
                tmp = bgm.text;
                dub = bgm.latitude;
                dub = bgm.longitude;
                NSNumber *num = bgm.fromUserID;
                NSDate *date = bgm.dateSent;
                date = nil;
                num = nil;
            }
        }
    }
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];
    dict = [self.user.messages.groups performSelector:@selector(makeMessageGroupList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingGroups failed dict should have 0 items");
    }
    
    
    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    dict = [self.user.messages.groups performSelector:@selector(makeMessageGroupList:) withObject:resArray];
    if ([dict count] != 0)
    {
        STFail(@"testMessageParsingGroups failed dict should have 0 items");
    }
}

@end