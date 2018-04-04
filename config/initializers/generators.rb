if Rails.env.development?
  Generators::Rspec::Config.tap do |c|
    c.params = {
        Token: '123456',
    }

    c.it_templates = {
        success: "is_expected.to eq :success"
    }

    c.desc_templates = {
        does_something: 'does something'
    }
  end
end
