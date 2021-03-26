# frozen_string_literal: true

require 'sinatra/base'
require 'pandoc-ruby'
require 'yaml'
require 'pathname'
require 'fileutils'
require 'open-uri'
require 'ptools'

class MaDo < Sinatra::Base
  require 'sinatra/reloader' if development?

  if File.which('pandoc').nil?
    puts '路径中找不到"pandoc",请先安装并添加到系统PATH中.'
    exit(1)
  end

  set :views, 'app/views'

  helpers do
    def markdown(file)
      PandocRuby.convert(File.read(file), {f: :markdown, to: :html}, :table_of_contents)
    end
  end

  FileUtils.mkdir_p('conf') unless Dir.exist?('conf')
  FileUtils.cp('config/config.example.yaml', 'conf/config.yaml') unless File.exist?('conf/config.yaml')

  config = YAML.load_file('conf/config.yaml')

  data_path = File.expand_path(config['docs_path'])
  welcome_file = File.join(data_path, "#{config['welcome_file_name']}.md")

  FileUtils.mkdir_p(data_path) unless Dir.exist?(data_path)
  FileUtils.cp('README.md', welcome_file) unless File.exist?(welcome_file)

  get '/*' do
    files = get_files(config, data_path)
    request_path = URI.decode_www_form_component(request.path)

    current_path = File.join(data_path, request_path)
    if File.exist?(current_path) && !File.directory?(current_path)
      current_file = current_path
    elsif request.path == '/'
      current_file = welcome_file
    else
      pass
    end

    current_p = ''
    files.each do |file|
      next if file[:child].nil?

      file[:child].each do |c_file|
        current_p = file[:path] if c_file[:path] == request_path
      end
    end

    erb :index, locals: {
        config: config,
        current: request_path,
        current_p: current_p,
        catalogs: files,
        contents: markdown(current_file)
    }
  end

  def get_files(config, path)
    files = []
    files.push Hash[name: config['welcome_file_name'],
                    path: "/#{config['welcome_file_name']}.md",
                    child: nil]
    Dir.foreach(path) do |filename|
      next if ['.', '..', "#{config['welcome_file_name']}.md"].include? filename

      c_files = []
      real_path = File.join(path, filename)
      x_path = "/#{filename}"
      if File.directory?(real_path)
        Dir.foreach(real_path) do |c_filename|
          next if %w[. ..].include? c_filename

          c_x_path = "/#{filename}/#{c_filename}"
          c_files.push Hash[name: remove_dot_md(c_filename),
                            path: c_x_path,
                            child: nil]
        end
      else
        c_files = nil
      end
      files.push Hash[name: remove_dot_md(filename),
                      path: x_path,
                      child: c_files]
    end
    files
  end

  def remove_dot_md(filename)
    result = filename
    if !filename.empty? && filename[filename.length - 3, filename.length - 1] == '.md'
      result = filename[0, filename.length - 3]
    end
    result
  end
end
