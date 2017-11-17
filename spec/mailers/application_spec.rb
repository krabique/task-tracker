# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  it 'sends a confirmation email to a proper address' do
    user = build(:user)
    expect { user.save }.to change(Devise.mailer.deliveries, :count).by(1)
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.from.first).to eq(
      'no-reply@agile-cove-39191.herokuapp.com'
    )
    expect(last_email.to.first).to eq user.email
    expect(last_email.subject).to eq 'Confirmation instructions'
  end
end
