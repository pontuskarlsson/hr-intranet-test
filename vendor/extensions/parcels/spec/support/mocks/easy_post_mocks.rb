class OrderMock < BaseMock

  def initialize(*args)
    super

    @attributes[:id] = "order_#{self._current_id += 1}"
  end

  def rates
    @rates ||= [
        RatesMock.new(id: 'rates_123456', rate: '500', currency: 'HKD', delivery_days: '1', service: 'NoNameExpressService', carrier: 'DHLExpress'),
        RatesMock.new(id: 'rates_123457', rate: '400', currency: 'HKD', delivery_days: '2', service: 'NoNameService', carrier: 'DHLExpress')
    ]
  end
end

class RatesMock < BaseMock

  def initialize(*args)
    super

    @attributes[:id] = "rates_#{self._current_id += 1}"
  end

end

class AddressMock < BaseMock

  def initialize(*args)
    super

    @attributes[:id] = "address_#{self._current_id += 1}"
  end

end
