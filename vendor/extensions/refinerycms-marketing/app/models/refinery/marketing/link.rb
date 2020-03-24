module Refinery
  module Marketing
    class Link < Refinery::Core::BaseModel
      self.table_name = 'refinery_marketing_links'

      RELATIONS = {
          'Refinery::Marketing::Contact' => %w(employee),
          'Refinery::Marketing::Address' => %w(billing mail shipping street other)
      }.freeze

      belongs_to :contact
      belongs_to :linked,       polymorphic: true

      validates :relation,      inclusion: { in: proc { |l| Array(RELATIONS[l.linked_type]) } }
      validates :relation,      uniqueness: { scope: [:contact_id, :linked_id, :linked_type]},
                                unless: proc { |l| l.relation == 'other' }

      validate do
        if contact && linked
          errors.add(:linked_id, :invalid) unless contact.owner_id == linked.owner_id
        end
        if to.present?
          errors.add(:to, :invalid) unless to > from
        end
      end

      before_save do
        self.from ||= DateTime.now
      end

      def address_link?
        linked_type == 'Refinery::Marketing::Address'
      end

    end
  end
end
