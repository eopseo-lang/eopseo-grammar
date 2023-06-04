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
    : package? fileCompo*
    ;
fileCompo
    : new
    | theory
    ;

//// package
package
    : PACKAGE namespace
    ;
namespace
    : (ID DOT)* ID
    ;

//// import
//TODO: make grammar about 'import'

//// value
defaultValue
    : Integer | Double | String
    ;
value
    : defaultValue
    | reference
    | tuple
    ;

tuple
    : LPAREN value* RPAREN
    ;

//// rule
theory
    : forAll? value ARROW value
    ;

forAll
    : LSQUARE forAllCompo+ RSQUARE
    ;
forAllCompo
    : commonId TILDE value
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

//// Signs

ARROW: '=>' ;
TILDE: '~' ;
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
    :   [-<>$.|+=*&%^@!?/\\:;,]  ;

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






