require 'rails_helper'

RSpec.feature 'Catalog', type: :feature do
  let(:exhibit) { FactoryBot.create(:exhibit, title: 'Exhibit A') }
  let(:id) { 'd279a557a62937a8895eebbca2d4744c' }
  let(:title) { 'Panoramic alphabet of peace' }
  let(:rights) { 'http://rightsstatements.org/vocab/NKC/1.0/' }
  let(:document) do
    SolrDocument.new(
      id: id,
      readonly_title_tesim: [
        title
      ],
      'exhibit_abc_books_readonly_edm-rights_ssim': [
        rights
      ],
      'readonly_edm-rights_tesim': [
        rights
      ],
      exhibit_abc_books_readonly_license_ssim: [
        rights
      ],
      readonly_license_tesim: [
        rights
      ],
      access_identifier_ssim: [
        "1r66j4408"
      ],
      full_title_tesim: [
        title
      ],
      readonly_title_ssim: [
        title
      ],
      'readonly_title-sort_ssim': [
        title
      ],
      'readonly_edm-rights_ssim': [
        rights
      ],
      readonly_license_ssim: [
        rights
      ],
      _version_: 159,
      timestamp: "2018-02-19T22:19:52.244Z"
    )
  end

  context 'logged in as a site admin.' do
    let(:user) { FactoryBot.create(:site_admin, exhibit: exhibit) }

    before do
      sign_in user
      document.make_public! exhibit
      document.reindex
      Blacklight.default_index.connection.commit
    end

    scenario 'user searches for a collections with a keyword' do
      visit spotlight.search_exhibit_catalog_path(exhibit, search_field: 'all_fields', q: id)
      expect(page).to have_css '#documents .document h3.index_title', text: id
    end

    context 'when the document has metadata attributes with quotes' do
      before do
        exhibit2 = Spotlight::Exhibit.create title: 'Exhibit B', published: true
        document2 = SolrDocument.new(id: 'd279a557a62937a8895eebbca2d4744c', exhibit: exhibit)
        Spotlight::SolrDocumentSidecar.create!(
          document: document2, exhibit: exhibit2,
          data: { 'full_title_tesim' => ['"title1"'] }
        )
        document2.make_private!(exhibit2)
        document2.save
        Blacklight.default_index.connection.commit
      end

      scenario 'user searches for a collections with a keyword in quotes' do
        visit spotlight.search_exhibit_catalog_path(exhibit, search_field: 'all_fields', q: '"title1"')
        expect(page).to have_css '#documents .document h3.index_title', text: '"title1"'
      end
    end

    scenario 'user browses all collections' do
      visit spotlight.search_exhibit_catalog_path(exhibit, search_field: 'all_fields', q: '')
      expect(page).to have_link 'Home', href: '/exhibit-a'
      expect(page).to have_css '#documents .document h3.index_title', text: id
    end
  end
end
