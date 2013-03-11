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
#import "TestGames.h"
#import "BuddyCallbackParams.h"
#import "BuddyDataResponses.h"
#import "BuddyBoolResponse.h"
#import "BuddyClient.h"
#import "BuddyGameScores.h"
#import "BuddyGameScore.h"
#import "BuddyGameState.h"
#import "BuddyGameStates.h"
#import "BuddyGamePlayer.h"


@implementation TestGames

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

    STAssertNotNil(self.buddyClient, @"TestGames setUP failed buddyClient nil");
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

- (void)testGamesScores
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
        STFail(@"testGamesScores failed to login");
        return;
    }

    int icount = 2;
    while (icount != 0)
    {
        int r = arc4random();
        NSString *name = [NSString stringWithFormat:@"GameBoard%d", r];
        bwaiting = true;
        [self aAdd:name];
        [self waitloop];

        bwaiting = true;
        [self getGameScores:TRUE];
        [self waitloop];

        bwaiting = true;
        [self findUserScores];
        [self waitloop];

        bwaiting = true;
        [self addaScore];
        [self waitloop];

        bwaiting = true;
        [self addaScore];
        [self waitloop];

        bwaiting = true;
        [self addaScore];
        [self waitloop];

        bwaiting = true;
        [self getGameScores:TRUE];
        [self waitloop];

        bwaiting = true;
        [self findUserScores];
        [self waitloop];

        bwaiting = true;
        [self getHighScores:name];
        [self waitloop];

        bwaiting = true;
        [self deleteGameScores];
        [self waitloop];

        bwaiting = true;
        [self getGameScores:FALSE];
        [self waitloop];

        icount--;
    }
}

- (void)testGamesStates
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
        STFail(@"testGamesStates failed to login");
        return;
    }

    int icount = 2;
    while (icount != 0)
    {
        int r = arc4random();
        NSString *gamename = [NSString stringWithFormat:@"GameName%d", r];
        NSString *gameval = [NSString stringWithFormat:@"Gamevalue%d", r];

        bwaiting = true;
        [self addGameState:gamename val:gameval];
        [self waitloop];

        bwaiting = true;
        [self getState:gamename val:gameval];
        [self waitloop];

        bwaiting = true;
        [self removeGameState:gamename];
        [self waitloop];

        bwaiting = true;
        [self getStateExpectFail:gamename];
        [self waitloop];

        icount--;
    }
}

- (void)testAllGamesStates
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
        STFail(@"testAllGamesStates failed to login");
        return;
    }

    int icount = 2;
    while (icount != 0)
    {
        int r = arc4random();
        NSString *gamename = [NSString stringWithFormat:@"GameName%d", r];
        NSString *gameval = [NSString stringWithFormat:@"Gamevalue%d", r];

        bwaiting = true;
        [self addGameState:gamename val:gameval];
        [self waitloop];

        r = arc4random();
        NSString *gamename2 = [NSString stringWithFormat:@"GameName%d", r];
        NSString *gameval2 = [NSString stringWithFormat:@"Gamevalue%d", r];
        bwaiting = true;
        [self addGameState:gamename2 val:gameval2];
        [self waitloop];

        bwaiting = true;
        [self getAll:gamename v2:gamename2 value1:gameval value2:gameval2];
        [self waitloop];

        r = arc4random();
        gameval2 = [NSString stringWithFormat:@"Gamevalue%d", r];

        bwaiting = true;
        [self updateGameState:gamename2 val:gameval2];
        [self waitloop];

        bwaiting = true;
        [self removeGameState:gamename];
        [self waitloop];

        bwaiting = true;
        [self removeGameState:gamename2];
        [self waitloop];

        icount--;
    }
}

