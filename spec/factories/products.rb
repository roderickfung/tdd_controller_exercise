FactoryGirl.define do
  factory :product do
    name {|n| Faker::Name.name + n.to_s}
    description {Faker::ChuckNorris.fact}
    price {20 + rand(1000)}
    inventory {rand(100) + rand(100000)}
  end
end
