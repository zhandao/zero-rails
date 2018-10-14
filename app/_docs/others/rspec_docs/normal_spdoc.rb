class NormalSpdoc
  include Generators::Rspec::Normal if Rails.env.development?
end
