//
//  CRLApplication.m
//  CrashProbe
//
//  Created by Delisa on 1/28/16.
//  Copyright © 2016 Bit Stadium GmbH. All rights reserved.
//

#import <Bugsnag/Bugsnag.h>
#import "CRLApplication.h"

@implementation CRLApplication

- (void)reportException:(NSException *)theException {
    [Bugsnag notify:theException];
    [super reportException:theException];
}

@end
