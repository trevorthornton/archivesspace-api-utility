class ArchivesspaceApiUtilityGenerator < Rails::Generators::NamedBase
  source_root(File.expand_path(File.dirname(__FILE__))
  def copy_initializer
    copy_file 'archivesspace_config.rb', 'config/initializers/archivesspace_config.rb'
  end
end