// RootViewController.m
//
// Copyright (c) 2011 Mattt Thompson (http://mattt.me)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RootViewController.h"

#import "AttributedTableViewCell.h"

@implementation RootViewController
@synthesize espressos = _espressos;
@synthesize teas = _teas;

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) {
        return nil;
    }
    
    NSString *teasFilePath = [[NSBundle mainBundle] pathForResource:@"teas" ofType:@"txt"];
    self.teas = [[NSString stringWithContentsOfFile:teasFilePath usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSString *espressosFilePath = [[NSBundle mainBundle] pathForResource:@"espressos" ofType:@"txt"];
    self.espressos = [[NSString stringWithContentsOfFile:espressosFilePath usedEncoding:nil error:nil] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
    return self;
}

- (void)dealloc {
    [_espressos release];
    [_teas release];
    [super dealloc];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Teas & Espressos", nil);
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.teas count];
    } else if (section == 1) {
        return [self.espressos count];
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    if (section == 0) {
        return @"Teas";
    } else if (section == 1) {
        return @"Espressos";
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.section == 0) {
        return [AttributedTableViewCell heightForCellWithText:[self.teas objectAtIndex:indexPath.row]];                
    } else if (indexPath.section == 1) {
        return [AttributedTableViewCell heightForCellWithText:[self.espressos objectAtIndex:indexPath.row]];        
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    AttributedTableViewCell *cell = (AttributedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AttributedTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    if (indexPath.section == 0) {
        cell.summaryText = [self.teas objectAtIndex:indexPath.row];
        [cell styleLabel:cell.summaryLabel usingMarkupLanguage:TTTAttributedLabelMarkupLanguageMarkdown];
    } else if (indexPath.section == 1) {
        cell.summaryText = [self.espressos objectAtIndex:indexPath.row];
        [cell styleLabel:cell.summaryLabel usingMarkupLanguage:TTTAttributedLabelMarkupLanguageMattt];
    }

    cell.summaryLabel.delegate = self;
    cell.summaryLabel.userInteractionEnabled = YES;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    [[[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] autorelease] showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
}

@end
