local _M = {__VERSION = '0.01'}
local mt = {__index = _M }
local substr = string.sub
local regex_find = ngx.re.find
local http = require 'resty.http':new()
local cjson = require 'cjson.safe'
local local_conf = {
    api = {
        counts = {url ='http://api.duoshuo.com/threads/counts.json', method = 'GET'},
        import = {url = 'http://api.duoshuo.com/log/list.json', method = 'GET'},
        hots = {url = 'http://api.duoshuo.com/sites/listTopThreads.json', method = 'GET'},
        create = {url = 'http://api.duoshuo.com/posts/create.json', method = 'POST'},
        sso = {url = 'http://api.duoshuo.com/sites/join.json', method = 'POST'},
        sync_comments = {url = 'http://api.duoshuo.com/posts/import.json', method = 'POST'},
        sync_users = {url = 'http://api.duoshuo.com/users/import.json', method = 'POST'},
        sync_posts = {url = 'http://api.duoshuo.com/threads/import.json', method = 'POST'},
        profile = {url = 'http://api.duoshuo.com/users/profile.json', method ='GET'},
        comments = {url = 'http://api.duoshuo.com/threads/listPosts.json', method = 'GET'}
    }
}

local function build_query(tab)
    if type(tab) == 'string' then
        return tab
    end
    local query = ''
    for k, v in pairs(tab) do
        if query ~= '' then
            query = query..'&'
        end
        query = query..k..'='..v
    end
    return query
end

local function build_url(url, query)
    local query = build_query(query)
    local from, to , err = regex_find(url, '\\?')
    if from > 0 then
        url = url..'&'..query
    else
        url = url..'?'..query
    end
    return url
end

local function log(message)
    ngx.log(ngx.ERR, message)
end

local function request(url, method, params)
    if url == nil then
        return nil, 'url cannot be null'
    end
    local res, err
    local options = {}
    options.method = method and method or 'GET'
    options.body = params.body and build_query(params.body) or ''
    options.headers = params.headers
    if params.query then
        url = build_url(url)
    end
    res, err = http:request_uri(url, options)
    if not res then
        return nil, err
    end
    if res.status == ngx.HTTP_OK then
        local ret, body = pcall(cjson.decode, res.body)
        if not ret then
            return nil, 'not a valid json data'
        end
        return body
    else
        return nil, err
    end
end


function _M.new(self, options)
    local options = options or {}
    if options.subdomain == nil then
        return nil, 'local_conf error, the paramater of subdomain is required'
    end
    self.subdomain = options.subdomain
    self.secret = options.secret
    self.log = options.log and options.log or true
    return setmetatable(self, mt)
end

function _M.counts(self, posts_id)
    local body, err = request(local_conf.api.counts, local_conf.api.counts.method, {query = {short_name = self.subdomain, threads = posts_id}})
    if not body and self.log then
        log(err)
    end
    return body, err
end

function _M.import()

end

function _M.hots(self, opt)
    local query = {}
    query.short_name = self.subdomain
    if opt.range then
        query.range = opt.range
    end
    if opt.num then
        query.num_items = tonumber(opt.num)
    end
    if opt.channel then
        query.channel_key = tonumber(opt.channel)
    end
    local body, err = request(local_conf.api.hots, local_conf.api.hots.method, {query = query})
    if not body and self.log then
        log(err)
    end
    return body, err
end

function _M.create(self, data)
    if data  == nil then
        return nil, 'data cannot be empty'
    end
    data.short_name = self.subdomain
    data.secret = self.secret
    local body, err = request(local_conf.api.create.url, local_conf.api.create.method, {body = data})
    if not body and self.log then
        log(err)
    end
    return body, err
end

function _M.sso(self, data)
    if data  == nil then
        return nil, 'data cannot be empty'
    end
    data.short_name = self.subdomain
    data.secret = self.secret
    local body, err = request(local_conf.api.sso.url, local_conf.api.sso.method, {body = data})
    if not body and self.log then
        log(err)
    end
    return body, err
end

function _M.sync_comments(self, data)
    if data  == nil then
        return nil, 'data cannot be empty'
    end
    local data = data and data or {}
    data.short_name = self.subdomain
    data.secret = self.secret
    local body, err = request(local_conf.api.sync_comments.url, local_conf.api.sync_comments.method, {body = data})
    if not body and self.log then
        log(err)
    end
    return body, err
end

function _M.sync_users(self, data)
    if data  == nil then
        return nil, 'data cannot be empty'
    end
    local data = data and data or {}
    data.short_name = self.subdomain
    data.secret = self.secret
    local body, err = request(local_conf.api.sync_users.url, local_conf.api.sync_users.method, {body = data})
    if not body and self.log then
        log(err)
    end
    return body, err
end

function _M.sync_posts(self, data)
    if data  == nil then
        return nil, 'data cannot be empty'
    end
    local data = data and data or {}
    data.short_name = self.subdomain
    data.secret = self.secret
    local body, err = request(local_conf.api.sync_posts.url, local_conf.api.sync_posts.method, {body = data})
    if not body and self.log then
        log(err)
    end
    return body, err
end

function _M.profile(self, data)
    if data  == nil then
        return nil, 'data cannot be empty'
    end
    local data = data and data or {}
    data.short_name = self.subdomain
    data.secret = self.secret
    local body, err = request(local_conf.api.profile.url, local_conf.api.profile.method, {body = data})
    if not body and self.log then
        log(err)
    end
    return body, err
end

function _M.comments(self, data)
    if data  == nil then
        return nil, 'data cannot be empty'
    end
    local data = data and data or {}
    data.short_name = self.subdomain
    data.secret = self.secret
    local body, err = request(local_conf.api.comments.url, local_conf.api.comments.method, {body = data})
    if not body and self.log then
        log(err)
    end
    return body, err
end



return _M