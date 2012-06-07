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


#import "JRPinapinapL1PluralElement.h"

@interface NSArray (PinapinapL2PluralToFromDictionary)
- (NSArray*)arrayOfPinapinapL2PluralObjectsFromPinapinapL2PluralDictionariesWithPath:(NSString*)capturePath;
- (NSArray*)arrayOfPinapinapL2PluralDictionariesFromPinapinapL2PluralObjects;
- (NSArray*)arrayOfPinapinapL2PluralReplaceDictionariesFromPinapinapL2PluralObjects;
@end

@implementation NSArray (PinapinapL2PluralToFromDictionary)
- (NSArray*)arrayOfPinapinapL2PluralObjectsFromPinapinapL2PluralDictionariesWithPath:(NSString*)capturePath
{
    NSMutableArray *filteredPinapinapL2PluralArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPinapinapL2PluralArray addObject:[JRPinapinapL2PluralElement pinapinapL2PluralObjectFromDictionary:(NSDictionary*)dictionary withPath:capturePath]];

    return filteredPinapinapL2PluralArray;
}

- (NSArray*)arrayOfPinapinapL2PluralDictionariesFromPinapinapL2PluralObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapinapL2PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapinapL2PluralElement*)object toDictionary]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPinapinapL2PluralReplaceDictionariesFromPinapinapL2PluralObjects
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPinapinapL2PluralElement class]])
            [filteredDictionaryArray addObject:[(JRPinapinapL2PluralElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface JRPinapinapL1PluralElement ()
@property BOOL canBeUpdatedOrReplaced;
@end

@implementation JRPinapinapL1PluralElement
{
    NSString *_string1;
    NSString *_string2;
    NSArray *_pinapinapL2Plural;
}
@dynamic string1;
@dynamic string2;
@dynamic pinapinapL2Plural;
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

- (NSArray *)pinapinapL2Plural
{
    return _pinapinapL2Plural;
}

- (void)setPinapinapL2Plural:(NSArray *)newPinapinapL2Plural
{
    [self.dirtyArraySet addObject:@"pinapinapL2Plural"];
    _pinapinapL2Plural = [newPinapinapL2Plural copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOrReplaced = NO;
    }
    return self;
}

+ (id)pinapinapL1Plural
{
    return [[[JRPinapinapL1PluralElement alloc] init] autorelease];
}

- (id)copyWithZone:(NSZone*)zone
{ // TODO: SHOULD PROBABLY NOT REQUIRE REQUIRED FIELDS
    JRPinapinapL1PluralElement *pinapinapL1PluralCopy =
                [[JRPinapinapL1PluralElement allocWithZone:zone] init];

    pinapinapL1PluralCopy.captureObjectPath = self.captureObjectPath;

    pinapinapL1PluralCopy.string1 = self.string1;
    pinapinapL1PluralCopy.string2 = self.string2;
    pinapinapL1PluralCopy.pinapinapL2Plural = self.pinapinapL2Plural;
    // TODO: Necessary??
    pinapinapL1PluralCopy.canBeUpdatedOrReplaced = self.canBeUpdatedOrReplaced;
    
    // TODO: Necessary??
    [pinapinapL1PluralCopy.dirtyPropertySet setSet:self.dirtyPropertySet];
    [pinapinapL1PluralCopy.dirtyArraySet setSet:self.dirtyArraySet];

    return pinapinapL1PluralCopy;
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dict setObject:(self.string1 ? self.string1 : [NSNull null])
             forKey:@"string1"];
    [dict setObject:(self.string2 ? self.string2 : [NSNull null])
             forKey:@"string2"];
    [dict setObject:(self.pinapinapL2Plural ? [self.pinapinapL2Plural arrayOfPinapinapL2PluralDictionariesFromPinapinapL2PluralObjects] : [NSNull null])
             forKey:@"pinapinapL2Plural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (id)pinapinapL1PluralObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    if (!dictionary)
        return nil;

    JRPinapinapL1PluralElement *pinapinapL1Plural = [JRPinapinapL1PluralElement pinapinapL1Plural];

    pinapinapL1Plural.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinapinapL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
// TODO: Is this safe to assume?
    pinapinapL1Plural.canBeUpdatedOrReplaced = YES;

    pinapinapL1Plural.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    pinapinapL1Plural.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    pinapinapL1Plural.pinapinapL2Plural =
        [dictionary objectForKey:@"pinapinapL2Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinapL2Plural"] arrayOfPinapinapL2PluralObjectsFromPinapinapL2PluralDictionariesWithPath:pinapinapL1Plural.captureObjectPath] : nil;

    [pinapinapL1Plural.dirtyPropertySet removeAllObjects];
    [pinapinapL1Plural.dirtyArraySet removeAllObjects];
    
    return pinapinapL1Plural;
}

- (void)updateFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [[self.dirtyPropertySet copy] autorelease];
    NSSet *dirtyArraySetCopy    = [[self.dirtyArraySet copy] autorelease];

    self.canBeUpdatedOrReplaced = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinapinapL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

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
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%d", capturePath, @"pinapinapL1Plural", [(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.string1 =
        [dictionary objectForKey:@"string1"] != [NSNull null] ? 
        [dictionary objectForKey:@"string1"] : nil;

    self.string2 =
        [dictionary objectForKey:@"string2"] != [NSNull null] ? 
        [dictionary objectForKey:@"string2"] : nil;

    self.pinapinapL2Plural =
        [dictionary objectForKey:@"pinapinapL2Plural"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pinapinapL2Plural"] arrayOfPinapinapL2PluralObjectsFromPinapinapL2PluralDictionariesWithPath:self.captureObjectPath] : nil;

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
    [dict setObject:(self.pinapinapL2Plural ? [self.pinapinapL2Plural arrayOfPinapinapL2PluralReplaceDictionariesFromPinapinapL2PluralObjects] : [NSArray array]) forKey:@"pinapinapL2Plural"];

    return dict;
}

- (void)replacePinapinapL2PluralArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate withContext:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pinapinapL2Plural named:@"pinapinapL2Plural"
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
    [dict setObject:@"NSArray" forKey:@"pinapinapL2Plural"];

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (void)dealloc
{
    [_string1 release];
    [_string2 release];
    [_pinapinapL2Plural release];

    [super dealloc];
}
@end