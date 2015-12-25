" A pretty precise vim syntax for Haskell source code
" Note: must be preprocessed with haskell.sed (in this same directory)

syn sync minlines=50

set iskeyword+='

" Comments -----------------------------------------------------------------
syn clear hsLineComment
syn clear hsBlockComment
syn region hsLineComment fold
  \ start="NOT_OP\@<=---*\zeNOT_OP"
  \ end="^\(\s*--.*\)\@!"me=s-1
  \ end="^\s*-- [|*$^].*"me=s-1
  \ containedin=ALLBUT,@hsAnyComment
syn region hsBlockComment fold start="{-\(#\|\s*[|*$]\)\@!" end="-}"
  \ contains=hsBlockComment
  \ containedin=ALLBUT,hsLineComment,@hsHaddock

syn cluster hsComment contains=hsLineComment,hsBlockComment

" Documentation ------------------------------------------------------------
syn region hsLineHaddock
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
  exec 'syn match '.a:name.' "NOT_OP\@<=\('.a:symbol.'\)\zeNOT_OP" '.join(a:000)
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
syn region hsClass start="^\<class\>" end="BLOCKEND"me=s-1
syn match hsClassName
  \ "\(\<class\>\_s\+\(.*\(⇒\|=>\)\)\?\_s*\)\@<=CON_ID\ze\(.*\(⇒\|=>\).*$\)\@!"
  \ contained containedin=hsClass
syn keyword hsClassKW class where contained containedin=hsClass
syn region hsClassBody start="\(\<where\>\_s\)\@<=" end="BLOCKEND"me=s-1
  \ contained containedin=hsClass
  \ contains=TOP
syn match hsClassFunctionName "^\s\+\zsVAR_ID\ze\s*\(::\|∷\)NOT_OP"
  \ contained containedin=hsClassBody

" Data ---------------------------------------------------------------------
syn region hsData start="^\<\(data\|newtype\)\>" end="BLOCKEND"me=s-1
syn match hsDataName "\(\<\(data\|newtype\)\>\_s\+\)\@<=CON_ID"
  \ contained containedin=hsData
syn keyword hsDataKW data newtype where contained containedin=hsData

syn match hsDataVariantName "\(NOT_OP[=|]\_s*\)\@<=CON_ID"
  \ contained containedin=hsData
syn match hsDataVariantName "^\s\+\zsCON_ID\ze\_s*\(::\|∷\)"
  \ contained containedin=hsData "GADT
syn match hsDataTypeAnnotLHS "VAR_ID\ze\s*\(::\|∷\)NOT_OP"
  \ contained containedin=hsData

syn region hsDataDeriving start="\<deriving\>" end="BLOCKEND"me=s-1
  \ contained containedin=hsData
syn keyword hsDeriving deriving contained containedin=hsDataDeriving

" Type ---------------------------------------------------------------------
syn region hsTypeD start="^\<type\>" end="BLOCKEND"me=s-1
  \ contains=ConId
syn region hsTypeDLHS start="\<type\>" end="NOT_OP\@<==\zeNOT_OP"
  \ contained containedin=hsTypeD
syn keyword hsTypeDKW type contained containedin=hsTypeDLHS
syn match hsTypeDName "CON_ID" contained containedin=hsTypeDLHS

" Functions ----------------------------------------------------------------
syn match hsTopTypeAnnotLHS "^VAR_ID\ze\s*\(::\|∷\)NOT_OP"

syn region hsFunDefBody
  \ start="^[^[:space:]].*NOT_OP=NOT_OP"
  \ end="BLOCKEND"me=s-1
  \ fold contains=TOP

" Type annotations ---------------------------------------------------------
syn region hsTypeAnnot start="\(::\|∷\)"
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
