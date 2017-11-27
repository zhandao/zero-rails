module SecureStorage
  extend self

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # acts_as_secure_storage :name
    def acts_as_secure_storage *fields
      class_exec(fields) do |fields|
        fields.each do |field|
          define_method field do
            data = super()
            begin
              SecureStorage.decrypt(data)
            rescue # TODO
              update!(field => SecureStorage.encrypt(data))
              data
            end
          end

          before_save do
            # TODO: saved_changes.transform_values(&:first)
            begin
              SecureStorage.decrypt(send(field))
            rescue # TODO
              send("#{field}=", SecureStorage.encrypt(send(field)))
            end
          end
        end
      end
    end
  end

  def encrypt(data)
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.encrypt
    cipher.key = symmetric_key
    data = cipher.update(data) << cipher.final
    Base64.strict_encode64(data)
  end

  def decrypt(data)
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.decrypt
    cipher.key = symmetric_key
    cipher.update(Base64.strict_decode64(data)) << cipher.final
  end

  # TODO: new_key migration support
  def symmetric_key
    key = Settings.secure_storage.send(name.underscore) || Settings.secure_storage.default
    OpenSSL::Digest::SHA256.new(key).digest
  end
end
