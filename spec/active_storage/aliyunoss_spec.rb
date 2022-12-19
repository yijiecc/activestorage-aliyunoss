# frozen_string_literal: true

RSpec.describe ActiveStorage::Service::AliyunossService do

  it "has a version number" do
    expect(ActiveStorage::AliyunossService::VERSION).not_to be nil
  end

  it "should initilize an instance" do
    @service = ActiveStorage::Service.configure(:aliyunoss, configuration)
    expect(@service.public?).to be true
  end

  it "should upload file to aliyun oss" do
    file = File.join(__dir__, 'sample-file.png')
    fd = IO.sysopen(file, "r")
    io = IO.new(fd, "r")
    service.upload('sample.png', io)
    io.close
  end

  it "should upload file with checksum" do
    file = File.join(__dir__, 'sample-file.png')
    fd = IO.sysopen(file, "r")
    io = IO.new(fd, "r")
    service.upload('sample-md5.png', io, checksum: md5_for_local('sample-file.png'))
    io.close
  end

  it "should generate upload headers" do
    headers = service.headers_for_direct_upload('/key.dat', filename: "key.dat", content_type: 'application/json',
                                            content_length: 12345, checksum: 'FTAuDEnR8VxB27E2XDidEw==',
                                            custom_metadata: {})
    expect(headers['Authorization']).not_to be nil
    expect(headers['Content-MD5']).not_to be nil
    expect(headers['Content-Type']).not_to be nil
    expect(headers['Content-Length']).not_to be nil
    expect(headers['Date']).not_to be nil
    expect(headers['Content-Disposition']).not_to be nil
  end

  it "should download file" do
    remote_data = service.download('sample.png')
    local_data = IO.read(File.join(__dir__, 'sample-file.png'))
    md5 = OpenSSL::Digest::MD5
    expect(md5.digest(remote_data)).to eq(md5.digest(local_data))
  end

  it "should download chunks from aliyun oss" do
    range = "bytes=0-99"
    downloaded = service.download_chunk('sample.png', range)
    expect(downloaded.bytesize).to eq(100)
  end

  it "should delete file" do
    service.delete('sample.png')
    expect(service.exist? 'sample.png').to be false
  end

  it "should delete files with prefex" do
    file = File.join(__dir__, 'sample-file.png')
    fd = IO.sysopen(file, "r")
    io = IO.new(fd, "r")
    service.upload('000-sample.png', io)
    io.close

    service.delete_prefixed('000')
    expect(service.exist? '000-sample.png').to be false
  end

  it "should generate public url" do
    expect(service.url('sample.png')).to eq("https://active-storage-spec.oss-cn-beijing.aliyuncs.com/activestorage/sample.png")
  end

  private
  def service
    @_service ||= ActiveStorage::Service.configure(:aliyunoss, configuration)
  end

  def md5_for_local(file)
    md5 = OpenSSL::Digest::MD5
    data = IO.read(File.join(__dir__, file))
    md5.hexdigest(data + "sss")
  end

  def configuration
    {
      aliyunoss: 
        {
          service: "Aliyunoss",
          access_key_id: ENV["ALI_ACCESS_KEY"],
          access_key_secret: ENV["ALI_ACCESS_SECRET"],
          bucket: "active-storage-spec",
          location: "oss-cn-beijing",
          path: "/activestorage",
          is_public: true
        }
    }
  end
end
