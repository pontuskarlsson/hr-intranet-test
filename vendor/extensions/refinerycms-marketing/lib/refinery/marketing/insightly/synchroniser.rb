require 'api_client'

module Refinery
  module Marketing
    module Insightly
      class Synchroniser

        CONTACT_ATTR = %w(first_name last_name image_url)

        DEFAULT_ORG_ATTR = { 'ORGANISATION_NAME' => :name }.freeze

        ## Custom Fields ###
        #
        # If you need to double check field ids of custom fields
        #
        #   list_of('CustomFields')
        #
        CUSTOM_CONTACT_ATTR = {
            "CONTACT_FIELD_1" => nil, # "Lead Sources",
            "CONTACT_FIELD_2" => nil, # "Lead Status",
            "CONTACT_FIELD_3" => :facebook, # "Facebook",
            "CONTACT_FIELD_4" => :twitter, # "Twitter",
            "CONTACT_FIELD_5" => nil, # "Instagram",
            "CONTACT_FIELD_6" => :linked_in, # "LinkedIn",
            "CONTACT_FIELD_7" => nil, # "Tumblr",
            "CONTACT_FIELD_8" => nil, # "Google+",
            "CONTACT_FIELD_9" => nil, # "Pinterest",
            "CONTACT_FIELD_10" => :skype, # "Skype",
            "CONTACT_FIELD_11" => nil, # "TEMP Brands",
            "CONTACT_FIELD_12" => nil, # "TEMP Referred By",
            "CONTACT_FIELD_13" => nil, # "TEMP Lead Channel",
            "CONTACT_FIELD_14" => nil, # "Automation",
            "CONTACT_FIELD_15" => nil, # "Email, Additional",
            "CONTACT_FIELD_16" => nil, # "Website",
            "Sample_Sale_Customer_Status__c" => nil, # "Sample Sale Customer Status",
            "Sample_Sale_Newsletter_Status__c" => nil, # "Sample Sale Newsletter Status",
            "YouTube__c" => nil, # "YouTube",
            "Email_Other__c" => nil, # "Email (Other)",
            "mailchimp_id__c" => nil, # "Mailchimp ID"
        }

        CUSTOM_ORG_ATTR = {
            "ORGANISATION_FIELD_1" => nil, # "Lead Sources",
            "ORGANISATION_FIELD_2" => :code, # "Company Code",
            "ORGANISATION_FIELD_3" => :courier_company, # "Courier Company",
            "ORGANISATION_FIELD_4" => :courier_account_no, # "Courier Company A/C No.",
            "ORGANISATION_FIELD_5" => nil, # "Lead Status",
            "ORGANISATION_FIELD_6" => nil, # "Automation",
            "ORGANISATION_FIELD_7" => nil, # "Market(s)",
            "ORGANISATION_FIELD_8" => nil, # "Payment Terms",
            "ORGANISATION_FIELD_9" => nil, # "Instagram",
            "ORGANISATION_FIELD_10" => nil, # "Pinterest",
            "ORGANISATION_FIELD_11" => nil, # "Tumblr",
            "ORGANISATION_FIELD_12" => nil, # "Panjiva",
            "ORGANISATION_FIELD_13" => nil, # "Google+",
            "ORGANISATION_FIELD_14" => nil, # "Lyst",
            "ORGANISATION_FIELD_15" => :skype, # "Skype",
            "ORGANISATION_FIELD_16" => :email, # "Email, Organisation",
            "ORGANISATION_FIELD_17" => nil, # "BR No.",
            "ORGANISATION_FIELD_18" => :facebook, # "Facebook",
            "ORGANISATION_FIELD_19" => :twitter, # "Twitter",
            "ORGANISATION_FIELD_20" => :linked_in, # "LinkedIn",
            "ORGANISATION_FIELD_21" => nil, # "TEMP Brands",
            "ORGANISATION_FIELD_22" => nil, # "TEMP Referred By",
            "ORGANISATION_FIELD_23" => nil, # "TEMP Lead Channel",
            "ORGANISATION_FIELD_24" => nil, # "TEMP Website",
            "Courier_Company_Other__c" => nil, # "Courier Company (Other)",
            "YOUTUBE__c" => nil, # "YouTube",
            "xero_id_hr__c" => :xero_hr_id, # "Xero ID - Happy Rabbit Limited",
            "xero_id_hrt__c" => :xero_hrt_id, # "Xero ID - Happy Rabbit Trading Limited"
        }.freeze


        attr_accessor :error
        attr_reader :client

        def initialize(client = Client.new)
          @client = client
        end

        def push(contact, changes)
          return unless Insightly.configuration.updates_allowed

          begin
            if contact.is_organisation
              push_organisation contact, changes
            else
              push_contact contact, changes
            end
          rescue StandardError => e
            self.error = error
          end
        end

        def pull_all
          begin
            Refinery::Marketing::Contact.transaction do
              # Loops through all contacts from Base and updates the ones already
              # present in the database and creates the ones that are not

              ### Organisations ###
              @all_crm_ids = []
              client.list_of('Organisations').each do |crm_contact|
                @all_crm_ids << crm_contact.organisation_id

                if (contact = Refinery::Marketing::Contact.organisations.where(insightly_id: crm_contact.organisation_id).first).present?
                  pull_organisation contact, crm_contact

                elsif (contact = Refinery::Marketing::Contact.organisations.not_in_crm.where(name: crm_contact.organisation_name).first).present?
                  pull_organisation contact, crm_contact

                else
                  contact = Refinery::Marketing::Contact.new
                  pull_organisation contact, crm_contact
                end

                contact.save!
              end

              # Flags all the contacts that were not found in the latest sync from, as removed. By using +update_all+, no
              # callback is triggered. Is this correct? Are there other systems that needs to be notified that the contact
              # is removed? Xero???
              #
              Refinery::Marketing::Contact.organisations.in_crm.where.not(insightly_id: @all_crm_ids).update_all(removed_from_base: true)


              ### Contacts ###
              @all_crm_ids = []
              client.list_of('Contacts').each do |crm_contact|
                @all_crm_ids << crm_contact.contact_id

                if (contact = Refinery::Marketing::Contact.non_organisations.where(insightly_id: crm_contact.contact_id).first).present?
                  pull_contact contact, crm_contact

                elsif (contact = Refinery::Marketing::Contact.non_organisations.not_in_crm.where(first_name: crm_contact.first_name, last_name: crm_contact.last_name).first).present?
                  pull_contact contact, crm_contact

                else
                  contact = Refinery::Marketing::Contact.new
                  pull_contact contact, crm_contact
                end

                contact.save!
              end

              # Flags all the contacts that were not found in the latest sync from, as removed.
              Refinery::Marketing::Contact.non_organisations.in_crm.where.not(insightly_id: @all_crm_ids).update_all(removed_from_base: true)

            end
            true
          rescue StandardError => e
            self.error = e
            false
          end
        end

        private

        def custom_field_id(field_for, field_name)
          @custom_fields ||= client.get('CustomFields')

          if (field = @custom_fields.detect { |f| f['FIELD_FOR'] == field_for.upcase && f['FIELD_NAME'] == field_name.upcase }).present?
            field['CUSTOM_FIELD_ID']
          end
        end

        def pull_contact(contact, crm_contact)
          contact.insightly_id = crm_contact.contact_id
          contact.is_organisation = false
          contact.removed_from_base = false

          # Standard attributes
          contact.first_name = crm_contact.first_name
          contact.last_name = crm_contact.last_name
          contact.name = [crm_contact.first_name, crm_contact.last_name].reject(&:blank?).join(' ')
          contact.image_url = crm_contact.image_url
          contact.description = crm_contact.background

          # Contact Info
          contact.phone = crm_contact.contactinfo(:phone, :work)
          contact.mobile = crm_contact.contactinfo(:phone, :mobile)
          contact.fax = crm_contact.contactinfo(:phone, :fax)
          contact.email = crm_contact.contactinfo(:email)
          contact.website = crm_contact.contactinfo(:website)

          # Link Organisation
          if crm_contact.default_linked_organisation && (organisation = Refinery::Marketing::Contact.where(is_organisation: true).find_by_insightly_id(crm_contact.default_linked_organisation)).present?
            contact.organisation = organisation
            contact.organisation_name = organisation.name
            contact.title = crm_contact.links.detect { |r| r.organisation_id == crm_contact.default_linked_organisation }.try(:role)
          else
            contact.organisation = nil
            contact.organisation_name = nil
            contact.title = nil
          end

          # Sync Address
          pull_address contact, crm_contact

          # Sync Custom Fields
          pull_custom_fields contact, crm_contact, CUSTOM_CONTACT_ATTR

          # Tags
          contact.tags_joined_by_comma = crm_contact.tags.join(',')
        end

        def pull_organisation(contact, crm_contact)
          contact.insightly_id = crm_contact.organisation_id
          contact.is_organisation = true
          contact.removed_from_base = false

          # Standard attributes
          contact.name = crm_contact.organisation_name
          contact.organisation_name = crm_contact.organisation_name
          contact.image_url = crm_contact.image_url
          contact.description = crm_contact.background

          # Contact Info
          contact.phone = crm_contact.contactinfo(:phone, :work)
          contact.fax = crm_contact.contactinfo(:phone, :fax)
          contact.website = crm_contact.contactinfo(:website)

          # Sync Address
          pull_address contact, crm_contact

          # Sync Custom Fields
          pull_custom_fields contact, crm_contact, CUSTOM_ORG_ATTR

          contact.tags_joined_by_comma = crm_contact.tags.join(',')
        end

        def pull_address(contact, crm_contact)
          if crm_contact.primary_address
            contact.address = crm_contact.primary_address.street
            contact.city = crm_contact.primary_address.city
            contact.zip = crm_contact.primary_address.postcode
            contact.state = crm_contact.primary_address.state
            contact.country = crm_contact.primary_address.country
          end
        end

        def pull_custom_fields(contact, crm_contact, attribute_map)
          attribute_map.each_pair do |custom_field, mapped_to|
            if mapped_to.present?
              contact.send("#{mapped_to}=", crm_contact.customfield(custom_field))
            end
          end
        end

        def push_organisation(contact, changes)
          return unless Insightly.configuration.updates_allowed

          attr = (DEFAULT_ORG_ATTR.values + CUSTOM_ORG_ATTR.values) & changes.keys.map(&:to_sym)
          return if attr.empty?

          params = DEFAULT_ORG_ATTR.each_with_object({}) { |(remote, local), acc|
            if changes[local.to_s]
              acc[remote] = changes[local.to_s][1]
            end
          }

          custom_fields = CUSTOM_ORG_ATTR.each_with_object([]) { |(remote, local), acc|
            if local && changes[local.to_s]
              acc << { custom_field_id: remote, field_value: changes[local.to_s][1] }
            end
          }

          if params.any?
            if contact.insightly_id
              remote_contact = client.get("Organisations/#{contact.insightly_id}")
              client.put('Organisations', remote_contact.merge(params))
            else
              res = client.post('Organisations', params)
              contact.insightly_id = res['ORGANISATION_ID']
              contact.save!
            end
          end

          custom_fields.each do |custom_field_params|
            client.put("Organisations/#{contact.insightly_id}/CustomFields", custom_field_params)
          end
        end

        def push_contact(contact, changes)
          return unless Insightly.configuration.updates_allowed

        end

      end
    end
  end
end
