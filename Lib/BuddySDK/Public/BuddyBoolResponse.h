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

#import <Foundation/Foundation.h>
#import "BuddyCallbackParams.h"


/// <summary>
/// Represents a callback response containing a BOOL.
/// </summary>

@interface BuddyBoolResponse : BuddyCallbackParams

/// <summary>
/// Gets the BOOL response value for the callback. TRUE for success FALSE for failure.
/// </summary>
@property (readonly, nonatomic, assign) BOOL result;

@end