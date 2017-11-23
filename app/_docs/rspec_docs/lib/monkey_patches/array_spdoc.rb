class ArraySpdoc < NormalSpdoc
  set_path 'lib/monkey_patches/array' # TODO

  describe :per do
    subject is Array[1, 2, 3, 4, 5]

    let :each, 'each', :each_context

    wh 'there is no call to #page' do
      it :success
      it :does_something, is_expected: [1, 2, 3]
    end

    wh 'no args are passed'

    biz 'abnormal call' do # biz?
      wh 'pass illegal args'
      wh 'it is called many times'
    end
  end

  describe :page do
    #
  end

  describe :to_builder do
    #
  end
end
