class InitializerGenerator < Rails::Generators::NamedBase
  source_root(File.expand_path(File.dirname(__FILE__))
  def copy_initializer
    copy_file 'initializer.rb', 'config/initializers/archivesspace_config.rb'
  end
end