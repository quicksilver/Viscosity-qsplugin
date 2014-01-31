//
//  QSViscosityVPNAction.m
//  QSViscosity
//
//  Created by Rob McBroom on 8/2/10.
//  Actions that apply to individual VPN connections
//

#import "QSViscosityVPNAction.h"

@implementation QSViscosityVPNAction

- (id)init
{
    self = [super init];
    if (self) {
        Viscosity = QSViscosity();
    }
    return self;
}

#pragma mark Quicksilver Actions

- (QSObject *)connect:(QSObject *)dObject
{
    [Viscosity connect:[dObject objectForType:QSViscosityType]];
    NSDictionary *info = @{@"object": dObject};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QSEventNotification" object:@"QSViscosityVPNConnect" userInfo:info];
    return nil;
}

- (QSObject *)disconnect:(QSObject *)dObject
{
    [Viscosity disconnect:[dObject objectForType:QSViscosityType]];
    NSDictionary *info = @{@"object": dObject};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QSEventNotification" object:@"QSViscosityVPNDisconnect" userInfo:info];
    return nil;
}

#pragma mark Quicksilver Validation

- (NSArray *)validActionsForDirectObject:(QSObject *)dObject indirectObject:(QSObject *)iObject
{
    /*
    We want something like this:
       If Viscosity isn't running, offer only the "connect" action.
       If Viscosity is running, check the state of the connection and
         If the connection is active, offer "disconnect".
         If the connection isn't active, offer "connect".
    So only one or the other should ever show up.
    */
    if ([Viscosity isRunning])
    {
        // running, get state of this connection
        NSString *scriptSource = [NSString stringWithFormat:@"tell application \"Viscosity\" to get state of (connections where name is \"%@\")", [dObject name]];
        NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptSource];
        NSString *connectionState = [[script executeAndReturnError:nil] stringValue];
        if([connectionState isEqualToString:@"Connected"])
        // hopefully we can use this instead one day
        //ViscosityConnection *connection = [self viscosityConnectionFrom:dObject];
        //if ([[connection state] isEqualToString:@"Connected"])
        {
            // connected
            return [NSArray arrayWithObject:@"QSViscosityDisconnect"];
        } else {
            // not connected
            return [NSArray arrayWithObject:@"QSViscosityConnect"];
        }
    } else {
        // not running
        return [NSArray arrayWithObject:@"QSViscosityConnect"];
    }
    return nil;
}

#pragma mark Helper Methods

- (ViscosityConnection *)viscosityConnectionFrom:(QSObject *)object
{
    // currently broken - [Viscosity connections] is empty
    NSString *connectionName = [object objectForType:QSViscosityType];
    return [[Viscosity connections] objectWithName:connectionName];
}

@end
