class Array
  def page(page = nil)
    @page = page || 1
    self
  end

  def per(per_page = nil)
    per = per_page || 10
    per = 10 if per.zero?
    max_page = size / per + 1
    page = [ @page&.abs || 1, max_page ].min - 1
    self[ page * per..(page + 1) * per - 1 ]
  end

  def to_builder(rmv: [ ], add: [ ], merge: { })
    self.map do |datum|
      datum.to_builder(rmv: rmv, add: add, merge: merge) if datum.respond_to? :to_builder
    end.compact
  end
end
