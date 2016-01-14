//
//  DQComments.h
//  DQComments
//
//  Created by Jeffrey on 16/1/14.
//  Copyright © 2016年 7. All rights reserved.
//

#import <AppKit/AppKit.h>

@class DQComments;

static DQComments *sharedPlugin;

@interface DQComments : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end