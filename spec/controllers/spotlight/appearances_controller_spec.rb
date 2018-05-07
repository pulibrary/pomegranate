require 'rails_helper'

describe Spotlight::AppearancesController, type: :controller do
  routes { Spotlight::Engine.routes }
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:first_nav) { exhibit.main_navigations.first }
  let(:last_nav) { exhibit.main_navigations.last }

  context 'when authenticated as an admin.' do
    let(:user) { FactoryBot.create(:site_admin) }

    before do
      sign_in user
    end

    describe '#update' do
      let(:document_global_id) { 'gid://pomegranate/SolrDocument/7e8ffe9ebabdee6c9d93522d2ad32efe' }
      let(:iiif_manifest_url) { 'https://repository.localdomain/concern/scanned_resources/dd7f4a41-899c-4eb5-af90-7ea7e7bf27b3/manifest' }
      let(:iiif_canvas_id) { 'https://repository.localdomain/concern/scanned_resources/dd7f4a41-899c-4eb5-af90-7ea7e7bf27b3/manifest/canvas/117e2dae-490b-41f6-8718-38bf603c68ce' }
      let(:iiif_region) { '1418,2182,2835,2835' }
      let(:iiif_tilesource) { 'https://localhost/iiif/repository/23%2F1f%2F95%2F231f954ddc494358968f17b274e89090%2Fintermediate_file.jp2/info.json' }
      let(:main_navigation_attributes) do
        {
          0 => { id: first_nav.id, display: 1, label: 'test nav label 1', weight: 128 },
          1 => { id: last_nav.id, display: 1, label: 'test nav label 2', weight: 256 }
        }
      end
      let(:masthead_attributes) do
        {
          display: '1',
          source: 'exhibit',
          document_global_id: document_global_id,
          iiif_manifest_url: iiif_manifest_url,
          iiif_canvas_id: iiif_canvas_id,
          iiif_image_id: '',
          iiif_region: iiif_region,
          iiif_tilesource: iiif_tilesource
        }
      end
      let(:submitted) do
        {
          exhibit_id: exhibit.id,
          exhibit: {
            thumbnail_attributes: {
              source: 'exhibit',
              document_global_id: document_global_id,
              iiif_manifest_url: iiif_manifest_url,
              iiif_canvas_id: iiif_canvas_id,
              iiif_image_id: '',
              iiif_region: iiif_region,
              iiif_tilesource: iiif_tilesource
            },
            masthead_attributes: masthead_attributes
          }
        }
      end

      it 'updates the exhibit thumbnail' do
        patch :update, params: submitted

        saved = exhibit.reload
        expect(saved.thumbnail.iiif_tilesource).to eq iiif_tilesource
        expect(saved.thumbnail.iiif_region).to eq iiif_region
        expect(saved.thumbnail.iiif_url).to eq 'https://localhost/iiif/repository/23%2F1f%2F95%2F231f954ddc494358968f17b274e89090%2Fintermediate_file.jp2/1418,2182,2835,2835/400,400/0/default.jpg'
      end

      it 'updates the exhibit masthead' do
        patch :update, params: submitted

        saved = exhibit.reload
        expect(saved.masthead.iiif_tilesource).to eq iiif_tilesource
        expect(saved.masthead.iiif_region).to eq iiif_region
        expect(saved.masthead.iiif_url).to eq 'https://localhost/iiif/repository/23%2F1f%2F95%2F231f954ddc494358968f17b274e89090%2Fintermediate_file.jp2/1418,2182,2835,2835/1800,180/0/default.jpg'
      end
    end
  end
end
