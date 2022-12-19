require 'active_storage'
require 'aliyunoss'

module ActiveStorage
  class Service::AliyunossService < Service

    # 
    # keyword arguments:
    # { 
    #    access_key_id: <%= ENV["ALI_ACCESS_KEY"] %>
    #    access_key_secret: <%= ENV["ALI_ACCESS_SECRET"] %>
    #    bucket: "[BUCKET_NAME]"
    #    location: "oss-cn-beijing"
    #    path: "[PATH]"
    #    is_public: true
    # }
    # 
    def initialize(bucket:, access_key_id:, access_key_secret:, location:, path:, is_public:)
      
      Aliyun::Oss::configure(
        :access_key_id => access_key_id,
        :access_key_secret => access_key_secret
      )

      @bucket = Aliyun::Oss::Bucket.new(name: bucket, location: location)
      @base_path = path
      @public = is_public

    end

    # Upload the +io+ to the +key+ specified. If a +checksum+ is provided, the service will
    # ensure a match when the upload has completed or raise an ActiveStorage::IntegrityError.
    # aliyunoss gem will calculate checksum again, so this is useless
    def upload(key, io, checksum: nil, **options)
      if checksum != nil
        options_with_checksum = options.merge('Content-MD5': checksum)
        @bucket.upload(io.read, path_for(key), options_with_checksum)
      else
        @bucket.upload(io.read, path_for(key), options)
      end
    end

    # Update metadata for the file identified by +key+ in the service.
    # Override in subclasses only if the service needs to store specific
    # metadata that has to be updated upon identification.
    def update_metadata(key, **metadata)
      raise NotImplementedError
    end

    # Return the content of the file at the +key+.
    def download(key)
      @bucket.download(path_for(key))
    end

    # Return the partial content in the byte +range+ of the file at the +key+.
    def download_chunk(key, range)
      @bucket.download(path_for(key), Range: range)
    end

    # Concatenate multiple files into a single "composed" file.
    def compose(source_keys, destination_key, filename: nil, content_type: nil, disposition: nil, custom_metadata: {})
      raise NotImplementedError
    end

    # Delete the file at the +key+.
    def delete(key)
      @bucket.delete(path_for(key))
    end

    # Delete files at keys starting with the +prefix+.
    def delete_prefixed(prefix)
      @bucket.list_files.each do |obj|
        file_name = obj.fetch('key', '')
        file_name = '/' + file_name if file_name != ''
        @bucket.delete(file_name) if file_name.start_with?(File.join(@base_path, prefix))
      end
    end

    # Return +true+ if a file exists at the +key+.
    def exist?(key)
      @bucket.exist? path_for(key)
    end

    # Returns the URL for the file at the +key+. This returns a permanent URL for public files, and returns a
    # short-lived URL for private files. For private files you can provide
    # the amount of seconds the URL will be valid for, specified in +expires_in+.
    def url(key, **options)
      instrument :url, key: key do |payload|
        generated_url =
          if public?
            public_url(key, **options)
          else
            private_url(key, **options)
          end

        payload[:url] = generated_url

        generated_url
      end
    end

    # Returns a signed, temporary URL that a direct upload file can be PUT to on the +key+.
    # The URL will be valid for the amount of seconds specified in +expires_in+.
    # You must also provide the +content_type+, +content_length+, and +checksum+ of the file
    # that will be uploaded. All these attributes will be validated by the service upon upload.
    def url_for_direct_upload(key, expires_in:, content_type:, content_length:, checksum:, custom_metadata: {})
      public_url(key)
    end

    # Returns a Hash of headers for +url_for_direct_upload+ requests.
    def headers_for_direct_upload(key, filename:, content_type:, content_length:, checksum:, custom_metadata: {})
      @bucket.direct_upload_headers(path_for(key), filename:, 
                                    content_type:, content_length:, checksum:, custom_metadata: {})
    end

    def public?
      @public
    end

    private
    def path_for(key)
      File.join(@base_path, key)
    end

    def private_url(key, expires_in:, **)
      @bucket.share(path_for(key), expires_in)
    end

    def public_url(key, **)
      "https://#{@bucket}.#{@location}.aliyuncs.com#{path_for(key)}"
    end

    def custom_metadata_headers(metadata)
      raise NotImplementedError
    end

    def instrument(operation, payload = {}, &block)
      ActiveSupport::Notifications.instrument(
        "service_#{operation}.active_storage",
        payload.merge(service: service_name), &block)
    end

    def service_name
      "Aliyunoss"
    end

    def content_disposition_with(type: "inline", filename:)
      disposition = (type.to_s.presence_in(%w( attachment inline )) || "inline")
      ActionDispatch::Http::ContentDisposition.format(disposition: disposition, filename: filename.sanitized)
    end

  end
end
