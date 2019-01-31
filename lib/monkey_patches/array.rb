# frozen_string_literal: true

class Array
  def page(page = 1)
    @page = page&.zero? ? 1 : (page || 1)
    self
  end

  def per(per_page = 10)
    per = per_page&.zero? ? 10 : (per_page || 10)
    max_page = size / per + 1
    page = [ @page&.abs || 1, max_page ].min - 1
    self[ page * per..(page + 1) * per - 1 ]
  end

  def to_ha(rmv: [ ], add: [ ], merge: { })
    self.map do |datum|
      datum.to_h(rmv: rmv, add: add, merge: merge) if datum.respond_to? :_active_serialize
    end.compact
  end
end
