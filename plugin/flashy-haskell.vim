" On startup, checks that the syntax file is up to date with regards to its
" unpreprocessed version, and if not, runs the preprocessor.

" TODO: Only check when loading a haskell source code file instead of checking
" every time vim starts up.
" TODO: Error handling.

let s:syndir = expand("<sfile>:p:h:h") . "/after/syntax"
let s:sedscript = s:syndir . '/haskell.sed'
let s:synsed = s:syndir . '/haskell.sed.vim'
let s:synout = s:syndir . '/haskell.vim'

silent exec '!test '.shellescape(s:synout).' -nt '.shellescape(s:synsed).' && '
  \.'test '.shellescape(s:synout).' -nt '.shellescape(s:sedscript)

if v:shell_error == 1
    silent exec '!'.shellescape(s:sedscript).' '.shellescape(s:synsed).' > '
      \.shellescape(s:synout)
endif
