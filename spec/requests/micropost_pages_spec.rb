require 'spec_helper'

describe "Micropost pages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
  end

  describe "micropost creation" do
    before {visit root_path}

    describe "with invalid information" do
      it "should not create a micropost" do
        expect{click_button "Post"}.to change(Micropost, :count).by(1)
      end
    end
  end
end
