{-# LANGUAGE FlexibleContexts #-}

module Control.ECS (
  module Control.ECS.Core,
  module Control.ECS.Storage,

  -- Mutable
  HashTable, Global, Cached, newCacheWith,

  -- Immutable
  Map, FlagSet,

  -- Reader
  asks, ask, liftIO,

  -- Self
  newEntityWith,
  EntityCounter, nextEntity,
) where

import Control.Monad.Reader

import Control.ECS.Core
import Control.ECS.Storage
import Control.ECS.Storage.Mutable
import Control.ECS.Storage.Immutable

newtype EntityCounter = ECount Int deriving (Eq, Show, Num)
instance Component EntityCounter where
  type Storage EntityCounter = Global EntityCounter

instance Monoid EntityCounter where
  mempty = 0
  mappend = (+)

{-# INLINE nextEntity #-}
nextEntity :: Valid w m EntityCounter => System w m (Entity a)
nextEntity = do Reads (ECount c) :: Reads EntityCounter <- retrieve (-1)
                let w :: Writes EntityCounter = Writes (ECount (c+1))
                store w (-1)
                return (Entity c)

{-# INLINE newEntityWith #-}
newEntityWith :: (Valid w m c, Valid w m EntityCounter) => Writes c -> System w m (Entity a)
newEntityWith c = do e <- nextEntity
                     store c e
                     return e

