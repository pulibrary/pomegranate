
module Pomegranate
  class MetadataConfigurationsController < Spotlight::MetadataConfigurationsController
    private

      def exhibit_configuration_index_params
        views = @blacklight_configuration.default_blacklight_config.view.keys | [:show]

        @blacklight_configuration.blacklight_config.index_fields.keys.each_with_object({}) do |element, result|
          result[element] = (%i[enabled label weight text_area] | views)
        end
      end
  end
end