- (void)getAll:(NSString *)gameName1 v2:(NSString *)gameName2 value1:(NSString *)val1 value2:(NSString *)val2
{
    [self.user.gameStates getAll:nil callback:[^(BuddyDictionaryResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"getAll OK");
            NSDictionary *dict = response.result;
            if ([dict count] == 0)
            {
                STFail(@"getAll failed count: 0");
            }

            BuddyGameState *gameState1 = [dict objectForKey:gameName1];
            BuddyGameState *gameState2 = [dict objectForKey:gameName2];

            if ([gameState1.value isEqualToString:val1] == FALSE)
            {
                STFail(@"getAll failed gameState1.value != value1");
            }

            if ([gameState2.value isEqualToString:val2] == FALSE)
            {
                STFail(@"getAll failed gameState2.value != value2");
            }

            bwaiting = false;
        }
        else
        {
            STFail(@"getAll failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)removeGameState:(NSString *)name
{
    [self.user.gameStates remove:name state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"removeGameState OK");
            bwaiting = false;
        }
        else
        {
            STFail(@"removeGameState failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)getStateExpectFail:(NSString *)name
{
    [self.user.gameStates get:name state:nil callback:[^(BuddyGameStateResponse *response)
    {
        if (response.isCompleted && response.result == nil)
        {
            NSLog(@"getStateExpectFail OK");
            bwaiting = false;
        }
        else
        {
            STFail(@"getStateExpectFail failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)getState:(NSString *)name val:(NSString *)val
{
    [self.user.gameStates get:name state:nil callback:[^(BuddyGameStateResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"getState OK");

            if ([val isEqualToString:response.result.value] == FALSE)
            {
                STFail(@"getState failed response.result.value != val");
            }
            else
            {
                // unused variables to help make code coverage results more accurate
                NSString *tmp = response.result.appTag;
                NSDate *date = response.result.addedOn;
                date = nil;
                tmp = response.result.key;
                tmp = response.result.value;
            }
            bwaiting = false;
        }
        else
        {
            STFail(@"getState failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)updateGameState:(NSString *)name val:(NSString *)svalue
{
    [self.user.gameStates update:name gameStateValue:svalue newAppTag:nil state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"updateGameState OK");
            bwaiting = false;
        }
        else
        {
            STFail(@"updateGameState failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)addGameState:(NSString *)name val:(NSString *)value
{
    __block TestGames *_self = self;

    [_self.user.gameStates add:name gameStateValue:value
                      callback:[^(BuddyBoolResponse *response)
                      {
                          if (response.isCompleted && response.result == TRUE)
                          {
                              NSLog(@"addGameState OK");
                              bwaiting = false;
                          }
                          else
                          {
                              STFail(@"addGameState failed  !response.isCompleted || !response.result");
                              bwaiting = false;
                          }
                      } copy]];
}

- (void)getHighScores:(NSString *)boardName
{
    NSNumber *recordLimit = [NSNumber numberWithInt:100];

    [self.buddyClient.gameBoards getHighScores:boardName
                                   recordLimit:recordLimit
                                         state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSArray *array = response.result;
            if ([array count] == 0)
            {
                STFail(@"getHighScores failed count: 0");
            }
            else
            {
                NSLog(@"getHighScores OK");
                if ([array count] > 0)
                {
                    BuddyGameScore *gameScore = [array objectAtIndex:0];

                    NSLog(@"Tagname %@", gameScore.appTag);

                    // unused variables to help make code coverage results more accurate
                    NSString *tmp;
                    double dub;
                    tmp = gameScore.boardName;
                    NSDate *date = gameScore.addedOn;
                    dub = gameScore.latitude;
                    dub = gameScore.longitude;
                    tmp = gameScore.rank;
                    dub = gameScore.score;
                    NSNumber *num = gameScore.userId;
                    tmp = gameScore.userName;
                    tmp = gameScore.appTag;
                    num = nil;
                    date = nil;
                }
            }
            bwaiting = false;
        }
        else
        {
            STFail(@"getHighScores failed !response.isCompleted || !response.result");
            bwaiting = false;
        }
    } copy]];
}

- (void)addaScore
{
    __block TestGames *_self = self;

    [_self.user.gameScores add:100
                      callback:[^(BuddyBoolResponse *response)
                      {
                          if (response.isCompleted && response.result)
                          {
                              NSLog(@"addaScore OK");
                          }
                          else
                          {
                              STFail(@"addaScore failed !response.isCompleted || !response.result");
                          }
                          bwaiting = false;
                      } copy]];
}

- (void)deleteGameScores
{
    [self.user.gameScores deleteAll:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"deleteGameScores OK");
        }
        else
        {
            STFail(@"deleteGameScores failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)aAdd:(NSString *)name
{
    __block TestGames *_self = self;

    [_self.user.gameScores add:100 board:name rank:@"Master" latitude:0 longitude:0
             oneScorePerPlayer:FALSE appTag:@"MyTag" state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"aAdd OK");
        }
        else
        {
            STFail(@"aAdd failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)getGameScores:(BOOL)bFailif0
{
    NSNumber *recordLimit = [NSNumber numberWithInt:100];

    [self.user.gameScores getAll:recordLimit state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSArray *gameScoresArray = response.result;

            if ([gameScoresArray count] == 0 && bFailif0 == TRUE)
            {
                STFail(@"getGameScores failed");
            }
            else
            {
                if ([gameScoresArray count] > 0)
                {
                    BuddyGameScore *gameScore = [gameScoresArray objectAtIndex:0];

                    NSLog(@"getGameScores OK appTag %@", gameScore.appTag);
                }
            }
        }
        else
        {
            STFail(@"getGameScores failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)findUserScores
{
    [self.buddyClient.gameBoards findScores:self.user distanceInMeters:nil latitude:0 longitude:0
                                recordLimit:nil boardName:nil daysOld:nil minimumScore:nil appTag:nil state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSArray *gameScoresArray = response.result;

            if ([gameScoresArray count] == 0)
            {
                STFail(@"findUserScores failed");
            }
            else
            {
                BuddyGameScore *gamescore = [gameScoresArray objectAtIndex:0];

                NSLog(@"findUserScores OK total: %d, appTag: %@", [gameScoresArray count], gamescore.appTag);
            }
        }
        else
        {
            STFail(@"findUserScores failed  !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}

- (void)alogin
{
    [self.buddyClient login:Token state:nil callback:[^(BuddyAuthenticatedUserResponse *response)
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

- (void)testGamesScoresFromSearch
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_GameScoreSearch"];

    NSArray *scores = [self.buddyClient.gameBoards performSelector:@selector(makeScores:) withObject:resArray];

    if (scores == nil || [scores count] != 3)
    {
        STFail(@"testGamesScoresFromSearch failed scores == nil || [scores count] != 3");
    }

    BuddyGameScore *gs1 = (BuddyGameScore *) [scores objectAtIndex:0];
    BuddyGameScore *gs2 = (BuddyGameScore *) [scores objectAtIndex:1];
    BuddyGameScore *gs3 = (BuddyGameScore *) [scores objectAtIndex:1];

    if (gs1.score != gs2.score || gs1.score != gs3.score || gs2.score != gs3.score)
    {
        STFail(@"testGamesScoresFromSearch failed scores should be the same");
    }
}

- (void)testGamesScoresFromSearchNoData
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];

    NSArray *scores = [self.buddyClient.gameBoards performSelector:@selector(makeScores:) withObject:resArray];

    if (scores == nil || [scores count] != 0)
    {
        STFail(@"testGamesScoresFromSearchNoData failed");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];
    scores = [self.buddyClient.gameBoards performSelector:@selector(makeScores:) withObject:resArray];

    if (scores == nil || [scores count] != 0)
    {
        STFail(@"testGamesScoresFromSearchNoDataJson failed EmptyData");
    }
}

- (void)testGamesPlayers
{
    bwaiting = true;
    [self alogin];
    [self waitloop];

    int icount = 2;
    while (icount != 0)
    {
        [self atestGamePlayersFixedDataJson];

        int r = arc4random();
        NSString *name = [NSString stringWithFormat:@"PlayerName%d", r];

        bwaiting = true;
        [self addGamePlayer:name];
        [self waitloop];

        bwaiting = true;
        [self updateGamePlayers:name];
        [self waitloop];

        bwaiting = true;
        [self getInfoGamePlayers:name];
        [self waitloop];

        bwaiting = true;
        [self findGamePlayers];
        [self waitloop];


        bwaiting = true;
        [self deleteGamePlayers:name];
        [self waitloop];

        icount--;
    }
}


- (void)findGamePlayers
{
    NSNumber *find = [NSNumber numberWithInt:-1];
    NSNumber *recordLimit = [NSNumber numberWithInt:-1];
    NSNumber *numberofDays = [NSNumber numberWithInt:-1];

    [self.user.gamePlayers find:find latitude:0.0 longitude:0.0 recordLimit:recordLimit boardName:nil onlyForLastNumberOfDays:numberofDays appTag:nil state:nil callback:[^(BuddyArrayResponse *response)
    {
        if (response.isCompleted && response.result)
        {
            NSLog(@"findGamePlayers OK total: %d", [response.result count]);
            if ([response.result count] > 0)
            {
                BuddyGamePlayer *gamePlayer = [response.result objectAtIndex:0];
                NSLog(@"findGamePlayers name of first: %@", gamePlayer.name);
            }
        }
        else
        {
            STFail(@"findGamePlayers failed !response.isCompleted || !response.result");
        }
        bwaiting = false;
    } copy]];
}


- (void)deleteGamePlayers:(NSString *)name
{
    [self.user.gamePlayers delete:name
                         callback:[^(BuddyBoolResponse *response)
                         {
                             if (response.isCompleted && response.result)
                             {
                                 NSLog(@"deleteGamePlayers OK");
                             }
                             else
                             {
                                 STFail(@"deleteGamePlayers failed !response.isCompleted || !response.result");
                             }
                             bwaiting = false;
                         } copy]];
}

- (void)getInfoGamePlayers:(NSString *)name
{
    [self.user.gamePlayers getInfo:name
                          callback:[^(BuddyGamePlayerResponse *response)
                          {
                              if (response.isCompleted)
                              {
                                  NSLog(@"getInfoGamesPlayers OK name: %@", response.result.name);

                                  // unused variables to help make code coverage results more accurate
                                  NSString *tmp;
                                  double dub;
                                  NSDate *date = response.result.createdOn;
                                  tmp = response.result.boardName;
                                  tmp = response.result.applicationTag;
                                  dub = response.result.latitude;
                                  dub = response.result.longitude;
                                  NSNumber *num = response.result.userId;
                                  dub = response.result.distanceInKilometers;
                                  dub = response.result.distanceInMeters;
                                  dub = response.result.distanceInMiles;
                                  dub = response.result.distanceInYards;
                                  date = nil;
                                  num = nil;
                              }
                              else
                              {
                                  STFail(@"getInfoGamesPlayers failed !response.isCompleted");
                              }
                              bwaiting = false;
                          } copy]];
}

- (void)updateGamePlayers:(NSString *)name
{
    [self.user.gamePlayers update:name board:@"" rank:@"Master" latitude:0 longitude:0 appTag:nil state:nil callback:[^(BuddyBoolResponse *response)
    {
        if (response.isCompleted)
        {
            NSLog(@"updateGamePlayers OK");
        }
        else
        {
            STFail(@"updateGamePlayers failed !response.isCompleted");
        }
        bwaiting = false;
    } copy]];
}

- (void)addGamePlayer:(NSString *)name
{
    __block TestGames *_self = self;

    [_self.user.gamePlayers add:name
                       callback:[^(BuddyBoolResponse *response)
                       {
                           if (response.isCompleted)
                           {
                               NSLog(@"addGamePlayer OK");
                           }
                           else
                           {
                               STFail(@"addGamePlayer failed !response.isCompleted");
                           }
                           bwaiting = false;
                       } copy]];
}

// test the creation of a BuddyPlayers list from fixed json data
- (void)atestGamePlayersFixedDataJson
{
    NSArray *resArray = [TestBuddySDK GetTextFileData:@"Test_NoData"];

    NSArray *data = [self.user.gamePlayers performSelector:@selector(makePlayerList:) withObject:resArray];

    if (data == nil || [data count] != 0)
    {
        STFail(@"atestGamePlayersFixedDataJson _Test_NoData");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_EmptyData"];

    data = [self.user.gamePlayers performSelector:@selector(makePlayerList:) withObject:resArray];
    if (data == nil || [data count] != 0)
    {
        STFail(@"atestGamePlayersFixedDataJson Test_EmptyData");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_PlayerDataBad"];
    data = [self.user.gamePlayers performSelector:@selector(makePlayerList:) withObject:resArray];
    if (data == nil)
    {
        STFail(@"atestGamePlayersFixedDataJson Test_PlayerDataBad");
    }

    resArray = [TestBuddySDK GetTextFileData:@"Test_PlayerDataGood"];
    data = [self.user.gamePlayers performSelector:@selector(makePlayerList:) withObject:resArray];

    if (data == nil || [data count] != 2)
    {
        STFail(@"atestGamePlayersFixedDataJson Test_PlayerDataGood");
    }
}

@end