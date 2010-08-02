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
    // check for running app
    // if (!QSAppIsRunning(@"com.viscosityvpn.Viscosity") ) return nil;
    NSString *scriptSource = [NSString stringWithFormat:@"tell application \"Viscosity\" to get state of (connections where name is \"%@\")", [dObject name]];
    NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:scriptSource] autorelease];
    NSString *connectionState = [[script executeAndReturnError:nil] stringValue];
    NSLog(@"Viscosity Module: State of %@ is %@", [dObject name], connectionState);
    return [NSArray arrayWithObjects:@"QSViscosityConnect", @"QSViscosityDisconnect", nil];
}

@end
