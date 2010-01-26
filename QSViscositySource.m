//
//  QSViscositySource.m
//  QSViscosity
//
//  Created by Rob McBroom on 1/26/10.
//  Copyright ADESA 2010. All rights reserved.
//

#import "QSViscositySource.h"
#import <QSCore/QSObject.h>


@implementation QSViscositySource
- (BOOL)indexIsValidFromDate:(NSDate *)indexDate forEntry:(NSDictionary *)theEntry
{
    return YES;
}

- (NSArray *) objectsForEntry:(NSDictionary *)theEntry
{
    NSMutableArray *objects=[NSMutableArray arrayWithCapacity:1];
    QSObject *newObject;
    
    newObject=[QSObject objectWithName:@"ADESA VPN"];
    [newObject setObject:@"ADESA" forType:QSViscosityType];
    [newObject setObject:@"ADESA" forType:QSTextType];
    [newObject setPrimaryType:QSViscosityType];
    [newObject setIdentifier:@"viscosityconnection1"];
    [newObject setDetails:@"Viscosity VPN Connection"];
    [objects addObject:newObject];
    
    return objects;
}


// Object Handler Methods

- (void)setQuickIconForObject:(QSObject *)object
{
    [object setIcon:[[NSWorkspace sharedWorkspace] iconForFileType:@"visc"]];
}
/*
- (BOOL)loadIconForObject:(QSObject *)object{
    return NO;
    id data=[object objectForType:kQSViscosityType];
    [object setIcon:nil];
    return YES;
}
*/
@end
