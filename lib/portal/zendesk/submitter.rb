module Portal
  module Zendesk
    class Submitter
      attr_reader :name, :email, :subject, :description

      def initialize(name, email, subject, description)
        @name, @email, @subject, @description = name, email, subject, description
      end

      def valid?
        [name, email, subject, description].all?(&:present?)
      end

      def submit!
        return false unless valid?

        user = find_or_create_user! email
        create_ticket! user, subject, description

        true

      rescue StandardError => e
        false
      end

      private

      def client
        @client ||= Portal::Zendesk::Client.client
      end

      def find_or_create_user!(email)
        client.users.search(query: email).first ||
            client.users.create!(email: email, name: name)
      end

      def create_ticket!(user, subject, description)
        client.tickets.create!(
            submitter_id: user.id,
            requester_id: user.id,
            subject: subject,
            description: description
        )
      end
    end
  end
end
