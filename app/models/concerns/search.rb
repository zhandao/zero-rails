module Search
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def search(field_name = nil, with: value = nil)
      return all if field_name.nil? || with.nil?
      override = try("search_#{field_name}", with: with)
      return override if override
      raise ErrorFiled if column_names.exclude?(field_name.to_s)

      where("#{name.underscore.pluralize}.#{field_name} LIKE ?", "%#{with}%") # Search Engine
    end
  end

  class ErrorFiled < StandardError; end
end
