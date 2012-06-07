/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#import "JRPinoL1Object.h"

@interface NSArray (PinoL2PluralToFromDictionary)
- (NSArray*)arrayOfPinoL2PluralObjectsFromPinoL2PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinoL2PluralDictionariesFromPinoL2PluralObjects;
- (NSArray*)arrayOfPinoL2PluralReplaceDictionariesFromPinoL2PluralObjects;
@end

@implementation NSArray (PinoL2PluralToFromDictionary)
- (NSArray*)arrayOfPinoL2PluralObjectsFromPinoL2PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPinoL2PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinoL2PluralArray addObject:[JRPinoL2PluralElement pinoL2PluralObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPinoL2PluralArray;
}

- (NSArray*)arrayOfPinoL2PluralDictionariesFromPinoL2PluralObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoL2PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinoL2PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinoL2PluralReplaceDictionariesFromPinoL2PluralObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinoL2PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinoL2PluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface JRPinoL1Object ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinoL1Object
{
    NSString *_string1;
    NSString *_string2;
    NSArray *_pinoL2Plural;
}
@dynamic string1;
@dynamic string2;
@dynamic pinoL2Plural;
@synthesize canBeUpdatedOrReplaced;

- (NSString *)string1
{
    return _string1;
}

- (void)setString1:(NSString *)newString1
{
    [self.dirtyPropertySet addObject:@"string1"];
    _string1 = [newString1 copy];
}

- (NSString *)string2
{
    return _string2;
}

- (void)setString2:(NSString *)newString2
{
    [self.dirtyPropertySet addObject:@"string2"];
    _string2 = [newString2 copy];
}

- (NSArray *)pinoL2Plural
{
    return _pinoL2Plural;
}

- (void)setPinoL2Plural:(NSArray *)newPinoL2Plural
{
    [self.dirtyArraySet addObject:@"pinoL2Plural"];
    _pinoL2Plural = [newPinoL2Plural copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/pinoL1Object";
        self.canBeUpdatedOrReplaced = YES;
    }
    return self;
}

+ (id)pinoL1Object
{
    return [[[JRPinoL1Object alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRPinoL1Object *pinoL1ObjectCopy =
                [[JRPinoL1Object allocWithZone:zone] init];

    pinoL1ObjectCopy.captureObjectPath = self.captureObjectPath;

    pinoL1ObjectCopy.string1 = self.string1;
    pinoL1ObjectCopy.string2 = self.string2;
    pinoL1ObjectCopy.pinoL2Plural = self.pinoL2Plural;
    // TODO: Necessary??
    pinoL1ObjectCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [pinoL1ObjectCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [pinoL1ObjectCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return pinoL1ObjectCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.pinoL2Plural ? [self.pinoL2Plural arrayOfPinoL2PluralDictionariesFromPinoL2PluralObjects] : [NSNull null])
             forKey:@"pinoL2Plural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)pinoL1ObjectObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRPinoL1Object *pinoL1Object = [JRPinoL1Object pinoL1Object];


    pinoL1Object.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pinoL1Object.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    pinoL1Object.pinoL2Plural =
        [dictionary objectForKey:@"pinoL2Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinoL2Plural"] arrayOfPinoL2PluralObjectsFromPinoL2PluralDictionariesWithPath:pinoL1Object.captureObjectPath] : nil;

    [pinoL1Object.dirtyPropertySet removeAllObjects];
    [pinoL1Object.dirtyArraySet removeAllObjects];
    
    return pinoL1Object;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    if ([dictionary objectForKey:@"string1"])
        self.string1 = [dictionary objectForKey:@"string1"] != [NSNull null] ? 
            [dictionary objectForKey:@"string1"] : nil;

    if ([dictionary objectForKey:@"string2"])
        self.string2 = [dictionary objectForKey:@"string2"] != [NSNull null] ? 
            [dictionary objectForKey:@"string2"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    self.pinoL2Plural =
        [dictionary objectForKey:@"pinoL2Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinoL2Plural"] arrayOfPinoL2PluralObjectsFromPinoL2PluralDictionariesWithPath:self.captureObjectPath] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
    [self.dirtyArraySet setSet:dirtyArraySetCopy];
}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"string1"])
        [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];

    if ([self.dirtyPropertySet containsObject:@"string2"])
        [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];

    return dict;
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dict =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null]) forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null]) forKey:@"string2"];
    [dict setObject:(self.pinoL2Plural ? [self.pinoL2Plural arrayOfPinoL2PluralReplaceDictionariesFromPinoL2PluralObjects] : [NSArray array]) forKey:@"pinoL2Plural"];

    return dict;
}

- (void)replacePinoL2PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinoL2Plural named:@"pinoL2Plural"
                    forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:@"NSString" forKey:@"string1"];
    [dict setObject:@"NSString" forKey:@"string2"];
    [dict setObject:@"NSArray" forKey:@"pinoL2Plural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_pinoL2Plural release];

    [super dealloc];
}
@end