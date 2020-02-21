FactoryBot.define do
  factory :performance_evaluation do
    title { "Not great, but not bad either" }
    description { "He did just ok" }
    employee
  end
end
