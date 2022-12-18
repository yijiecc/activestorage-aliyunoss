# ActiveStorage的阿里云存储适配器

该Gem是一个Aliyun OSS插件，可为Rails 7.0的Active Storage添加阿里云对象存储接口。

## 安装方法

在Rails工程中的Gemfile中添加以下代码：

    gem "activestorage-aliyunoss", "~> 0.1"

然后运行bundle install即可。

## 使用方法

### 配置文件

Active Storage的配置文件在/config/storage.yml文件中，请添加以下配置信息：

    aliyun:
      service: "Aliyunoss"
      
      # 阿里云开发者信息
      access_key_id: <%= ENV["ALI_ACCESS_KEY"] %>
      access_key_secret: <%= ENV["ALI_ACCESS_SECRET"] %>
      
      # Bucket名称
      bucket: "[Bucket_Name]"
      
      # Bucket位置
      location: "oss-cn-beijing"
      
      # 根目录
      path: "/"
      
      # 根据创建的Bucket访问类型选择
      is_public: true

### 调用方法

配置完成后，可以按照[Active Storage](https://edgeguides.rubyonrails.org/active_storage_overview.html)手册调用。

## 开发

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yijiecc/activestorage-aliyunoss. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yijiecc/activestorage-aliyunoss/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

