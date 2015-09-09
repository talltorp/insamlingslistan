require "rails_helper"

describe "Creating a new list" do
  it "from the home page" do
    visit "/"
    click_link "Skapa en lista"

    fill_in "insamling_about", with: "Kids in need"
    fill_in "insamling_description", with: "They need blankets and food"
    fill_in "insamling_user_email", with: "good@person.com"
    click_button "Skapa lista"

    expect(page).to have_content(/skapades/)
    @insamling = Insamling.last

    user_clicks_admin_link_in_email

    ensure_we_are_in_admin_area

    add_need "Barnkläder", "Gärna bra kvalitet. För bäbisar"
    expect_number_of_needs_to_be 1

    add_need "Tandborstar", "För både barn och vuxna"
    ensure_we_are_in_admin_area
    expect_number_of_needs_to_be 2

    remove_need 1
    ensure_we_are_in_admin_area
    expect_number_of_needs_to_be 1
  end

  def user_clicks_admin_link_in_email
    visit "/insamlings/#{ @insamling.id }/admins/#{ @insamling.admin_token }"
  end

  def add_need(title, description)
    fill_in "need_title", with: title
    fill_in "need_description", with: description
    click_button "Lägg till behov"
  end

  def remove_need(index)
    need_element = all("li")[index]
    need_element.click_link("Ta bort behov")
  end

  def expect_number_of_needs_to_be(expected_number_of_needs)
    needs_in_page = all("li")
    expect(needs_in_page.length).to eql(expected_number_of_needs)
  end

  def ensure_we_are_in_admin_area
    expect(current_path).to eq("/insamlings/#{ @insamling.id }/admins/#{ @insamling.admin_token }")
  end

  def current_path
    url = URI.parse(current_url)
    query = "?#{url.query}" if url.query.present?
    "#{url.path}#{query}"
  end
end
