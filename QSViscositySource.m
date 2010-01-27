//
//  QSViscositySource.m
//  QSViscosity
//
//  Created by Rob McBroom on 1/26/10.
//

#import "QSViscositySource.h"
#import <QSCore/QSObject.h>


@implementation QSViscositySource
- (BOOL)indexIsValidFromDate:(NSDate *)indexDate forEntry:(NSDictionary *)theEntry
{
    NSString *path = [@"~/Library/Application Support/Viscosity/OpenVPN" stringByStandardizingPath];
    // directory containing connection details
    NSString *connectionPath = nil;
    // file handler
    NSFileManager *manager = [NSFileManager defaultManager];
    // this should trigger if a connection is added or removed
    NSDate *modified = [[manager attributesOfItemAtPath:path error:NULL] fileModificationDate];
    if ([indexDate compare:modified] == NSOrderedAscending) {
        // trigger a rescan
        return NO;
    }
    NSArray *contents = [manager directoryContentsAtPath:path];
    for (NSString *connectionDirectory in contents)
    {
        connectionPath = [path stringByAppendingPathComponent:connectionDirectory];
        NSDate *modified = [[manager attributesOfItemAtPath:connectionPath error:NULL] fileModificationDate];
        // this should trigger if an existing connection was modified
        if ([indexDate compare:modified] == NSOrderedAscending) {
            // something new - trigger a rescan
            return NO;
        }
    }
    // don't rescan by default
    return YES;
}

- (NSArray *) objectsForEntry:(NSDictionary *)theEntry
{
    NSMutableArray *objects=[NSMutableArray arrayWithCapacity:1];
    QSObject *newObject;
    NSString *path = [@"~/Library/Application Support/Viscosity/OpenVPN" stringByStandardizingPath];
    // directory containing connection details
    NSString *connectionPath = nil;
    // file containing the connection name
    NSString *connectionFile = nil;
    // file handler
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *contents = [manager directoryContentsAtPath:path];
    for (NSString *connectionDirectory in contents)
    {
        connectionPath = [path stringByAppendingPathComponent:connectionDirectory];
        connectionFile = [connectionPath stringByAppendingPathComponent:@"config.conf"];
        NSString *connSource = [NSString stringWithContentsOfFile:connectionFile encoding:NSUTF8StringEncoding error:nil];
        if (!connSource)
        {
            NSLog(@"unable to read Viscosity settings from %@", connectionFile);
            continue;
        }
        
        connSource = [connSource stringByReplacing:@"\n" with:@"\r"];
        NSArray *lines = [connSource componentsSeparatedByString:@"\r"];
        for (NSString *line in lines)
        {
            // look for the line with the name
            /* This is a bit hacky, but we need to find the line somehow anyway,
               and the line needs to be split when it's found, so why not combine
               the steps? Only a line containing the name setting will split into
               more than one item, so that's how we test. */
            NSArray *lineParts = [line componentsSeparatedByString:@"#viscosity name "];
            if ([lineParts count] == 2)
            {
                // this looks like the line with the name
                NSString *connName = [lineParts objectAtIndex:1];
                newObject = [QSObject objectWithName:connName];
                [newObject setObject:connName forType:QSViscosityType];
                [newObject setObject:connName forType:QSTextType];
                [newObject setPrimaryType:QSViscosityType];
                [newObject setIdentifier:[NSString stringWithFormat:@"ViscosityVPNConnection%@", connectionDirectory]];
                [newObject setDetails:@"Viscosity VPN Connection"];
                [objects addObject:newObject];
                
                // no need to process the rest of the lines in the file
                break;
            }
        }
    }
    
    return objects;
}


// Object Handler Methods

- (void)setQuickIconForObject:(QSObject *)object
{
    [object setIcon:[[NSWorkspace sharedWorkspace] iconForFileType:@"visc"]];
}

- (BOOL)loadChildrenForObject:(QSObject *)object
{
    // Viscosity.app should show connections when you right arrow into it
    // but the connections themselves shouldn't
    if (![object containsType:QSViscosityType])
    {
        [object setChildren:[self objectsForEntry:nil]];
        return TRUE;
    }
    return FALSE;
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
