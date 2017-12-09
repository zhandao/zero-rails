# https://activeadmin.info/documentation.html

ActiveAdmin.register User do
  config.sort_order = 'id_desc'
  # config.sort_order = 'id_asc'

  batch_action :action, priority: 1, if: proc { true }, confirm: 'Are you sure??' do |ids|
    # ...
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  # Assuming you're on the Books index page, and Book has_one Publisher:
  #
  # controller do
  #   def scoped_collection
  #     super.includes :publisher # prevents N+1 queries to your database
  #   end
  # end
  # Then it's simple to sort by any Publisher attribute from within the index table:
  #
  # index do
  #   column :publisher, sortable: 'publishers.name'
  # end

  permit_params *%i[name password password_confirmation email phone_number]

  show do
    attributes_table do
      %i[name email phone_number].each { |prop| row prop }
      # row('followers') { |user| textarea user.followers.pluck(:name).join("\n") }
    end
  end

  index do
    selectable_column
    id_column
    %i[name email].each { |prop| column prop }

    column 'Phone', :phone_number do |user|
      '+86'.concat user.phone_number if user.phone_number.present?
    end

    %i[created_at updated_at].each do |prop|
      column prop do |user|
        Time.at(user.send(prop)).strftime('%Y-%m-%d %H:%M:%S')
      end
    end

    # column :url do |user|
    #   link_to 'home', user.url, target: '_blank'
    # end

    # actions
    actions defaults: true, dropdown: false do |user|
      item 'View', 'http://github.com'
    end
  end

  before_save do |user|
    # nothing
  end

  form do |f|
    f.inputs 'Edit User' do
      # f.input :user_info, as: :select, collection: UserInfo.pluck(:email)
      %i[name password password_confirmation email phone_number].each { |prop| f.input prop }
      # f.input :name, label: 'User Name'
    end
    f.actions
  end
end
