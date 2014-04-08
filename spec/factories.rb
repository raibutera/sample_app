FactoryGirl.define do
  factory :user do
    name  "Hippo Potamus"
    email "hippo@potamus.io"
    password "foobar"
    password_confirmation "foobar"
  end
end