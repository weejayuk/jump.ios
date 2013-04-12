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

#import "JRCaptureError.h"
#import "JRCaptureUser.h"
#import "JRCaptureUser+Extras.h"

#define between(a, b, c) ((a >= b && a < c) ? YES : NO)

NSString *const kJRCaptureErrorDomain = @"JRCapture.ErrorDomain";

@implementation JRCaptureError
- (BOOL)isMergeFlowError
{
    return self.code == 3380;
}

- (BOOL)isTwoStepRegFlowError
{
    return self.code == 3310;
}

- (NSString *)existingProvider
{
    return [self.userInfo objectForKey:@"existing_provider"];
}

- (NSString *)conflictedProvider
{
    return [self.userInfo objectForKey:@"provider"];
}

- (NSString *)mergeToken
{
    return [self.userInfo objectForKey:@"merge_token"];
}

- (JRCaptureUser *)preRegistrationRecord
{
    NSDictionary *preregAttrs = [self.userInfo objectForKey:@"prereg_attributes"];
    if (!preregAttrs) return nil;
    return [JRCaptureUser captureUserObjectFromDictionary:preregAttrs];
}
@end

@implementation JRCaptureError (JRCaptureError_Builders)
+ (JRCaptureError *)invalidApiResponseErrorWithString:(NSString *)rawResponse
{
    NSString *desc = [NSString stringWithFormat:@"The Capture API request response was not well formed"];
    NSNumber *code = [NSNumber numberWithInteger:JRCaptureWrappedEngageErrorInvalidEndpointPayload];
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 @"error", @"stat",
                                                 @"invalid_endpoint_response", @"error",
                                                 desc, @"error_description",
                                                 code, @"code",
                                                 rawResponse, @"raw_response",
                                                 nil];
    return [JRCaptureError errorFromResult:result onProvider:nil mergeToken:nil];
}

+ (JRCaptureError *)invalidApiResponseErrorWithObject:(id)rawResponse
{
    NSString *desc = [NSString stringWithFormat:@"The Capture API request response was not well formed"];
    NSNumber *code = [NSNumber numberWithInteger:JRCaptureWrappedEngageErrorInvalidEndpointPayload];
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 @"error", @"stat",
                                                 @"invalid_endpoint_response", @"error",
                                                 desc, @"error_description",
                                                 code, @"code",
                                                 rawResponse, @"raw_response",
                                                 nil];
    return [JRCaptureError errorFromResult:result onProvider:nil mergeToken:nil];
}

+ (JRCaptureError *)errorWithErrorString:(NSString *)error code:(NSInteger)code description:(NSString *)description
                             extraFields:(NSDictionary *)extraFields
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   error, NSLocalizedDescriptionKey,
                                                   description, NSLocalizedFailureReasonErrorKey, nil];

    [userInfo addEntriesFromDictionary:extraFields];
    return [[[JRCaptureError alloc] initWithDomain:kJRCaptureErrorDomain code:code userInfo:userInfo] autorelease];
}

