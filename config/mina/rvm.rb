namespace :rvm do
  task init: :common_env do
    invoke :'rvm:install'
  end

  task install: :common_env do
    # install rvm
     command %[gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3]
     command %[curl -L https://get.rvm.io | bash -s stable --auto-dotfiles]
     command %[export PATH="$PATH:$HOME/.rvm/bin"]
     command %{[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"}
     command %{
      rvm install 2.5.0
      rvm alias create default 2.5.0
      rvm use 2.5.0 --default --ignore-gemsets
    }
    if fetch(:ruby_china_ruby_source)
       command %[gem sources --add https://gems.ruby-china.org --remove https://rubygems.org/]
    end
     command %{ gem install bundler }
     command %[ ssh-keyscan -H github.com >> ~/.ssh/known_hosts ]
  end
end
