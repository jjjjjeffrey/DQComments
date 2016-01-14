//
//  DQComments.m
//  DQComments
//
//  Created by Jeffrey on 16/1/14.
//  Copyright © 2016年 7. All rights reserved.
//

#import "DQComments.h"

@interface DQComments()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic,copy) NSString *selectedText;

@property (nonatomic, strong, nullable) NSTextView *textView;
@property (nonatomic) NSRange selectedRange;

@end

@implementation DQComments

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(selectionDidChange:)
                                                     name:NSTextViewDidChangeSelectionNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Add Property Comments" action:@selector(doMenuAction) keyEquivalent:@"C"];
        [actionMenuItem setKeyEquivalentModifierMask:NSAlternateKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

-(void) selectionDidChange:(NSNotification *)noti {
    if ([[noti object] isKindOfClass:[NSTextView class]]) {
        NSTextView* textView = (NSTextView *)[noti object];
        self.textView = textView;
        NSArray* selectedRanges = [textView selectedRanges];
        if (selectedRanges.count==0) {
            return;
        }
        
        self.selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        NSString* text = textView.textStorage.string;
        self.selectedText = [text substringWithRange:self.selectedRange];
        
    }

}

- (void)doMenuAction
{
    if (self.selectedText) {
        NSArray *lines = [self.selectedText componentsSeparatedByString:@"\n"];
        NSInteger maxLength = 0;
        for (NSString *line in lines) {
            maxLength = line.length > maxLength ? line.length : maxLength;
        }
        NSMutableString *muLines = [NSMutableString new];
        for (NSString *line in lines) {
            NSInteger numOfSpace = maxLength - line.length;
            NSString *newLine = [self addCommentsNum:numOfSpace toString:line];
            [muLines appendString:newLine];
        }

        if ([self.textView shouldChangeTextInRange:self.selectedRange replacementString:muLines]) {
            [self.textView.textStorage replaceCharactersInRange:self.selectedRange withString:muLines];
            [self.textView didChangeText];
        }
        
    }
}

- (NSString *)addCommentsNum:(NSInteger)numOfSpace toString:(NSString *)string {
    NSMutableString *muString = [[NSMutableString alloc] initWithString:string];
    if ([string isEqualToString:@""]) {
        [muString appendString:@"\n"];
    } else {
        for (NSInteger i = 0; i < numOfSpace; i++) {
            [muString appendString:@" "];
        }
        [muString appendString:@"//\n"];
    }
    
    
    return muString;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
