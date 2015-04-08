Fabricator(:invitation) do
  addressee_email { Faker::Internet.email }
  token { SecureRandom.urlsafe_base64 }
end
