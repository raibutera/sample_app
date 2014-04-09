require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_heading('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "profile page" do
    # use factory girl to make a user factory.
    let(:user) { FactoryGirl.create(:user) }

    before { visit user_path(user) }

    it { should have_heading(user.name) }
    it { should have_title(user.name) }
  end

  # from listing 7.16 - basic tests for signing up users
  describe "signup" do

      before { visit signup_path }

      let(:submit) { "Create My Account" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_title('Sign up') }
          it { should have_content('error') }
          
          it { should have_selector('div', class: 'alert-error') }
          it { should have_selector('li') }
        end
      end

      describe "with valid information" do
        before { valid_signup }

        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end

        describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email('user@example.com') }

          it { should have_title(user.name) }
          it { should have_success_message('Welcome') }

          # 8.26 - test that newly signed up users are also signed in
          it { should have_link('Sign out') }
        end
      end
    end

    describe "edit" do
      let(:user) { FactoryGirl.create(:user) }
      before do 
        sign_in user
        visit edit_user_path(user) 
      end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) {"New Name"}
      let(:new_email) {"new@example.com"}

      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it {should have_title('title')}
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end