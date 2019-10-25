---
tagline: OpenResty runtime
---

OpenResty runtime for luapower.

## HowTO

Create a file `nginx-server-foo.conf` which will be included in the
nginx conf `http` namespace:

```
server {
	...
}
```

Type `./nginx -s start` then check `http://127.0.0.1:8000` or whatever
depending on your `listen` directive.

## TODO

Upgrade [luajit] to the [OpenResty fork](https://github.com/openresty/luajit2)
and rebuild OpenResty to link to that so that we can have a single LuaJIT
runtime Lua dialect to be used from both the command line and from within the
nginx context.
