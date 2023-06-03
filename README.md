# VirginActive API

Ruby client for the VirginActive API used by VirginActive mobile apps.

## Usage

```ruby
require "virgin_active"

api = VirginActive::API.new
api.authenticate(username: ENV["USERNAME"], password: ENV["PASSWORD"])
api.clubs
```
