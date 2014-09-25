require 'basecrm'

module Refinery
  module Contacts

    class BaseSynchroniser
      BASE_TOKEN = ENV['BASE_TOKEN']

      MAPPED_ATTR = %w(name first_name last_name address city skype zip country title private contact_id is_organisation mobile fax website phone description linked_in facebook industry twitter email organisation_name tags_joined_by_comma is_sales_account customer_status prospect_status custom_fields)

      attr_accessor :error

      def initialize
        # The API does not support querring at the moment
        #@last_modified_date = Refinery::Contacts::Contact.maximum(:base_modified_at)
      end

      def synchronise
        begin
          Refinery::Contacts::Contact.transaction do
            # Loops through all contacts from Base and updates the ones already
            # present in the database and creates the ones that are not
            base_contacts.each do |base_contact|
              if (contact = grouped_refinery_contacts[base_contact.id]).present?
                sync_contact contact, base_contact
              else
                contact = Refinery::Contacts::Contact.new
                contact.base_id = base_contact.id
                sync_contact contact, base_contact
              end
            end

            # Goes through all the contacts in the database that were not present
            # in the list of contacts from Base and flags them as removed.
            bc_ids = base_contacts.map(&:id)
            refinery_contacts.select { |rc| !bc_ids.include?(rc.id) }.each do |removed_contact|
              removed_contact.removed_from_base = true
              removed_contact.save!
            end
          end
          true
        rescue StandardError => e
          self.error = e
          false
        end
      end

    private
      def session
        @session ||= BaseCrm::Session.new(BASE_TOKEN)
      end

      def base_contacts
        return @_bc unless @_bc.nil?

        @_bc = []

        page = 1 # Contacts uses 1 as first page number
        while (contacts = session.contacts.params(page: page).all).any?
          @_bc += contacts
          page += 1
        end

        @_bc
      end

      # Retrieves all Contacts from database that are not flagged as removed
      # from Base and arranges them in a Hash where the keys are the id's from Base.
      def refinery_contacts
        @_rc ||= Refinery::Contacts::Contact.where(removed_from_base: false)
      end

      def grouped_refinery_contacts
        @_grc ||= refinery_contacts.inject({}) { |acc, rc| acc.merge(rc.base_id => rc) }
      end

      def sync_contact(contact, base_contact)
        MAPPED_ATTR.each do |attr|
          contact.send("#{attr}=", base_contact.send(attr))
        end
        if (o = base_contact.organisation).present? && (c = o['contact']).present? && (c_id = c['id']).present?
          contact.organisation_id = c_id
        end
        contact.base_modified_at = base_contact.updated_at
        contact.save!
      end

    end

  end
end
