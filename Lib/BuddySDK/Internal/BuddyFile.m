//
//  BuddyFile.m
//  BuddySDK
//
//  Created by Shawn Burke on 5/22/13.
//
//

#import "BuddyFile.h"
#import <UIKit/UIImage.h>

@implementation BuddyFile
@synthesize contentType;
@synthesize fileName;
@synthesize data;

-(id)init {
    return self;
}

-(id) initWithImage:(UIImage *)image {
    
    self.fileName = @"image";
    self.data = UIImageJPEGRepresentation(image, 1.0);
    self.contentType = @"image/jpeg";
    
    return self;
}

-(id)initWithData:(NSData *)d contentType:(NSString *)ct fileName:(NSString*)fn {
    
    self.contentType = ct;
    self.data = d;
    self.fileName = fn;
    return self;
}

@end
