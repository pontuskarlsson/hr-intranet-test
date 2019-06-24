class BaseMock
  attr_reader :attributes
  cattr_accessor :_current_id
  self._current_id = 0

  def initialize(*args)
    @attributes = {}

    args.extract_options!.each do |attr, value|
      @attributes[attr.to_sym] = value
    end
  end

  def method_missing(m, *args, &block)
    if @attributes.has_key?(m)
      @attributes[m]
    else
      super
    end
  end

  def to_h
    @attributes
  end

end
