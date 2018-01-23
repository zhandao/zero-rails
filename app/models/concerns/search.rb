module Search
  def search(field_name = nil, with: val = nil)
    return unless field_name || with
    override = try("search_#{field_name}", with: with)
    return override if override
    return false if column_names.exclude?(field_name.to_s)

    where("#{field_name} LIKE ?", "%#{with}%")
  end
end
