module Refinery
  module Business
    class Account < Refinery::Core::BaseModel
      self.table_name = 'refinery_business_accounts'

      has_many :invoices

      validates :organisation,    presence: true, uniqueness: true
      validates :key_content,     presence: true
      validates :consumer_key,    presence: true
      validates :consumer_secret, presence: true
      validates :encryption_key,  presence: true

      def encrypt_consumer_key(val)
        self.consumer_key = encrypt(val)
      end

      def encrypt_consumer_secret(val)
        self.consumer_secret = encrypt(val)
      end

      def decrypt_consumer_key
        decrypt consumer_key
      end

      def decrypt_consumer_secret
        decrypt consumer_secret
      end

      private

      def encrypt(plain_text)
        cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt

        self.encryption_key = Digest::SHA1.hexdigest(cipher.random_key) if encryption_key.blank?
        cipher.key = encryption_key

        s = cipher.update(plain_text) + cipher.final
        s.unpack('H*')[0].upcase
      end

      def decrypt(cipher_text)
        cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt

        self.encryption_key = Digest::SHA1.hexdigest(cipher.random_key) if encryption_key.blank?
        cipher.key = encryption_key

        s = [cipher_text].pack("H*").unpack("C*").pack("c*")
        cipher.update(s) + cipher.final
      end

    end
  end
end
