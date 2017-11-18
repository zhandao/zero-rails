class ArraySpdoc < NormalSpdoc
  set_path 'lib/monkey_patches/array' # TODO

  describe :per do
    subject is Array[1, 2, 3, 4, 5]
    # TODO: desc template
    context 'when there is no call to #page'
    context 'when no args are passed'
    biz 'abnormal call' do # biz?
      context 'when pass illegal args'
      context 'when it is called many times'
    end
  end

  describe :page do
    #
  end

  describe :to_builder do
    #
  end
end
