FactoryBot.define do
  factory :employee do
    name { "Johnny Winter" }
    admin_user_id { FactoryBot.create(:admin_user).id }
  end
end
