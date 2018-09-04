require 'openssl'

module Refinery
  module Employees
    class XeroApiKeyfile < Refinery::Core::BaseModel
      self.table_name = 'refinery_xero_api_keyfiles'

      validates :organisation,    presence: true, uniqueness: true
      validates :key_content,     presence: true
      validates :consumer_key,    presence: true
      validates :consumer_secret, presence: true
      validates :encryption_key,  presence: true

      def encrypt_consumer_key=(val)
        s = encrypt_cipher.update(val) + encrypt_cipher.final
        self.consumer_key = s.unpack('H*')[0].upcase
      end

      def encrypt_consumer_secret=(val)
        s = encrypt_cipher.update(val) + encrypt_cipher.final
        self.consumer_secret = s.unpack('H*')[0].upcase
      end

      def decrypt_consumer_key
        s = [consumer_key].pack("H*").unpack("C*").pack("c*")
        decrypt_cipher.update(s) + decrypt_cipher.final
      end

      def decrypt_consumer_secret
        s = [consumer_secret].pack("H*").unpack("C*").pack("c*")
        decrypt_cipher.update(s) + decrypt_cipher.final
      end

      private

      def encrypt_cipher
        return @encrypt_cipher if @encrypt_cipher.present?

        @encrypt_cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt

        if encryption_key.blank?
          self.encryption_key = @encrypt_cipher.random_key # Also assigns it to @ciper
        else
          @encrypt_cipher.key = encryption_key
        end

        @encrypt_cipher
      end

      def decrypt_cipher
        return @decrypt_cipher if @decrypt_cipher.present?

        @decrypt_cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt

        if encryption_key.blank?
          self.encryption_key = @decrypt_cipher.random_key # Also assigns it to @ciper
        else
          @decrypt_cipher.key = encryption_key
        end

        @decrypt_cipher
      end

    end
  end
end
