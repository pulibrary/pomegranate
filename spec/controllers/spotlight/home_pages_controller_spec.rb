require 'rails_helper'

describe Spotlight::HomePagesController, type: :controller do
  routes { Spotlight::Engine.routes }
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:page) { exhibit.home_page }

  describe 'when signed in as a curator' do
    let(:user) { FactoryBot.create(:exhibit_curator, exhibit: exhibit) }

    before do
      sign_in user
    end

    describe '#update' do
      let(:manifest_url) { 'https://localhost/concern/scanned_resources/c1f34d59-152b-44bf-9936-d7a8b7cd26aa/manifest' }
      let(:region) { '486,2057,4063,3047' }
      let(:tilesource) { 'https://localhost/images/repository/9b%2Fa4%2F8c%2F9ba48c78119a4a3fb3513e6f7554d66c%2Fintermediate_file.jp2/info.json' }
      let(:updated_attributes) do
        {
          'title' => 'MyString',
          thumbnail_attributes: {
            source: 'exhibit',
            document_global_id: 'gid://pomegranate/SolrDocument/640f432f1e5dd217acc1d7f5943a7874',
            iiif_manifest_url: manifest_url,
            iiif_canvas_id: 'https://localhost/concern/scanned_resources/c1f34d59-152b-44bf-9936-d7a8b7cd26aa/manifest/canvas/d178814f-29ce-4c1a-9da7-ce0e0cd4b614',
            iiif_image_id: '',
            iiif_region: region,
            iiif_tilesource: tilesource
          }
        }
      end

      before do
        patch :update, params: { id: page, exhibit_id: page.exhibit.id, home_page: updated_attributes }
        page.reload
      end

      it 'updates the page thumbnail' do
        expect(page.thumbnail).to be_a Spotlight::FeaturedImage
        expect(page.thumbnail.iiif_manifest_url).to eq manifest_url
        expect(page.thumbnail.iiif_tilesource).to eq tilesource
        expect(page.thumbnail.iiif_region).to eq region
        expect(page.thumbnail_image_url).to eq 'https://localhost/images/repository/9b%2Fa4%2F8c%2F9ba48c78119a4a3fb3513e6f7554d66c%2Fintermediate_file.jp2/486,2057,4063,3047/400,300/0/default.jpg'
      end
    end
  end
end
