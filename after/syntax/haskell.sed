#!/bin/sed -f

1s/^/" WARNING: Automatically generated file; edit haskell.sed.vim instead\n\n/
s/NOT_OP/\\([^[:punct:]]\\|[()[]{}]\\|^\\|$\\)/g
s/KEYWORD/\\<\\(data\\|newtype\\|deriving\\|instance\\|class\\|where\\)\\>/g
s/VAR_ID/\\(\\<[a-z_][a-zA-Z0-9_']*\\>\\|([^a-zA-Z0-9_]\\+)\\)/g
s/CON_ID/\\(\\<[A-Z][a-zA-Z0-9_']*\\>\\|(:[^a-zA-Z0-9_]\\+)\\)/g
s/BLOCKEND/^\\n*[^[:space:]]/g
