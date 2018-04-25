class IiifManifest < ::Spotlight::Resources::IiifManifest
  def to_solr
    add_noid
    # this is called in super, but idempotent so safe to call here also; we need the metadata
    add_metadata
    add_sort_title
    add_sort_date
    add_sort_author
    super
  end

  def add_noid
    solr_hash["access_identifier_ssim"] = [noid]
  end

  def add_sort_title
    # Once we upgrade we should probably use this json_ld_value?
    # solr_hash['sort_title_ssi'] = Array.wrap(json_ld_value(manifest.label)).first
    solr_hash['sort_title_ssi'] = Array.wrap(manifest.label).first
  end

  def add_sort_date
    solr_hash['sort_date_ssi'] = Array.wrap(solr_hash['readonly_date_ssim']).first
  end

  def add_sort_author
    solr_hash['sort_author_ssi'] = Array.wrap(solr_hash['readonly_author_ssim']).first
  end

  def full_image_url
    return super unless manifest['thumbnail'] && manifest['thumbnail']['service'] && manifest['thumbnail']['service']['@id']
    "#{manifest['thumbnail']['service']['@id']}/full/!600,600/0/default.jpg"
  end

  def json_ld_value(value)
    return value['@value'] if value.is_a?(Hash)
    return value.find { |v| v['@language'] == default_json_ld_language }.try(:[], '@value') || value.first if value.is_a?(Array)
    value
  end

  def compound_id
    Digest::MD5.hexdigest("#{exhibit.id}-#{noid}")
  end

  def ark_url
    return unless manifest["rendering"] && manifest["rendering"]["@id"]
    manifest["rendering"]["@id"]
  end

  def noid
    if ark_url
      /.*\/(.*)/.match(ark_url)[1]
    else
      /.*\/(.*)\/manifest/.match(url)[1]
    end
  end

  def manifest_metadata
    metadata = metadata_class.new(manifest).to_solr
    return {} unless metadata.present?
    create_sidecars_for(*metadata.keys)

    metadata.each_with_object({}) do |(key, value), hash|
      next unless (field = exhibit_custom_fields[key])
      field = BothFields.new(field)
      hash[field.field] = value
      hash[field.alternate_field] = value
    end
  end

  def create_sidecars_for(*keys)
    missing_keys(keys).each do |k|
      exhibit.custom_fields.create! label: k, readonly_field: true, field_type: "vocab"
    end
    @exhibit_custom_fields = nil
  end
end
