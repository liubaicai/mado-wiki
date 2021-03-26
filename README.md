# 欢迎使用mado-wiki

## 介绍
mado-wiki是一个简单的文档管理系统，markdown编写，纯文件结构无数据库

##  配置
```yaml
site_title:         'mado-wiki'
docs_path:          'data'
welcome_file_name:  'welcome'
```
- site_title: 站点名称
- docs_path: 文档存放路径,仅支持2级目录
- welcome_file_name: 首页文档名称

## 部署

### development
```bash
bundle install
ruby app.rb
```

### production
```bash
bundle install
pumactl start
```
访问 [http://localhost:9981](http://localhost:9981) 查看

## 反馈
- 官方 QQ 交流群：373715806
- 如果您喜欢该项目，请 [Star](https://github.com/liubaicai/mado-wiki/stargazers)
- 如果在使用过程中有任何问题， 请提交 [Issue](https://github.com/liubaicai/mado-wiki/issues)
- 如果您发现并解决了bug，请提交 [Pull Request](https://github.com/liubaicai/mado-wiki/pulls)
- 如果您想二次开发，欢迎 [Fork](https://github.com/liubaicai/mado-wiki/network/members)
