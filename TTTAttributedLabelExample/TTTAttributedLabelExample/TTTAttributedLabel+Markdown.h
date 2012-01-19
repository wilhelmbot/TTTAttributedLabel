//
//  TTTAttributedLabel+Markdown.h
//  TTTAttributedLabelExample
//
//  Created by Rodolfo Wilhelmy on 1/18/12.
//  Copyright (c) 2012 INNKU. All rights reserved.
//

#import "TTTAttributedLabel.h"

@interface TTTAttributedLabel (Markdown)
///-------------------------------------------------------------------------------------
/// @name Setting it as the Text Attribute and applying style using the Markdown syntax 
///-------------------------------------------------------------------------------------

/**
 Parses the text using the Markdown syntax (http://daringfireball.net/projects/markdown/), adds style and sets the text property for the label. 
 
 @param text An `NSString` or `NSAttributedString` object to be displayed by the label. If the specified text is an `NSString`, the label will display the text like a `UILabel`, inheriting the text styles of the label. If the specified text is an `NSAttributedString`, the label text styles will be overridden by the styles specified in the attributed string.
 
 @discussion This method overrides `UILabel -setText:` to accept both `NSString` and `NSAttributedString` objects. This string is `nil` by default.
 */
- (void)setTextWithMarkdownString:(NSString *)markdownString;
@end
