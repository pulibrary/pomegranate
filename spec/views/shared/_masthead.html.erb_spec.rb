# frozen_string_literal: true

require 'rails_helper'

describe 'shared/_masthead', type: :view do
  let(:exhibit) { FactoryBot.create(:exhibit, subtitle: 'Some exhibit') }
  let(:masthead) { nil }

  before do
    stub_template 'shared/_exhibit_navbar.html.erb' => 'navbar'
    allow(view).to receive_messages(current_exhibit: exhibit,
                                    current_masthead: masthead,
                                    resource_masthead?: false,
                                    render_breadcrumbs: false)
  end

  it 'has the site title and subtitle' do
    render
    expect(rendered).to have_selector '.h1', text: exhibit.title
    expect(rendered).to have_selector 'small', text: exhibit.subtitle
  end

  context 'with an exhibit without a subtitle' do
    before do
      exhibit.update(subtitle: nil)
    end

    it 'does not include the subtitle' do
      render
      expect(rendered).not_to have_selector 'small'
    end
  end

  context "with no exhibit" do
    let(:exhibit) { nil }
    let(:subtitle) { "Stuff" }

    before do
      site = instance_double(Spotlight::Site, subtitle: subtitle)
      allow(view).to receive(:current_site).and_return(site)
      assign(:masthead_title, "Title")
    end

    it "renders the site subtitle and title" do
      render
      expect(rendered).to have_selector 'small', text: subtitle
      expect(rendered).to have_selector '.h1', text: "Title"
    end
  end
end
