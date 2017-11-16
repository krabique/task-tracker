# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'SignUpRoles', type: :feature do
  scenario 'user signs up as a developer and the only role he ' \
           'has is a developer role' do
    visit '/users/sign_up'

    within('#new_user') do
      fill_in 'user_name', with: 'Names Namie'
      fill_in 'user_email', with: 'names@namie.com'
      fill_in 'user_password', with: 'abcd1234'
      fill_in 'user_password_confirmation', with: 'abcd1234'
    end

    click_button 'Sign up'

    expect(User.last.developer_role).to be true
    expect(User.last.manager_role).to be false
  end

  scenario 'user signs up as a manager and the only role he ' \
           'has is a manager role' do
    visit '/users/sign_up'

    within('#new_user') do
      fill_in 'user_name', with: 'Names Namie'
      fill_in 'user_email', with: 'names@namie.com'
      fill_in 'user_password', with: 'abcd1234'
      fill_in 'user_password_confirmation', with: 'abcd1234'

      check 'user_manager_role'
    end

    click_button 'Sign up'

    expect(User.last.developer_role).to be false
    expect(User.last.manager_role).to be true
  end

  scenario 'user is trying to sign up as both manager and developer ' \
           'and receives an error' do
    visit '/users/sign_up'

    within('#new_user') do
      fill_in 'user_name', with: 'Names Namie'
      fill_in 'user_email', with: 'names@namie.com'
      fill_in 'user_password', with: 'abcd1234'
      fill_in 'user_password_confirmation', with: 'abcd1234'

      check 'user_manager_role'
      find('#user_developer_role', visible: false).click
    end

    click_button 'Sign up'

    expect(page).to have_content 'Only one role is allowed'
  end
end
