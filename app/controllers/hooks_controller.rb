class HooksController < ApplicationController
  CALENDAR_FUNCTION = 'QCSchedule'

  before_filter :verify_hook
  skip_before_filter :verify_authenticity_token, :authenticate_refinery_user!

  def catch
    ActiveRecord::Base.transaction do
      @xlsx = Roo::Excelx.new(params[:file].tempfile.path, file_warning: :ignore)
      sheet = @xlsx.sheet('SCHEDULE')

      calendar = ::Refinery::Calendar::Calendar.find_or_create_by_function!(CALENDAR_FUNCTION, {
          title: 'QC Schedule',
          private: false,
          activate_on_create: true,
          default_rgb_code: '00ccff'
      })

      msgs = []
      names = []
      dates = {}

      benchmark = Date.today - 30.days

      (sheet.first_column..sheet.last_column).each do |idx|
        col = sheet.column(idx)

        if col[1].is_a?(Date)
          if col[1] > benchmark && col[2].present?
            dates[col[1]] = {
                client: col[2],
                supplier: col[3],
                factory: col[4],
                styles: col[5],
                po: col[6],
                type: col[7],
                project: col[8]
            }
          end

        elsif col[1].is_a?(String)
          names << col[1] if col[1].present?
        end
      end

      if names.uniq.length != 1
        name = names.inject(Hash.new(0)) { |acc, n| acc[n] += 1; acc }.max_by { |_,v| v }.first
        msgs << "Found more than one name in the Schedule (#{names.uniq.join(', ')}) but assuming #{name}."
      else
        name = names.first
      end

      if dates.any?
        events = calendar.events.where('title LIKE ?', "#{name}:%").between_times(dates.keys.min, dates.keys.max).order(:starts_at)
        updated = []
        dates.each_pair do |date, details|
          title = "#{name}: #{details[:client]}"
          excerpt = "#{details[:client]} @ #{details[:factory]} #{details[:project].present? ? "(#{details[:project]})" : ''}"
          description = "#{name} doing inspections at #{details[:factory]}#{details[:supplier].present? ? " (#{details[:supplier]})" : ''} for the client #{details[:client]}. " <<
          "PO: #{details[:po]}, Styles: #{details[:styles]}"

          if (event = events.detect { |e| e.title == title && e.starts_at.to_date == date }).present?
            updated << event.id
            event.attributes = { excerpt: excerpt, description: description }
            event.save!

          else
            event = calendar.events.build(
                title: title,
                excerpt: excerpt,
                description: description
            )
            event.starts_at = date.beginning_of_day
            event.ends_at = date.end_of_day
            event.save!
          end
        end

        # Removing the dates that are no longer in the file
        events.each do |event|
          unless updated.include? event.id
            event.destroy
          end
        end

      else
        msgs << "Found no scheduled inspections (looking for inspections on or after #{benchmark})."
      end

      if msgs.any?
        ErrorMailer.schedule_notification_email(msgs, @xlsx).deliver
      end

      render text: 'success', status: :ok
    end

  rescue RangeError => e
    ErrorMailer.schedule_error_email(e, @xlsx).deliver
    render text: 'failed', status: '400'

  rescue StandardError => e
    binding.pry
    ErrorMailer.schedule_error_email(e, @xlsx).deliver
    render text: 'failed', status: '400'
  end

  protected

  def verify_hook
    if params[:webhook_key] != ENV['WEBHOOK_SCHEDULE_KEY']
      render nothing: true, status: :not_found
    end
  end

  def payload_params
    params.to_unsafe_hash.except('controller', 'action', 'webhook_key')
  end

end
