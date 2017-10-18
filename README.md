# uuid

UUIDs for crystal

create generic UUID
```crystal
require "uuid"

UUID.new
```

create UUID with strings and options for variants and versions
```crystal
UUID.new("c20335c3-7f46-4126-aae9-f665434ad12b", variant: UUID::Variant::NCS)
UUID.new(StaticArray(UInt8, 16).new(0_u8), version: UUID::Version::V3)
```

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  uuid:
    github: wontruefree/uuid
```
