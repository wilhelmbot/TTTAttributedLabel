//
//  TTTAttributedLabel+Markdown.m
//  TTTAttributedLabelExample
//
//  Created by Rodolfo Wilhelmy on 1/18/12.
//  Copyright (c) 2012 INNKU. All rights reserved.
//

#import "TTTAttributedLabel+Markdown.h"

// Regular expressions for Markdown
static NSRegularExpression *__markdownBoldRegex;
static inline NSRegularExpression * MarkdownBoldRegex() {
    if (!__markdownBoldRegex) {
        // From MDKStringConverter.m at https://github.com/csm/MarkdownKit
        __markdownBoldRegex = [[NSRegularExpression alloc] initWithPattern:@"(\\*\\*|__)(?=\\S)([^\\r]*?\\S[*_]*)\\1" options:NSRegularExpressionCaseInsensitive error:nil];
    }
    return __markdownBoldRegex;
};

@implementation TTTAttributedLabel (Markdown)

- (void)setTextWithMarkdownString:(NSString *)markdownString
{
    [self setText:markdownString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
        NSRegularExpression *regexp = MarkdownBoldRegex();
        NSRange nameRange = [regexp rangeOfFirstMatchInString:[mutableAttributedString string] options:0 range:stringRange];
        UIFont *bolderFont = [UIFont fontWithName:[self.font.fontName stringByAppendingString:@"-Bold"] size:self.font.pointSize];
        
        CTFontRef boldFont = CTFontCreateWithName((CFStringRef)bolderFont.fontName, bolderFont.pointSize, NULL);
        if (boldFont) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)boldFont range:nameRange];
            CFRelease(boldFont);
        }        
        
        return mutableAttributedString;
    }];    
}

@end
