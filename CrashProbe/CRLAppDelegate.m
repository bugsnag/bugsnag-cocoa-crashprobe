/*
 * Copyright (c) 2014 HockeyApp, Bit Stadium GmbH.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Bugsnag/Bugsnag.h>
#import "CRLAppDelegate.h"
#import "CRLMainWindowController.h"

@interface CRLAppDelegate ()

@property(nonatomic,strong) CRLMainWindowController *windowController;

@end

@implementation CRLAppDelegate
#if __i386__ && !TARGET_IPHONE_SIMULATOR
@synthesize window = _window, windowController = _windowController;
#endif

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [Bugsnag startBugsnagWithApiKey:@"API-KEY"];
	self.windowController = [[CRLMainWindowController alloc] init];
	[(self.window = self.windowController.window) makeKeyAndOrderFront:self];
}

@end
