class CalendarLayout

  attr_reader :date

  def initialize(events, year = nil, month = nil)
    @events = events
    year ||= Date.today.year
    month ||= Date.today.month
    @date = Date.new(year.to_i, month.to_i, 1)
  end

  def each_row(&block)
    (0..weeks_for_month-1).each do |row|
      @current_row = row
      yield
    end
  end

  def each_cell(&block)
    (0..6).each do |cell|
      d = date_for(@current_row, cell)
      yield cell, d, grouped_events[d] || []
    end
  end

  def headers
    %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
  end

  def previous_month
    @previous_month ||= @date - 1.month
  end

  def next_month
    @next_month ||= @date + 1.month
  end

  def today
    @today ||= Date.today
  end

private
  def date_for(row, cell)
    date + row * 7 + cell - date.wday + 1
  end

  def weeks_for_month
    @weeks_for_month ||= (0.5 + (date.at_end_of_month.day + date.at_beginning_of_month.wday).to_f / 7.0).round
  end

  def grouped_events
    @_ge ||= (@date..@date.end_of_month).inject({}) { |acc, date| acc.merge(date => @events.select { |e| e.is_on_day?(date) }) }
  end

end
