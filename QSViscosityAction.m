//
//  QSViscosityAction.m
//  QSViscosity
//
//  Created by Rob McBroom on 1/26/10.
//  Actions that apply to Viscosity overall
//

#import "QSViscosityAction.h"

@implementation QSViscosityAction

- (id)init
{
    self = [super init];
    if (self) {
        Viscosity = [QSViscosity() retain];
    }
    return self;
}

- (void)dealloc
{
    [Viscosity release];
    [super dealloc];
}

#pragma mark Quicksilver Actions

- (QSObject *)connectAll:(QSObject *)dObject
{
    [Viscosity connectall];
    return nil;
}

- (QSObject *)disconnectAll:(QSObject *)dObject
{
    [Viscosity disconnectall];
    return nil;
}

#pragma mark Quicksilver Validation

- (NSArray *)validActionsForDirectObject:(QSObject *)dObject indirectObject:(QSObject *)iObject
{
    // these are set up as "application actions", which don't support validation as of 3936
    // but if that ever gets fixed, this will take care of it
    if ([Viscosity isRunning]) {
        return [NSArray arrayWithObject:@"QSViscosityDisconnectAll"];
    }
    return nil;
}

@end
