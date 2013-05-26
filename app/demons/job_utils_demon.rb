require 'net/http'

class JobUtilsDemon  # <  Struct.new(:user_id, :user_password)
  # def initialize(args)
    
  # end
  
  protected 
  
  def user_password
    "2c88462e7cc7bf6c58cf9879b082d9bd"
  end

  def user_id
    "176745"
  end 

  def get_data
    path_to_save = Rails.root.join('tmp', 'aw')
    obtained_file = path_to_save.join(feed_deflated)

    # raise feed_url.inspect
    download(domain, feed_url, path_to_save, feed_archive)
    extract(path_to_save ,feed_archive,feed_deflated )

    elements = get_csv_content(obtained_file)
    
    File.delete(path_to_save.join(feed_deflated))
    File.delete(path_to_save.join(feed_archive))

    elements
  end 

  def get_csv_content(obtained_file)
    elements = []

    if File.exists?(obtained_file)
      CSV.foreach(obtained_file, :headers => true) do |row|
        elements << row
      end
    end

    elements
  end

  def extract(path, archive_name, extracted_filename)
    begin
      Zip::ZipFile.open(path.join(archive_name)) do |zf| 
        zf.entries.each_with_index do |e, i| 
          if File.exists?(path.join(extracted_filename))
            raise "could not extract the file as already exists"
          else 
            zf.extract(e, path.join(extracted_filename))
          end
        end
      end
    rescue Zip­:­:Zip­Error => e
      
    end
  end 

  def download(domain,url, path_to_save, tmp_filename)
    Net::HTTP.start(domain) do |http|
      resp = http.request_get(url)

      open(path_to_save.join(tmp_filename), "wb") do |file|
        file.write(resp.read_body)
      end
    end

  end
  
end