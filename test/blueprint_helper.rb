Sham.define do
  description { Faker::Lorem.words(5).join(' ') }
  name  { Faker::Name.name }
  body  { Faker::Lorem.paragraphs(3).join("\n\n") }
  username { 'dustym' }
  password { 'new password' }
  name  { Faker::Name.name }
  email { Faker::Internet.email }
  title { Faker::Lorem.sentence }
  body  { Faker::Lorem.paragraph }
end

User.blueprint do
  username { Sham.username }
  email { Sham.email }
  first_name { Sham.name }
  age { User::Age::COLLEGE }
  age_preference { User::Age::MID_THIRTIES }
  sex { User::Sex::MALE }
  sex_preference { User::Sex::BOTH }
  description { Sham.description }
  cell { '4692314767' }
  timezone { 'Central Time (US & Canada)' }
  password { 'new password' }
  password_confirmation { 'new password' }
end

UserPlace.blueprint do
  user { User.make }
  place { Place.make }
  classification { Classification.make }
  description { Sham.description }
end

Category.blueprint do
  name { Sham.name }
end

Categorization.blueprint do
  category { Category.make }
  place { Place.make }
end

Classification.blueprint do
  name { Sham.name }
end

Place.blueprint do
  name { Sham.name }
end