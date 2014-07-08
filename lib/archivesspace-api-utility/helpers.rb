module ArchivesSpaceApiUtility::Helpers

  def self.included receiver
    receiver.extend self
  end

  # URI helper methods

  def repository_id_from_uri(uri)
    uri_split = uri.gsub(/\/repositories\//,'').split('/')
    uri_split[0].to_i
  end

  def resource_id_from_uri(uri)
    uri_split = uri.gsub(/\/repositories\//,'').split('/')
    uri_split[1] == 'resources' ? uri_split[2].to_i : nil
  end

  def archival_object_id_from_uri(uri)
    uri_split = uri.gsub(/\/repositories\//,'').split('/')
    uri_split[1] == 'archival_objects' ? uri_split[2].to_i : nil
  end

  def digital_object_id_from_uri(uri)
    uri_split = uri.gsub(/\/repositories\//,'').split('/')
    uri_split[1] == 'digital_objects' ? uri_split[2].to_i : nil
  end
  
  def resource_path_from_uri(uri)
    uri.gsub(/\/repositories\/\d+/,'')
  end

  def agent_type_from_uri(uri)
    uri_split = uri.gsub(/^\/?agents\//,'').split('/')
    uri_split[0].singularize
  end

  def subject_id_from_uri(uri)
    uri_split = uri.gsub(/^\/?subjects\//,'').split('/')
    uri_split[0]
  end


end