+ (JRCaptureError *)errorFromResult:(NSDictionary *)result onProvider:(NSString *)onProvider
                         mergeToken:(NSString *)mergeToken
{
    NSString *errorDescription = [result objectForKey:@"error_description"];
    NSString *errorString = [result objectForKey:@"error"];
    NSNumber *code = [result objectForKey:@"code"];
    NSString *rawResponse = [result objectForKey:@"raw_response"];
    NSMutableDictionary *extraFields = [NSMutableDictionary dictionaryWithObjectsAndKeys:onProvider, @"provider",
                                                                                         mergeToken, @"merge_token",
                                                                                         rawResponse, @"raw_response",
                                                                                         nil];

    if (between([code integerValue], GENERIC_ERROR_RANGE, LOCAL_APID_ERROR_RANGE))
        return [self errorWithErrorString:errorString code:[code integerValue] description:errorDescription
                              extraFields:extraFields];

    if (between([code integerValue], LOCAL_APID_ERROR_RANGE, APID_ERROR_RANGE))
        return [self errorWithErrorString:errorString code:[code integerValue] description:errorDescription
                              extraFields:extraFields];

    if ([code integerValue] > CAPTURE_WRAPPED_ENGAGE_ERROR_RANGE)
        return [self errorWithErrorString:errorString code:[code integerValue] description:errorDescription
                              extraFields:extraFields];

    switch ([code integerValue])
    {
        case 100: /* 'missing_argument' A required argument was not supplied. Extra fields: 'argument_name' */
        case 200: /* 'invalid_argument' The argument was malformed, or its value was invalid for some other reason. Extra fields: 'argument_name' */
            [extraFields setObject:[result objectForKey:@"argument_name"] forKey:@"argument_name"];
            break;

        case 223: /* 'unknown_attribute' An attribute does not exist. This can occur when trying to create or update a record, or when modifying an attribute. Extra fields: 'attribute_name' */
        case 233: /* 'attribute_exists' Attempted to create an attribute that already exists. Extra fields: 'attribute_name' */
        case 234: /* 'reserved_attribute' Attempted to modify a reserved attribute; can occur if you try to delete, rename, or write to a reserved attribute. Extra fields: 'attribute_name' */
            [extraFields setObject:[result objectForKey:@"attribute_name"] forKey:@"attribute_name"];
            break;

        case 221: /* 'unknown_application' The application id does not exist. Extra fields: 'application_id' */
            [extraFields setObject:[result objectForKey:@"application_id"] forKey:@"applicaiton_id"];
            break;

        case 222: /* 'unknown_entity_type' The entity type does not exist. Extra fields: 'type_name' */
        case 232: /* 'entity_type_exists' Attempted to create an entity type that already exists. Extra fields: 'type_name' */
            [extraFields setObject:[result objectForKey:@"type_name"] forKey:@"type_name"];
            break;

        case 310: /* 'record_not_found' Referred to an entity or plural element that does not exist. */
            [extraFields setObject:[result objectForKey:@"message"] forKey:@"message"];
            [extraFields setObject:[result objectForKey:@"prereg_attributes"] forKey:@"prereg_attributes"];
            break;

        case 330: /* 'timestamp_mismatch' The created or lastUpdated value does not match the supplied argument. Extra fields: 'attribute_name', 'actual_value', 'supplied_value' */
            [extraFields setObject:[result objectForKey:@"attribute_name"] forKey:@"attribute_name"];
            [extraFields setObject:[result objectForKey:@"actual_value"] forKey:@"actual_value"];
            [extraFields setObject:[result objectForKey:@"supplied_value"] forKey:@"supplied_value"];
            break;

        case 380:
            [extraFields setObject:[result objectForKey:@"existing_provider"] forKey:@"existing_provider"];
            break;

        case 420: /* 'redirect_uri_mismatch' The redirectUri did not match. Occurs in the oauth/token API call with the authorization_code grant type. Extra fields: 'expected_value', 'supplied_value' */
            [extraFields setObject:[result objectForKey:@"expected_value"] forKey:@"expected_value"];
            [extraFields setObject:[result objectForKey:@"supplied_value"] forKey:@"supplied_value"];
            break;

        case 201: /* 'duplicate_argument' Two or more supplied arguments may not have been included in the same call; for example, both id and uuid in entity.update. */
        case 205: /* 'invalid_auth_method' The request used an http auth method other than Basic or OAuth. */
        case 320: /* 'id_in_new_record' Attempted to specify a record id in a new entity or plural element. */
        case 340: /* 'invalid_data_format' A JSON value was not formatted correctly according to the attribute type in the schema. */
        case 341: /* 'invalid_json_type' A value did not match the expected JSON type according to the schema. */
        case 342: /* 'invalid_date_time' A date or dateTime value was not valid, for example if it was not formatted correctly or was out of range. */
        case 360: /* 'constraint_violation' A constraint was violated. */
        case 361: /* 'unique_violation' A unique or locally-unique constraint was violated. */
        case 362: /* 'missing_required_attribute' An attribute with the required constraint was either missing or set to null. */
        case 363: /* 'length_violation' A string value violated an attribute’s length constraint. */
        case 402: /* 'invalid_client_credentials' The client id does not exist or the client secret was wrong. */
        case 403: /* 'client_permission_error' The client does not have permission to perform the action; needs a feature. */
        case 414: /* 'access_token_expired' The supplied access_token has expired. */
        case 415: /* 'authorization_code_expired' The supplied authorization_code has expired. */
        case 416: /* 'verification_code_expired' The supplied verification_code has expired. */
        case 417: /* 'creation_token_expired' The supplied creation_token has expired. */
        case 480: /* 'api_feature_disabled' The API call was temporarily disabled for maintenance, and will be available again shortly. */
        case 500: /* 'unexpected_error' An unexpected internal error; Janrain is notified when this occurs. */
        case 510: /* 'api_limit_error' The limit on total number of simultaneous API calls has been reached. */
        default:
            break;
    }

    return [self errorWithErrorString:errorString code:([code integerValue] + APID_ERROR_RANGE)
                          description:errorDescription extraFields:extraFields];
}

