require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_heading('Sign in') }
    it { should have_title('Sign in') }
  end

  # from 8.5 - tests for signin failure
  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_error_message('Invalid') }

      # from 8.11 - correct tests for signin failure
      # flash shouldnt display once user navigates away from form
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
  end

  # from 8.6
  describe "with valid information" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      visit signin_path
      valid_signin(user)
    end

    it { should have_title(user.name) }
    it { should have_link('Profile', href: user_path(user)) }
    it { should have_link('Sign out', href: signout_path) }
    it { should_not have_link('Sign in', href: signin_path) }

    # test for signing out user
    describe "followed by signout" do
      before { click_link "Sign out" }
      it { should have_link('Sign in') }
    end
  end
end