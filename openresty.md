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
