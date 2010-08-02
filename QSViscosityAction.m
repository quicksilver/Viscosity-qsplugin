//
//  QSViscosityAction.m
//  QSViscosity
//
//  Created by Rob McBroom on 1/26/10.
//  Actions that apply to Viscosity overall
//

#import "QSViscosityAction.h"

@implementation QSViscosityAction

- (QSObject *)connectAll:(QSObject *)dObject
{
    NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:@"tell application \"Viscosity\" to connectall"] autorelease];
    [script executeAndReturnError:nil];
    return nil;
}

- (QSObject *)disconnectAll:(QSObject *)dObject
{
    NSAppleScript *script = [[[NSAppleScript alloc] initWithSource:@"tell application \"Viscosity\" to disconnectall"] autorelease];
    [script executeAndReturnError:nil];
    return nil;
}

- (NSArray *)validActionsForDirectObject:(QSObject *)dObject indirectObject:(QSObject *)iObject
{
    // we only want these to show up if the Viscosity application
    // is the direct object in the first pane
    
    // get the path of the object
    NSString *path = [dObject objectForType:QSFilePathType];
    // get the bundle identifier for the thing at this path
    NSString *bundleIdentifier = [[NSBundle bundleWithPath:path] bundleIdentifier];
    if( [bundleIdentifier isEqualToString:@"com.viscosityvpn.Viscosity"])
    {
        // return names of all the Viscosity specific actions
        return [NSArray arrayWithObjects:@"QSViscosityConnectAll", @"QSViscosityDisconnectAll", nil];
    }
}

@end
