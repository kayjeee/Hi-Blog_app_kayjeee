require 'rails_helper'

RSpec.feature 'User Show', type: :feature do
  let(:user) { User.create(name: 'Tom', photo: 'https://www.kasandbox.org/programming-images/avatars/leaf-blue.png', bio: 'He is a good programmer') }

  # Create more posts to exceed the pagination limit
  let!(:posts) do
    (1..10).map do |i|
      Post.create(author: user, title: "Post #{i}", text: "Text #{i}")
    end
  end

  scenario 'visiting the user Show page' do
    visit user_path(user)

    expect(page).to have_content('Tom')
    expect(page).to have_css("img[alt='Tom']", count: 1)
  end

  scenario 'visiting the user show page, you see the number of posts the user has written..' do
    visit user_path(user)

    # Expect to see the total number of posts
    expect(page).to have_content('10 posts')
  end

  scenario 'visiting the user show page, you see the 3 most recent posts and bio of the user has written..' do
    visit user_path(user)

    expect(page).to have_content('He is a good programmer')
    # Check that only the most recent posts are displayed
    expect(page).to have_content('Text 10')
    expect(page).to have_content('Text 9')
    expect(page).to have_content('Text 8')
    expect(page).not_to have_content('Text 7') # This post should not be visible
  end

  scenario 'has a link to the user index page' do
    visit user_path(user)

    expect(page).to have_button('See all posts')
    click_link 'See all posts'
    expect(current_path).to eq(user_posts_path(user))
  end

  scenario 'clicking a user post redirects to post show page' do
    visit user_path(user)
    click_link 'Text 2'
    expect(current_path).to eq(user_post_path(user, posts[1]))
  end

  # New scenario for pagination
  scenario 'pagination section is displayed when there are more posts than fit on the view' do
    visit user_path(user)

    # Expect to find a pagination section
    expect(page).to have_css('.pagination')
  end

  # New scenario to test if pagination works
  scenario 'clicking on pagination links takes you to the next page of posts' do
    visit user_path(user)

    # Click on the next page link in the pagination section
    click_link '2'

    # Ensure the URL reflects the next page
    expect(current_url).to include('?page=2')

    # Verify that the next set of posts is displayed
    expect(page).to have_content('Text 7') # Post from the next page
    expect(page).not_to have_content('Text 10') # Post from the first page
  end
end
