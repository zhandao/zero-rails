module Export
  private

  # To use export, use gem `axlsx`, and:
  # add `set :export_path, '/tmp/project_name/export'` to deploy/*
  # add `export_path: /tmp/zero-rails/export` to settings.yml
  # add to mina/share.rb
  #   invoke :'share:mk_export' # in init
  #
  #   task mk_export: :common_env do
  #     command %[sudo mkdir -p "#{fetch(:export_path)}"]
  #     command %[sudo chown -R -v #{fetch(:user)}:#{fetch(:user)} "#{fetch(:export_path)}"]
  #   end

  def export_goods
    #   xlsx = File.new("#{Settings.export_path}/#{Time.current.to_i} goods_list.xlsx", 'w')
    #   Axlsx::Package.new do |p|
    #     p.workbook.add_worksheet(:name => 'Goods List') do |sheet|
    #       sheet.add_row %w[name base_category sub_category unit price creator created_at remarks on_sale]
    #       @data.page(@page).per(@rows).each do |good|
    #         sheet.add_row [
    #                           good.name,
    #                           *good.category.path,
    #                           *good.serializable_hash.values_at(*%w[unit price creator remarks]),
    #                           good.created_at.to_s,
    #                           good.on_sale ? 'yes' : 'no'
    #                       ]
    #       end
    #     end
    #     p.serialize(xlsx.path)
    #   end
    #   send_file xlsx.path
  end
end
