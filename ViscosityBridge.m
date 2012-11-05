//
//  ViscosityBridge.m
//  QSViscosity
//
//  Created by Rob McBroom on 2012/11/05.
//

#import "ViscosityBridge.h"

static ViscosityApplication *Viscosity;

ViscosityApplication *QSViscosity() {
    if (!Viscosity) {
        Viscosity = [SBApplication applicationWithBundleIdentifier:@"com.viscosityvpn.Viscosity"];
    }
    return Viscosity;
}
