" Vim syntax file
" Language: Toy
" Maintainer: infastin <infastin@yandex.com>
" URL: https://github.com/infastin/vim-toy

if exists('b:current_syntax')
  finish
endif

let s:keepcpo = &cpo
set cpo&vim

syn case match

" Define 'iskeyword' to include valid UTF-8 multibyte characters, some of which
" are technically supported for identifiers.
syn iskeyword @,48-57,_,192-255

" Simple Blocks
syn region toyBracketBlock matchgroup=toyBrackets start='\[' end='\]' transparent
syn region toyParenBlock   matchgroup=toyParens   start='('  end=')'  transparent
syn region toyBraceBlock   matchgroup=toyBraces   start='{'  end='}'  transparent

hi def link toyBraces   Delimiter
hi def link toyBrackets Delimiter
hi def link toyParens   Delimiter

" Interpreter directive
syn match toyHashBang "\%1l^#!.*"

hi def link toyHashBang PreProc

" Comments
syn region toyCommentBlock start="/\*" end="\*/"
syn region toyCommentBlock start="//" end="$"

hi def link toyCommentBlock Comment

" Strings
syn cluster toyStringGroup    contains=toyEscapeOctal,toyEscapeC,toyEscapeX,toyEscapeU,toyEscapeBigU,toyEscapeError,toyStringInterpolationRegion
syn region  toyString         start=+"+  skip=+\\\\\|\\"+ end=+"+  contains=@toyStringGroup
syn region  toyRawString      start=+`+  skip=+\\\\\|\\`+ end=+`+  contains=@toyStringGroup
syn region  toyIndentedString start=+''+ skip=+\\\\\|\\'+ end=+''+ contains=@toyStringGroup

hi def link toyString         String
hi def link toyRawString      String
hi def link toyIndentedString String

syn match   toyStringFormat /\v\%%(\%|[-+# 0]*%([1-9]\d*|%(\[\d+\])?\*)?%(\.%(\d+|%(\[\d+\])?\*)?)?%(\[\d+\])?[EFGOTUXbcdefgopqstwvxf])/ contained containedin=toyString,toyRawString,toyIndentedString
hi def link toyStringFormat toySpecialString

syn region  toyStringInterpolationRegion matchgroup=toyStringInterpolation start=+{+  end=+}+ contained contains=TOP
hi def link toyStringInterpolation Special

" Characters
syn cluster toyCharacterGroup contains=toyEscapeOctal,toyEscapeC,toyEscapeX,toyEscapeU,toyEscapeBigU
syn region  toyCharacter      start=+''\@!+ skip=+\\\\\|\\'+ end=+'+ contains=@toyCharacterGroup

hi def link toyCharacter      Character

" Escapes
syn match toyEscapeOctal display contained "\\[0-7]\{3}"
syn match toyEscapeC     display contained +\\[abfnrtv\\'"`{}\n]+
syn match toyEscapeX     display contained "\\x\x\{2}"
syn match toyEscapeU     display contained "\\u\x\{4}"
syn match toyEscapeBigU  display contained "\\U\x\{8}"
syn match toyEscapeError display contained +\\[^0-7xuUabfnrtv\\'"`{}\n]+

hi def link toyEscapeOctal   toySpecialString
hi def link toyEscapeC       toySpecialString
hi def link toyEscapeX       toySpecialString
hi def link toyEscapeU       toySpecialString
hi def link toyEscapeBigU    toySpecialString
hi def link toySpecialString SpecialChar
hi def link toyEscapeError   Error

" Built-in functions
syn keyword toyBuiltins typename clone freeze satisfies immutable
syn keyword toyBuiltins len append copy delete splice insert clear contains
syn keyword toyBuiltins format min max

hi def link toyBuiltins Macro

" Types
syn keyword toyType type bool float int string bytes char
syn keyword toyType array table tuple range function

hi def link toyType Type

" Functions
syn keyword toyFunc fn
hi def link toyFunc Keyword

" Floating point numbers

" float_lit         = decimal_float_lit | hex_float_lit .
"
" decimal_float_lit = decimal_digits "." [ decimal_digits ] [ decimal_exponent ] |
"                     decimal_digits decimal_exponent |
"                     "." decimal_digits [ decimal_exponent ] .
" decimal_exponent  = ( "e" | "E" ) [ "+" | "-" ] decimal_digits .
"
" hex_float_lit     = "0" ( "x" | "X" ) hex_mantissa hex_exponent .
" hex_mantissa      = [ "_" ] hex_digits "." [ hex_digits ] |
"                     [ "_" ] hex_digits |
"                     "." hex_digits .
" hex_exponent      = ( "p" | "P" ) [ "+" | "-" ] decimal_digits .

" decimal floats with a decimal point
syn match toyFloat "\<-\=\%(0\|\%(\d\|\d_\d\)\+\)\.\%(\%(\%(\d\|\d_\d\)\+\)\=\%([Ee][-+]\=\%(\d\|\d_\d\)\+\)\=\>\)\="
syn match toyFloat "\s\zs-\=\.\%(\d\|\d_\d\)\+\%(\%([Ee][-+]\=\%(\d\|\d_\d\)\+\)\>\)\="
" decimal floats without a decimal point
syn match toyFloat "\<-\=\%(0\|\%(\d\|\d_\d\)\+\)[Ee][-+]\=\%(\d\|\d_\d\)\+\>"
" hexadecimal floats with a decimal point
syn match toyHexadecimalFloat "\<-\=0[xX]\%(_\x\|\x\)\+\.\%(\%(\x\|\x_\x\)\+\)\=\%([Pp][-+]\=\%(\d\|\d_\d\)\+\)\=\>"
syn match toyHexadecimalFloat "\<-\=0[xX]\.\%(\x\|\x_\x\)\+\%([Pp][-+]\=\%(\d\|\d_\d\)\+\)\=\>"
" hexadecimal floats without a decimal point
syn match toyHexadecimalFloat "\<-\=0[xX]\%(_\x\|\x\)\+[Pp][-+]\=\%(\d\|\d_\d\)\+\>"

hi def link toyFloat            Float
hi def link toyHexadecimalFloat Float

" Integers
syn match toyDecimalInt     "\<-\=\%(0\|\%(\d\|\d_\d\)\+\)\>"
syn match toyHexadecimalInt "\<-\=0[xX]_\?\%(\x\|\x_\x\)\+\>"
syn match toyOctalInt       "\<-\=0[oO]\?_\?\%(\o\|\o_\o\)\+\>"
syn match toyBinaryInt      "\<-\=0[bB]_\?\%([01]\|[01]_[01]\)\+\>"

hi def link toyDecimalInt     Number
hi def link toyHexadecimalInt Number
hi def link toyOctalInt       Number
hi def link toyBinaryInt      Number

" Constants
syn keyword toyConstants false true nil
hi def link toyConstants Constant

" Comments
syn keyword toyTodo         contained TODO FIXME XXX BUG
syn cluster toyCommentGroup contains=toyTodo

syn region toyComment start="//" end="$" contains=@toyCommentGroup,@Spell
syn region toyComment start="/\*" end="\*/" contains=@toyCommentGroup,@Spell

hi def link toyComment Comment
hi def link toyTodo    Todo

" Keywords
syn keyword toyRepeat        for in
syn keyword toyRepeatControl break continue
syn keyword toyReturn        return
syn keyword toyException     try throw
syn keyword toyConditional   if else
syn keyword toyImport        import
syn keyword toyDefer         defer

hi def link toyRepeat        Repeat
hi def link toyRepeatControl Keyword
hi def link toyReturn        Statement
hi def link toyException     Exception
hi def link toyConditional   Conditional
hi def link toyImport        Include
hi def link toyDefer         Keyword

" Operators

" match single-char operators:          - + % < > ! & | ^ * =
" and corresponding two-char operators: -= += %= <= >= != &= |= ^= *= ==
syn match toyOperator /[-+%<>!&|^*=]=\?/
" match ?? and ??=
syn match toyOperator /??=\?/
" match / and /=
syn match toyOperator /\/\%(=\|\ze[^/*]\)/
" match two-char operators:               << >> &^
" and corresponding three-char operators: <<= >>= &^=
syn match toyOperator /\%(<<\|>>\|&^\)=\?/
" match remaining two-char operators: := && || ++ -- =>
syn match toyOperator /:=\|||\|++\|--\|=>/
" match ...
syn match toyOperator /\.\.\./
" match ternary
syn match toyOperator /[?:]/

hi def link toyOperator Operator

" Delimiters
syn match   toyDelimiter /[,;]/
syn match   toyDelimiter /\.\(\.\.\)\@!/
hi def link toyDelimiter Delimiter

" Function calls
syn match   toyFuncCall /\<\K\k*\ze(/
hi def link toyFuncCall Function

syn sync minlines=500

let b:current_syntax = 'toy'

let &cpo = s:keepcpo
unlet s:keepcpo

" vim: sw=2 sts=2 et
