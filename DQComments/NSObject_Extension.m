//
//  NSObject_Extension.m
//  DQComments
//
//  Created by Jeffrey on 16/1/14.
//  Copyright © 2016年 7. All rights reserved.
//


#import "NSObject_Extension.h"
#import "DQComments.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[DQComments alloc] initWithBundle:plugin];
        });
    }
}
@end
