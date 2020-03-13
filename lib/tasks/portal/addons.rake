namespace :portal do
  namespace :addons do
    namespace :zendesk do

      desc 'Synchronise Changes from Zendesk'
      task sync_changes: [:set_logger, :environment] do
        begin
          client = Portal::Zendesk::Client.client

          client.tickets.recent.each do |ticket|
            if (request = ::Refinery::Business::Request.find_by(zendesk_id: ticket.id)).present?
              if request.zendesk_meta && request.zendesk_meta['updated_at'] != ticket.updated_at
                request.zendesk_meta = ticket.attributes.to_hash
                request.save!

                ticket.comments.each do |comment|
                  unless request.comments.map(&:zendesk_id).include? comment.id
                    user = Refinery::Authentication::Devise::User.find_by email: comment.author.email

                    request.comments.create!(
                        comment_by: user,
                        comment_by_email: comment.author.email,
                        comment_by_full_name: comment.author.name,
                        commented_at: comment.created_at,
                        zendesk_id: comment.id,
                        body: comment.body
                    )
                  end
                end
              end
            end
          end

        rescue StandardError => e
          ErrorMailer.error_email(e).deliver
        end
      end


      task set_logger: :environment do
        if Rails.env.development?
          Rails.logger = Logger.new(STDOUT)
        end
      end

    end
  end
end
