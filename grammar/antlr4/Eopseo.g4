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
    : package import_ fileCompo*
    ;
fileCompo
    : new
    | theory
    ;

//// package
package
    : (PACKAGE namespace)?
    ;
namespace
    : (ID DOT)* ID
    ;

//// import
import_
    : importEx*
    ;
importEx
    : IMPORT namespace
    ;

//// value
defaultType
    : Integer | Double | String
    ;
type
    : defaultType
    | primitiveType
    | reference
    | tuple
    ;

primitiveType
    : RINT | RDouble | RString
    ;

tuple
    : LPAREN type* RPAREN
    ;

//// rule
theory
    : forAll? type ARROW type
    ;

forAll
    : LSQUARE forAllCompo+ RSQUARE
    ;
forAllCompo
    : commonId ARROW type
    ;

//// reference
reference
    : (namespace DOT)? commonId
    ;

//// new value of type
new
    : NEW commonId #newType
    | ABSTRACT NEW commonId #newAbstractType
    ;

////
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
ABSTRACT: 'abstract' ;

// primitive type
RINT: 'RInt' ;
RDouble: 'RDouble' ;
RString: 'RString' ;

//// Signs

ARROW: '=>' ;
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






