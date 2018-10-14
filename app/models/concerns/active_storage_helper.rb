module ActiveStorageHelper
  def file_name
    filename || file.filename.to_s.tap { |name| update(filename: name) }
  rescue Module::DelegationError
    nil
  end

  def md5
    Base64.decode64(file.checksum).unpack('H*').first
  rescue Module::DelegationError
    nil
  end

  def file_url
    return '' if Rails.env.in?(['development', 'test'])
    file.service_url
  rescue Module::DelegationError
    nil
  end
end
