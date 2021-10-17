# gma2-pool-cleaner
Cleans up your object pools

This is a Lua plugin for GrandMA2 lighting software

It will comb thru an assigned pool from a given start object ID to end object ID searching for duplicate names and delete any duplicates further into the pool. It does not actually check if the data contained in the objects is duplicate, so use with caution. Always make a backup showfile before using an unknown plugin :)

This is my first "completed" piece of code after about a month with C# in Unity and only a few days with Lua. So while keeping that in mind, constructive feedback is welcome.

### Current showfile of death record (1479 out of ~3000 are dupes)
- v1.0.3: 19m49s

- v1.0.2: 40m44s

### Features to be added
  - Alphabetization (and/or other sorting features)

  - Pool compression, i.e. move all objects as close to postion 1 as posible

### Known Issues
- Fails to recognize matches containing any Lua Magic Characters. This is due to my own lack of knowledge regarding Lua's pattern functions, should be fixed soon(tm). It currently leaves affected objects in place.
