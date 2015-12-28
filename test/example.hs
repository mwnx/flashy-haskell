{-# LANGUAGE UnicodeSyntax #-}

module Example (
      hello -- ^hello world
    , bye -- ^bye
) where

import Control.Monad

-- TODO: internationalisation

class Monad m ⇒ HelloWorldCapable m a where
    helloWorld ∷ m a → m ()
    helloWorld = fail ""

data HelloWorlder a b = HELLO {-# UNPACK {- needed! -} #-} String |
    BYE { x :: {-# UNPACK#-}a, y :: b } | Hello' (AAA b a)

type HelloWorlder' a = HelloWorlder a Int

data GADTHelloWorld a where
    Hello1 ∷ Int → GADTHelloWorld Int
    Hello2 ∷ a → GADTHelloWorld a

instance HelloWorldCapable HelloWorlder' where
    helloWorld = fail ""

-- | Haddock stuff
helloWorld1 ∷ Monad m
            ⇒ Int    -- ^Stuff
            → Float  -- not important
            → m ()
helloWorld1 = undefined "a long
    foldable
    function"

helloWorld2 ∷ Int -> Int -> String
helloWorld2 a b = helloWorld1 . undefined

(+-) :: HelloWorlderCapable a => a -> b -> HelloWorlder a b
(+-) =
    blah blah
    blah
