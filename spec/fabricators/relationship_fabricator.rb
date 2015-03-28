Fabricator(:relationship) do
  leader { Fabricate(:user) }
end
