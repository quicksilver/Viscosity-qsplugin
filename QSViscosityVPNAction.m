//
//  QSViscosityVPNAction.m
//  QSViscosity
//
//  Created by Rob McBroom on 8/2/10.
//  Actions that apply to individual VPN connections
//

#import "QSViscosityVPNAction.h"

@implementation QSViscosityVPNAction

- (QSObject *)connect:(QSObject *)dObject
{
    NSString *scriptSource = [NSString stringWithFormat:@"tell application \"Viscosity\" to connect (connections where name is \"%@\")", [dObject name]];
    NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:scriptSource] autorelease];
    [script executeAndReturnError:nil];
    return nil;
}

- (QSObject *)disconnect:(QSObject *)dObject
{
    NSString *scriptSource = [NSString stringWithFormat:@"tell application \"Viscosity\" to disconnect (connections where name is \"%@\")", [dObject name]];
    NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:scriptSource] autorelease];
    [script executeAndReturnError:nil];
    return nil;
}

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
    NSMutableArray *newActions = [NSMutableArray arrayWithCapacity:1];
    // Is Viscosity running right now?
    bool viscosityRunning = false;
    for (NSRunningApplication *app in [[NSWorkspace sharedWorkspace] runningApplications])
    {
        if ([[app bundleIdentifier] isEqualToString:@"com.viscosityvpn.Viscosity"])
            viscosityRunning = true;
    }
    if (viscosityRunning)
    {
        // running, get state of this connection
        NSString *scriptSource = [NSString stringWithFormat:@"tell application \"Viscosity\" to get state of (connections where name is \"%@\")", [dObject name]];
        NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:scriptSource] autorelease];
        NSString *connectionState = [[script executeAndReturnError:nil] stringValue];
        if([connectionState isEqualToString:@"Connected"])
        {
            // connected
            [newActions addObject:@"QSViscosityDisconnect"];
        } else {
            // not connected
            [newActions addObject:@"QSViscosityConnect"];
        }
    } else {
        // not running
        [newActions addObject:@"QSViscosityConnect"];
    }
    return newActions;
}

@end
