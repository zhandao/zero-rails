module SecureStorage
  extend self

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # acts_as_secure_storage :name
    def acts_as_secure_storage *fields
      @secure_storage = fields

      class_exec(fields) do |fields|
        fields.each do |field|
          # TODO: type convert (can set to int)
          # TODO: How do I know if it is encrypted? (last char is `=`?)
          define_method field do
            data = super()
            begin
              SecureStorage.decrypt(data)
            rescue # TODO
              update!(field => SecureStorage.encrypt(data))
              data
            end
          end
        end

        before_save do
          fields.each do |field|
            unless changes[field].nil?
              begin
                SecureStorage.decrypt(send(field))
              rescue # TODO
                send("#{field}=", SecureStorage.encrypt(send(field)))
              end
            end
          end
        end

        define_singleton_method :where do |*args|
          return super(*args) if args.blank?
          fields.each do |field|
            next unless args.last.key? field
            value = args.last[field]
            args.last[field] = SecureStorage.encrypt(value)
          end
          super(*args)
        end

        define_singleton_method :find_by do |hash|
          return super(hash) if fields.exclude?(hash.keys.first)
          hash = hash.first
          hash[1] = SecureStorage.encrypt(hash[1])
          super(Hash[[hash]])
        end
      end
    end

    def secure_storage!
      all
      #     .to_a.each do |item|
      #   data = @secure_storage.map do |field|
      #     [field, item.send(field)]
      #   end
      #   item.update!(Hash[data])
      # end
    end
  end

  def encrypt(data)
    return if data.blank?
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.encrypt
    cipher.key = symmetric_key
    data = cipher.update(data) << cipher.final
    Base64.strict_encode64(data)
  end

  # def encrypt_if_can(data)
  #   begin
  #     SecureStorage.decrypt(data)
  #   rescue
  #     SecureStorage.encrypt(data)
  #   end
  # end

  def decrypt(data)
    return if data.blank?
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.decrypt
    cipher.key = symmetric_key
    data = cipher.update(Base64.strict_decode64(data)) << cipher.final
    data.force_encoding('utf-8')
  end

  # TODO: new_key migration support
  def symmetric_key
    key = Settings.secure_storage.send(name.underscore) || Settings.secure_storage.default
    OpenSSL::Digest::SHA256.new(key).digest
  end
end
