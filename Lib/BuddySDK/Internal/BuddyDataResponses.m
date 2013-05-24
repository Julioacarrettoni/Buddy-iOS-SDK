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


#import "BuddyDataResponses_Exn.h"
#import "BuddyUtility.h"


@implementation BuddyDataResponses

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(id)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
  
	self = [super initWithParam:FALSE exception:exception ];
  
	return self; 
}



@end


@implementation BuddyStringResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(NSString *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
  
	self = [super initWithParam:FALSE exception:exception ];
   
	return self; 
}


@end


@implementation BuddyArrayResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(NSArray *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
	
	self = [super initWithParam:FALSE exception:exception ];
   
   return self; 
}



@end


@implementation BuddyDictionaryResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(NSDictionary *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
    
	self = [super initWithParam:FALSE exception:exception ];
   
	return self; 
}



@end


@implementation BuddyVirtualAlbumResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyVirtualAlbum *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
    
	self = [super initWithParam:FALSE exception:exception ];
 
	return self; 
}



@end


@implementation BuddyMetadataSumResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyMetadataSum *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
  
	self = [super initWithParam:FALSE exception:exception ];
   
	return self; 
}



@end


@implementation BuddyPhotoAlbumResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyPhotoAlbum *)data
{
	if (callbackParams.isCompleted &&  data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
   
	self = [super initWithParam:FALSE exception:exception ];
 
	return self; 
}



@end


@implementation BuddyPictureResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyPicture *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
   
	self = [super initWithParam:FALSE exception:exception ];
  
	return self; 
}



@end


@implementation BuddyGamePlayerResponse

@synthesize result;

- (id)initCompletedWithResponse:(BuddyCallbackParams *)callbackParams
						 result:(BuddyGamePlayer *)data
{
	if (callbackParams.isCompleted)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyGamePlayer *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
 
	self = [super initWithParam:FALSE exception:exception ];
   
	return self; 
}


@end


@implementation BuddyAuthenticatedUserResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyAuthenticatedUser *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];

    self = [super initWithParam:FALSE exception:exception ];

    return self; 
}



@end


@implementation BuddyPlaceResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyPlace *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
 
	self = [super initWithParam:FALSE exception:exception ];
 
	return self; 
}



@end


@implementation BuddyGameStateResponse

@synthesize result;

- (id)initCompletedWithResponse:(BuddyCallbackParams *)callbackParams
						 result:(BuddyGameState *)data
{
	if (callbackParams.isCompleted)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyGameState *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
  
	self = [super initWithParam:FALSE exception:exception ];
 
	return self; 
}


@end


@implementation BuddyNSNumberResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(NSNumber *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];

    self = [super initWithParam:FALSE exception:exception ];

    return self; 
}


@end


@implementation BuddyMetadataItemResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyMetadataItem *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
  
    self = [super initWithParam:FALSE exception:exception ];
   
    return self; 
}


@end

@implementation BuddyVideoResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
                result:(BuddyVideo *)data
{
    if(callbackParams.isCompleted && data != nil)
    {
        self = [super initTrueWithState:callbackParams.state];
        result = data;
    }
    else
    {
        self = [super initWithError:callbackParams];
    }
    
    return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
    
	self = [super initWithParam:FALSE exception:exception state:callbackParams.state];
    
	return self;
}

- (id)initWithError:(NSString *)apiCall
             reason:(NSString *)errorString
			  state:(NSObject *)state
{
    NSException *exception = [BuddyUtility makeException:apiCall errorString:errorString];
    
	self = [super initWithParam:FALSE exception:exception state:state];
    
	return self;
}

@end

@implementation BuddyBlobResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
                result:(BuddyBlob *)data
{
    if(callbackParams.isCompleted && data != nil)
    {
        self = [super initTrueWithState:callbackParams.state];
        result = data;
    }
    else
    {
        self = [super initWithError:callbackParams];
    }
    
    return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
    
	self = [super initWithParam:FALSE exception:exception state:callbackParams.state];
    
	return self;
}

- (id)initWithError:(NSString *)apiCall
             reason:(NSString *)errorString
			  state:(NSObject *)state
{
    NSException *exception = [BuddyUtility makeException:apiCall errorString:errorString];
    
	self = [super initWithParam:FALSE exception:exception state:state];
    
	return self;
}
@end

@implementation BuddyUserResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyUser *)data
{
	if (callbackParams.isCompleted &&  data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];

    self = [super initWithParam:FALSE exception:exception ];

    return self; 
}


@end


@implementation BuddyMessageGroupResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(BuddyMessageGroup *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
   
    self = [super initWithParam:FALSE exception:exception ];
 
    return self; 
}


@end


@implementation BuddyDateResponse

@synthesize result;

- (id)initWithResponse:(BuddyCallbackParams *)callbackParams
				result:(NSDate *)data
{
	if (callbackParams.isCompleted && data != nil)
	{
		self = [super initTrueWithState:nil];
		result = data;
	}
	else
	{
		self = [super initWithError:callbackParams];
	}
    
	return self;
}

- (id)initWithError:(BuddyCallbackParams *)callbackParams
			 reason:(NSString *)errorString
{
    NSException *exception = [BuddyUtility makeException:callbackParams.apiCall errorString:errorString];
   
    self = [super initWithParam:FALSE exception:exception ];
   
    return self; 
}

- (id)initWithError:(NSString *)apiCall    
             reason:(NSString *)errorString
              state: (NSObject *)state
{
    NSException *exception = [BuddyUtility makeException:apiCall errorString:errorString];
 
    self = [super initWithParam:FALSE exception:exception ];
   
    return self; 
}

@end