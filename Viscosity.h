/*
 * Viscosity.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class ViscosityApplication, ViscosityConnection;



/*
 * Viscosity Suite
 */

// 
@interface ViscosityApplication : SBApplication
+ (ViscosityApplication *) application;

- (SBElementArray *) connections;

- (void) connect:(NSString *)x;  // Connect a VPN connection.
- (void) disconnect:(NSString *)x;  // Disconnect a VPN connection.
- (void) connectall;  // Connect all unconnected VPN connections.
- (void) disconnectall;  // Disconnect all connected VPN connections.

@end

// A connection.
@interface ViscosityConnection : SBObject

@property (copy, readonly) NSString *name;  // The name of the connection.
@property (copy, readonly) NSString *state;  // The name of the connection.


@end

