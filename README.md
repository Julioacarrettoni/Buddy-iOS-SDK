# Buddy SDK

## Introduction

Buddy enables developers to build engaging, cloud-connected apps without having to write, test, manage or scale server-side code or infrastructure. We noticed that most mobile app developers end up writing the same code over and over again.  User management, photo management, geolocation checkins, metadata, and more.  

Buddy's easy-to-use, scenario-focused APIs let you spend more time building your app, and less time worrying about backend infrastructure.  

Let us handle that stuff for you!

## Features

For developers the Buddy Platform offers turnkey support for features like the following:

* *User Accounts* - create, delete, authenticate users.
* *Photos* - add photos, search photos, share photos with other users.
* *GeoLocation* - checkin, search for places, list past checkins.
* *Push Notifications* - easily send push notifications to iOS, Android, or Microsoft devices.
* *Messaging* - send messages to other users, create message groups.
* *Friends* - set up social relationships between users with friends lists.
* *Game Scores, Metadata, and Boards* - Keep track of game stores and states for individual users as well as across users.
* *Commerce* - Offer items for in-app purchase via Facebook Commerce.
* *And more* - Checkout the rest of the offering at [buddy.com/developers](http://buddy.com/developers/).

## Getting Started

Building the Buddy SDK will result in a file called libBuddySdk.a, which can be found in the "Products" folder of your Xcode project. 
There are actually several flavors of this file, which you can find by ctrl-clicking on libBuddySdk.a and choosing "Show In Finder".

Once you've got the libBuddySDK.a file, perform the following steps to use it with your new iOS project.

1. Drag the libBuddySDK.a file onto the project in the Xcode Project Navigator.  A dialog will pop up when you add the file, choose the default actions (copy files to destination group, create groups...)
2. Drag the "include" folder onto the project source node of the Project Navigator.  Choose the default options, as in #1.  If you'd like, you can rename this folder to "BuddySDK", this is optional.
3. Try the code sample below!


## How It works

Getting rolling with the Buddy SDK is very easy.  First you'll need to go to [dev.buddy.com](http://dev.buddy.com), to create an account and an application.  This will create an application entry and a key pair consisting of an *Application Name* and an *Application Password*.

Once you have those, you just create a BuddyClient instance, and call methods on it.

Below is some code showing the creation of a user, then uploading a profile photo for that user.

### Code Sample


    // visit dev.buddy.com to get an app name and password
    BuddyClient *buddyClient = [[BuddyClient alloc] initClient:kBuddyApplicationName
                                                   appPassword:kBuddyApplicationPassword];

    [buddyClient login:@"a username"
              password:@"the password"
              callback:^(BuddyAuthenticatedUserResponse *response) {
                     BuddyAuthenticatedUser *buddyUser = response.result;
                     if (buddyUser)
                     {
                         NSLog(@"User Login successfull with Token: %@", buddyUser.token);
                     }
                     else
                     {
                         NSLog(@"User Login failed");
                     }
                }
    ];
    



## Docs

Full documentation for Buddy's services are available at [Buddy.com](http://buddy.com/documentation), and iOS library docs are available at [http://buddy.com/iossdk](http://buddy.com/iossdk)

## Contributing Back: Pull Requests

We'd love to have your help making the Buddy SDK as good as it can be!

To submit a fix to the Buddy SDK please do the following:

1. Create your own fork of the Buddy SDK
2. Make the fix to your fork
3. Before creating your pull request, please sync your repo to the current state of the parent repo: ```git pull --rebase origin master```
4. Commit your changes, then [submit a pull request](https://help.github.com/articles/using-pull-requests) for just that commit.


## License

#### Copyright (C) 2012 Buddy Platform, Inc.


Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License. You may obtain a copy of
the License at

  [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations under
the License.

