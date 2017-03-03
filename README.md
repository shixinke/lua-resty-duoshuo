Name
====

lua-resty-duoshuo - 一个针对社会化评论组件多说的API封装

Menu
=================

* [Name](#name)
* [状态](#status)
* [描述](#description)
* [使用说明](#synopsis)
* [方法](#methods)
    * [new](#new)
    * [counts](#counts)
    * [import](#import)
    * [textlen](#textlen)
    * [strlen](#strlen)
* [TODO](#todo)
* [Author](#author)


status
======

该库目前处于测试状态

description
===========

针对社会化评论组件多说的API封装(本类库依赖于lua-resty-http类库)

synopsis
========

    
    #根据自己项目实际需要修改
    lua_package_path '/data/program/github/lua-resty-duoshuo/lib/?.lua;;';
    
    server {
        listen 8000;
       
        location /comment {
            default_type application/json;
            content_by_lua_block {
                local obj = require 'resty.duoshuo':new({subdomain = 'shixinke', secret = 'kdjdjdjd'})
                local cjson = require 'cjson.safe'
                ngx.say(cjson.encode(obj:counts('fjksjfkdsjfkdjfdk')))
            };
        }
    }


[返回主菜单](#menu)

methods
=======

[返回主菜单](#menu)

new
---
`syntax: obj = duoshuo:new(options)`

初始化类库

参数options可取以下的选项:

* `subdomain`

    多说的二级域名
    
* `secret`

    密钥   

[返回主菜单](#menu)


Author
======

shixinke (诗心客) <ishixinke@qq.com>  www.shixinke.com


[返回主菜单](#menu)