@end

@implementation JRCaptureError (JRCaptureError_Helpers)

+ (NSDictionary *)invalidClassErrorDictForResult:(NSObject *)result
{
    NSString *errDesc = [NSString stringWithFormat:@"The result object was not a string or dictionary: %@",
                                       [result description]];
    return [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"error", @"stat",
                                 @"invalid_result", @"error",
                                 errDesc, @"error_description",
                                 [NSNumber numberWithInteger:JRCaptureLocalApidErrorInvalidResultClass], @"code",
                                 result, @"bad_result",
                                 nil];
}

+ (NSDictionary *)invalidStatErrorDictForResult:(NSObject *)result
{
    NSString *errDesc = [NSString stringWithFormat:@"The result object did not have the expected stat: %@",
                                       [result description]];
    return [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"error", @"stat",
                                 @"invalid_result", @"error",
                                 errDesc, @"error_description",
                                 [NSNumber numberWithInteger:JRCaptureLocalApidErrorInvalidResultStat], @"code",
                                 result, @"bad_result",
                                 nil];
}

+ (NSDictionary *)invalidDataErrorDictForResult:(NSObject *)result
{
    NSString *errDesc = [NSString stringWithFormat:@"The result object did not have the expected data: %@",
                                       [result description]];
    return [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"error", @"stat",
                                 @"invalid_result", @"error",
                                 errDesc, @"error_description",
                                 [NSNumber numberWithInteger:JRCaptureLocalApidErrorInvalidResultData], @"code", 
                                 result, @"bad_result",
                                 nil];
}
@end

@implementation NSError (JRCaptureError_Extensions)
- (BOOL)isJRMergeFlowError
{
    return [self isKindOfClass:[JRCaptureError class]] && [((JRCaptureError *) self) isMergeFlowError];
}

- (BOOL)isJRTwoStepRegFlowError
{
    return [self isKindOfClass:[JRCaptureError class]] && [((JRCaptureError *) self) isTwoStepRegFlowError];
}

- (NSString *)JRMergeFlowConflictedProvider
{
    if (![self isKindOfClass:[JRCaptureError class]] || ![self isJRMergeFlowError]) return nil;
    return [((JRCaptureError *) self) conflictedProvider];
}

- (NSString *)JRMergeFlowExistingProvider
{
    if (![self isKindOfClass:[JRCaptureError class]] || ![self isJRMergeFlowError]) return nil;
    return [((JRCaptureError *) self) existingProvider];
}

- (NSString *)JRMergeToken
{
    if (![self isKindOfClass:[JRCaptureError class]] || ![self isJRMergeFlowError]) return nil;
    return [((JRCaptureError *) self) mergeToken];
}

- (JRCaptureUser *)JRPreregistrationRecord
{
    if (![self isKindOfClass:[JRCaptureError class]] || ![self isJRTwoStepRegFlowError]) return nil;
    return [((JRCaptureError *) self) preRegistrationRecord];
}

@end