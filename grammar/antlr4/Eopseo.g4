//   Copyright 2023 eopseo-lang
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.


grammar Eopseo;


////// Parser //////

file
    : package_ import_ fileCompo*
    ;
fileCompo
    : newType
    | theorem
    ;

//// package
package_
    : (PACKAGE namespace_)?
    ;
namespace_
    : (ID DOT)* ID
    ;

//// import
import_
    : importEx*
    ;
importEx
    : IMPORT namespace_
    ;

//// type
defaultType
    : Integer | Double | String | rBoolean
    ;
typeEx
    : defaultType
    | primitiveType
    | reference
    | tupleType
    ;

rBoolean
    : RTRUE | RFALSE
    ;

primitiveType
    : RINT | RDOUBLE | RSTRING | RBOOLEAN
    ;

tupleType
    : LPAREN typeEx* RPAREN
    ;

//// theory
theorem
    : compiledId? forAll? inside=typeEx RARROW outside=typeEx
    | compiledId? forAll? outside=typeEx LARROW inside=typeEx
    ;

compiledId
    : SHARP ID
    ;

forAll
    : LSQUARE forAllCompo+ RSQUARE
    ;
forAllCompo
    : commonId (RARROW typeEx)?
    ;

//// reference
reference
    : (namespace_ DOT)? commonId
    ;

//// new type
newType
    : NEW commonId
    ;

//// identifier
commonId
    : ID
    | OPID
    ;




////// Lexer //////

//// WS

WS  :  [ \t\r\n\u000C]+ -> skip
    ;

COMMENT
    :   '/*' .*? '*/' -> skip
    ;

LINE_COMMENT
    :   '//' ~[\r\n]* -> skip
    ;

//// Keywards

PACKAGE: 'package' ;
IMPORT: 'import' ;
NEW: 'new' ;

// rBoolean
RTRUE: 'rTrue' ;
RFALSE: 'rFalse' ;

// primitive type
RINT: 'RInt' ;
RDOUBLE: 'RDouble' ;
RSTRING: 'RString' ;
RBOOLEAN: 'RBoolean' ;

//// Signs

RARROW: '->' ;
LARROW: '<-' ;
SHARP: '#' ;
LPAREN: '(' ;
RPAREN: ')' ;
LSQUARE: '[' ;
RSQUARE: ']' ;
LBRACE: '{' ;
RBRACE: '}' ;
DOT: '.' ;

//// ID

fragment IDLETTERHEAD
    :   [_a-zA-Z]  ;

fragment IDLETTERTAIL
    :   [-_a-zA-Z0-9]  ;

fragment IDLETTERSPECIAL
    :   [-<>$.|+=*&%^@!?/\\:;,~]  ;

ID: IDLETTERHEAD IDLETTERTAIL* ;
OPID: IDLETTERSPECIAL+ ;


//// default data struct

// nums
fragment DIGITLETTER
    :   [0-9]  ;

Integer: DIGITLETTER+ | '0x'HEX+ ;
Double: DIGITLETTER+ '.' DIGITLETTER+ ;

// string
String :  '"' (~["])* '"' ;

fragment HEX : [0-9a-fA-F] ;







