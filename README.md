short url
=======
此项目是完整的短链接服务

此服务采用ruby+grape+mongodb实现,有序排列短链接，（无加密，可自定义，长度范围可设置1～8），后面实现加密方式

两种的说明如下

## 有序形式 ##
使用0~9a~v字符组成，不区分大小写，key从000001（默认设置6位），当达到最大值vvvvvv时，会从000001重新开始覆盖,总数为1073741824



## 使用方式 ##

* Ruby 2.2+
* Mongodb 2.0+

## 配置文件说明(config/application.yml) ##
* key_host      - 默认生成的短链接的域名部分
* key_length    - 默认生成的短链接的链接长度
* can_cover     - 自定义设置key时，是否能覆盖已有的key
* blank_key_url - 默认false，没有找到短链接时可以默认跳转的地址

```
bundle install
RACK_ENV=production puma (-p 端口 默认9292)
```
然后浏览器中访问[http://localhost:9292/views/index.html](http://localhost:9292/views/index.html)查看具体接口说明

可以删除 public/index.html 说明文件。




