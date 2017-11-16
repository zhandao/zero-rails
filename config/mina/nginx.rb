namespace :nginx do
  task init: :env do
    invoke :'nginx:update_config'
    invoke :'nginx:link_config'
  end

  task update_config: :common_env do
    content = erb('config/nginx.conf.erb')
    command %(echo 'update nginx conf')
    command %(echo '#{content}' | sudo tee #{fetch(:nginx_etc_dir)}/sites-available/zero.conf > /dev/null)
  end

  task link_config: :common_env do
    command %(
      if [ ! -e #{ fetch(:nginx_etc_dir)}/sites-enabled/zero.conf ]; then
        sudo ln -s #{ fetch(:nginx_etc_dir)}/sites-available/zero.conf #{fetch(:nginx_etc_dir)}/sites-enabled/zero.conf
      fi
    )
  end

  task restart: :common_env do
    command %{sudo nginx -s reload}
  end
end
