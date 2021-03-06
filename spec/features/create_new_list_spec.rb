require "rails_helper"

feature "Creating a new list" do
  before(:all) do 
    stub_geocoding
  end

  scenario "and simulate the entire application flow" do
    visit "/"
    click_link "Skapa en lista"

    fill_in "insamling_about", with: "Kids in need"
    fill_in "insamling_description", with: "They need blankets and food"
    fill_in "insamling_when", with: "Varje lördag klockan fem"
    fill_in_location with: "storgatan 1 12222 stockholm"
    fill_in "insamling_user_email", with: "good@person.com"
    click_button "Skapa lista"

    expect(page).to have_content(/skapades/)
    @insamling = Insamling.last

    user_clicks_admin_link_in_email

    add_need "Barnkläder", "Gärna bra kvalitet. För bäbisar"
    expect_number_of_needs_to_be 1

    add_need "Tandborstar", "För både barn och vuxna"
    expect_number_of_needs_to_be 2

    remove_need 1
    expect_number_of_needs_to_be 1
  end

  scenario "without required data shows validation errors" do
    visit "/"
    click_link "Skapa en lista"

    click_button "Skapa lista"

    expect(number_of_errors).to be 2
  end

  def user_clicks_admin_link_in_email
    visit "/insamlings/#{ @insamling.id }/admins/#{ @insamling.admin_token }"
  end

  def fill_in_location(options = {})
    fill_value = options.fetch(:with)
    first("#insamling_location", visible: false).set(fill_value)
  end

  def add_need(title, description)
    click_link "Lägg till mer i listan"

    fill_in "need_title", with: title
    fill_in "need_description", with: description
    click_button "Lägg till i listan"
  end

  def remove_need(index)
    need_element = all(".needs li")[index]
    need_element.click_link("Ta bort")
  end

  def number_of_errors
    all(".field_with_errors .error").length
  end

  def expect_number_of_needs_to_be(expected_number_of_needs)
    needs_in_page = all(".needs li")
    expect(needs_in_page.length).to eql(expected_number_of_needs)
  end

  def stub_geocoding
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.set_default_stub([
      {
        'latitude'     => 40.7143528,
        'longitude'    => -74.0059731,
        'address'      => 'gatan 1',
        'country'      => 'stan',
        'country_code' => 'SE'
      }
     ]
    )
  end
end
