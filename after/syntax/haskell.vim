" A pretty precise vim syntax for Haskell source code

syn sync minlines=50

set iskeyword+='

function! s:Sub(pat, sub)
    let s:cmd = substitute(s:cmd, a:pat, a:sub, "g")
endfunction

" Preprocess special patterns in syntax definitions:
function! s:Syn(...)
    let s:cmd = join(a:000)
    call s:Sub('NOT_OP',
      \ '\\([^[:punct:]]\\|[()[]{}]\\|^\\|$\\)')
    call s:Sub('KEYWORD',
      \ '\\<\\(data\\|newtype\\|deriving\\|instance\\|class\\|where\\)\\>')
    call s:Sub('VAR_ID',
      \ '\\(\\<[a-z_][a-zA-Z0-9_'."'".']*\\>\\|([^a-zA-Z0-9_]\\+)\\)')
    call s:Sub('CON_ID',
      \ '\\(\\<[A-Z][a-zA-Z0-9_'."'".']*\\>\\|(:[^a-zA-Z0-9_]\\+)\\)')
    call s:Sub('BLOCKEND',
      \ '^\\n*[^[:space:]]')
    exec 'syn '.s:cmd
endfunction

command -nargs=* Syn call s:Syn(<f-args>)

" Comments -----------------------------------------------------------------
syn clear hsPragma
syn region hsPragma start="{-#" end="#-}"
  \ containedin=ALLBUT,@hsAnyComment

syn clear hsLineComment
syn clear hsBlockComment
Syn region hsLineComment fold
  \ start="NOT_OP\@<=---*\zeNOT_OP"
  \ end="^\(\s*--.*\)\@!"me=s-1
  \ end="^\s*-- [|*$^].*"me=s-1
  \ containedin=ALLBUT,@hsAnyComment
syn region hsBlockComment fold start="{-\(#\|\s*[|*$]\)\@!" end="-}"
  \ contains=hsBlockComment
  \ containedin=ALLBUT,hsLineComment,@hsHaddock

syn cluster hsComment contains=hsLineComment,hsBlockComment

" Documentation ------------------------------------------------------------
Syn region hsLineHaddock
  \ start="NOT_OP\@<=-- [|*$^]\zeNOT_OP"rs=e+1
  \ end="^\(^\s*--.*\)\@!"me=s-1
  \ containedin=ALLBUT,@hsAnyComment
syn region hsBlockHaddock start="{-\s*[|*$]" end="-}"
  \ containedin=ALLBUT,@hsComment,hsLineHaddock
syn region hsBlockComment_ transparent start="{-"ms=e+1 end="-}"
  \ contained containedin=hsBlockHaddock

syn cluster hsHaddock contains=hsLineHaddock,hsBlockHaddock
syn cluster hsAnyComment contains=@hsComment,@hsHaddock

" Keywords and symbols -----------------------------------------------------
function! s:NewSymbol(name, symbol, ...)
  exec 'Syn match '.a:name.' "NOT_OP\@<=\('.a:symbol.'\)\zeNOT_OP" '.join(a:000)
endfunction
command! -nargs=* HSNewSymbol call s:NewSymbol(<f-args>)

HSNewSymbol hsRightArrow  ->\|→
HSNewSymbol hsLeftArrow   <-\|←
HSNewSymbol hsProportion  ::\|∷ containedin=hsTypeAnnot contained
HSNewSymbol hsImplies     =>\|⇒
HSNewSymbol hsTypeArrow   ->\|→ containedin=hsTypeAnnot contained
HSNewSymbol hsMonadic     >>=\|=<<\|>>\|>=>\|<=<
HSNewSymbol hsApplicative <\$\|\$>\|<[$&]>\|<\*\*\?>\|\<\*\|\*>\|<|>

delcommand HSNewSymbol

syn match hsUnit "()" 

" Class --------------------------------------------------------------------
Syn region hsClass start="^\<class\>" end="BLOCKEND"me=s-1
Syn match hsClassName
  \ "\(\<class\>\_s\+\(.*\(⇒\|=>\)\)\?\_s*\)\@<=CON_ID\ze\(.*\(⇒\|=>\).*$\)\@!"
  \ contained containedin=hsClass
syn keyword hsClassKW class where contained containedin=hsClass
Syn region hsClassBody start="\(\<where\>\_s\)\@<=" end="BLOCKEND"me=s-1
  \ contained containedin=hsClass
  \ contains=TOP
Syn match hsClassFunctionName "^\s\+\zsVAR_ID\ze\s*\(::\|∷\)NOT_OP"
  \ contained containedin=hsClassBody

" Data ---------------------------------------------------------------------
Syn region hsData start="^\<\(data\|newtype\)\>" end="BLOCKEND"me=s-1
Syn match hsDataName "\(\<\(data\|newtype\)\>\_s\+\)\@<=CON_ID"
  \ contained containedin=hsData
syn keyword hsDataKW data newtype where contained containedin=hsData

Syn match hsDataVariantName "\(NOT_OP[=|]\_s*\)\@<=CON_ID"
  \ contained containedin=hsData
Syn match hsDataVariantName "^\s\+\zsCON_ID\ze\_s*\(::\|∷\)"
  \ contained containedin=hsData "GADT
Syn match hsDataTypeAnnotLHS "VAR_ID\ze\s*\(::\|∷\)NOT_OP"
  \ contained containedin=hsData

Syn region hsDataDeriving start="\<deriving\>" end="BLOCKEND"me=s-1
  \ contained containedin=hsData
syn keyword hsDeriving deriving contained containedin=hsDataDeriving

" Type ---------------------------------------------------------------------
Syn region hsTypeD start="^\<type\>" end="BLOCKEND"me=s-1
  \ contains=ConId
Syn region hsTypeDLHS start="\<type\>" end="NOT_OP\@<==\zeNOT_OP"
  \ contained containedin=hsTypeD
syn keyword hsTypeDKW type contained containedin=hsTypeDLHS
Syn match hsTypeDName "CON_ID" contained containedin=hsTypeDLHS

" Functions ----------------------------------------------------------------
Syn match hsTopTypeAnnotLHS "^VAR_ID\ze\s*\(::\|∷\)NOT_OP"

Syn region hsFunDefBody
  \ start="^[^[:space:]].*NOT_OP=NOT_OP"
  \ end="BLOCKEND"me=s-1
  \ fold contains=TOP

" Type annotations ---------------------------------------------------------
Syn region hsTypeAnnot start="\(::\|∷\)"
  \ end="^.*NOT_OP\(=\|::\|∷\)NOT_OP.*$"me=s-1
  \ end="[}|,)]"me=s-1
  \ end="KEYWORD"me=s-1
  \ end="^[^[:space:]]"me=s-1
  \ containedin=hsClass,hsData
syn region hsTypeAnnot start="(" end=")"
  \ contained containedin=hsTypeAnnot

" Default highlighting -----------------------------------------------------
hi def link hsTypeArrow          hsTypeOp
hi def link hsUnit               ConId
hi def link hsLeftArrow          hsMonadic
hi def link hsRightArrow         hsOperator
hi def link hsBlockHaddock       hsHaddock
hi def link hsLineHaddock        hsHaddock
hi def link hsDataDeriving       hsData

delcommand Syn
