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

/**
 * @file
 * Types used by the library's generated Capture user model
 **/

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSString JRString;

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSNumber JRBoolean;

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSNumber JRDecimal;

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSNumber JRInteger;

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSDate   JRDate;

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSDate   JRDateTime;

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSString JRIpAddress;

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSObject JRPassword;

/**
 * Any object hierarchy that JSONKit can serialize. This includes and is limited to NSArray, NSDictionary, NSString,
 * NSNumber, and NSNull.
 *
 * For more information on JSONKit and what it can serialize check the README in the project:
 * https://github.com/johnezang/JSONKit
 *
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 */
typedef NSObject JRJsonObject;

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSArray  JRStringArray;

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSString JRUuid;

/**
 * TODO
 * @sa
 *   For more information, please see the \ref typesTable "Type Mapping Reference Page"
 **/
typedef NSNumber JRObjectId;

/**
 * @page Types Mapping Reference
 * The Capture schema, the JSON language, Objective-C, and the JUMP for iOS libraries all use different nomenclature
 * when referring to types. For example, the schema may define a property as having type \c "string", which
 * is the same as the JSON \c "String" and the Objective-C foundational class \c "NSString".
 *
 * Some types do not perfectly map between systems. For example, a \c boolean on Capture can have the
 * values \c true, \c false, and \c null, while an \c NSBoolean in Objective-C can only be \c YES or \c NO.
 * On the other hand an \c NSNumber can represent \c true, \c false, and \c null, but it can also hold many other things
 * that won't be accepted by the Capture API (such as \c -100).
 *
 * To ensure that your objects can correctly update themselves on Capture, we had to use an \c NSNumber to hold
 * boolean properties. To make it perfectly clear that boolean properties cannot be just any number, we typedeffed
 * them \c JRBoolean.  Your IDE's auto-complete should suggest JRBoolean when setting a boolean property, but since
 * underneath it is just an NSNumber, you can set it to \c null as well.
 *
 * @warn
 * The compiler won't stop you from setting a \c JRBoolean to a non-boolean value, but you will get an error when you
 * try and update your object on Capture.
 *
 * @anchor typesTable
 * @table
 * | Schema Type | Json Type        | Obj-C Type | JRCapture Type                  | Recursive  | Typedeffed | Notes|
 * ---------------------------------------------------------------------------------------------------------------------
 * | string      | String           | NSString   | NSString                        |            | No         |      |
 * | boolean     | Boolean          | NSNumber   | ::JRBoolean                     |            | \b Yes     |      |
 * | integer     | Number           | NSNumber   | ::JRInteger                     |            | \b Yes     |      |
 * | decimal     | Number           | NSNumber   | NSNumber                        |            | No         |      |
 * | date        | String           | NSDate     | ::JRDate                        |            | \b Yes     |      |
 * | dateTime    | String           | NSDate     | ::JRDateTime                    |            | \b Yes     |      |
 * | ipAddress   | String           | NSString   | ::JRIpAddress                   |            | \b Yes     |      |
 * | password    | String or Object | NSObject   | ::JRPassword                    |            | \b Yes     |      |
 * | JSON        | (any type)       | NSObject   | ::JRJsonObject                  |            | \b Yes     | The JSON type is unstructured data; it only has to be valid parseable JSON. |
 * | plural      | Array            | NSArray    | NSArray or ::JRStringArray      | \b Yes     | No/\b Yes  | Primitive child attributes of plurals may have the constraint locally-unique. |
 * | object      | Object           | NSObject   | JR&lt;<em>PropertyName</em>&gt; | \b Yes     | No         |      |
 * | uuid        | String           | NSString   | ::JRUuid                        |            | \b Yes     | Not an externally usable type. |
 * | id          | Number           | NSNumber   | ::JRObjectId                    |            | \b Yes     | Not an externally usable type. |
 * @endtable
 *
 *
 *
@anchor types
@htmlonly
<!--
<table border="1px solid black">
<tr><b><td>Schema Type  </td><td>Json Type         </td><td>Obj-C Type   </td><td>JRCapture Type                   </td><td>Recursive  </td><td>Typedeffed    </td><td>Notes  </td></b></tr>
<tr><td>string          </td><td>String            </td><td>NSString     </td><td>NSString                         </td><td>           </td><td>No            </td><td>       </td></tr>
<tr><td>boolean         </td><td>Boolean           </td><td>NSNumber     </td><td>JRBoolean                        </td><td>           </td><td><b>Yes</b>    </td><td>       </td></tr>
<tr><td>integer         </td><td>Number            </td><td>NSNumber     </td><td>JRInteger                        </td><td>           </td><td><b>Yes</b>    </td><td>       </td></tr>
<tr><td>decimal         </td><td>Number            </td><td>NSNumber     </td><td>NSNumber                         </td><td>           </td><td>No            </td><td>       </td></tr>
<tr><td>date            </td><td>String            </td><td>NSDate       </td><td>JRDate                           </td><td>           </td><td><b>Yes</b>    </td><td>       </td></tr>
<tr><td>dateTime        </td><td>String            </td><td>NSDate       </td><td>JRDateTime                       </td><td>           </td><td><b>Yes</b>    </td><td>       </td></tr>
<tr><td>ipAddress       </td><td>String            </td><td>NSString     </td><td>JRIpAddress                      </td><td>           </td><td><b>Yes</b>    </td><td>       </td></tr>
<tr><td>password        </td><td>String or Object  </td><td>NSObject     </td><td>JRPassword                       </td><td>           </td><td><b>Yes</b>    </td><td>       </td></tr>
<tr><td>JSON            </td><td>(any type)        </td><td>NSObject     </td><td>JRJsonObject                     </td><td>           </td><td><b>Yes</b>    </td><td>The JSON type is unstructured data; it only has to be valid parseable JSON.</td></tr>
<tr><td>plural          </td><td>Array             </td><td>NSArray      </td><td>NSArray or JRSimpleArray         </td><td><b>Yes</b> </td><td>No/<b>Yes</b> </td><td>Primitive child attributes of plurals may have the constraint locally-unique.</td></tr>
<tr><td>object          </td><td>Object            </td><td>NSObject     </td><td>JR&lt;<em>PropertyName</em>&gt;  </td><td><b>Yes</b> </td><td>No            </td><td>       </td></tr>
<tr><td>uuid            </td><td>String            </td><td>NSString     </td><td>JRUuid                           </td><td>           </td><td><b>Yes</b>    </td><td>Not an externally usable type.</td></tr>
<tr><td>id              </td><td>Number            </td><td>NSNumber     </td><td>JRObjectId                       </td><td>           </td><td><b>Yes</b>    </td><td>Not an externally usable type.</td></tr>
</table>
-->
@endhtmlonly
 *
 **/
//@htmlonly
//@endhtmlonly
