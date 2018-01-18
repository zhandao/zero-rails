task :specs do
  system('rspec spec/models')
  system('rspec spec/api')
  # system('rake parallel:spec[^spec/api]')
end
