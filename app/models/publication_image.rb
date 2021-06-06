class PublicationImage < ApplicationRecord

  belongs_to :publication

  mount_uploader :source, ImageUploader

  # validates :source, presence: true

  validates :source, file_size: { less_than_or_equal_to: 2.megabytes, message: 'Imagen debe ser menor de %{count}' },
                     file_content_type: { allow: ['image/jpeg', 'image/png'], message: 'Solo archivos tipo %{types} son permitidos' }

  def self.ri(num)
    offset(num).first(5).each do |ym|
      # if ym.source.mid_original.url.nil?
        begin
          ym.source.cache_stored_file!
          ym.source.retrieve_from_cache!(ym.source.cache_name)
          ym.source.recreate_versions!(:mid_original)
          ym.save!
          puts  "ERROR: Publication Image: #{ym.errors.full_messages}"
        rescue => e
          puts  "ERROR: Publication Image: #{ym.id} -> #{e.to_s}"
        end
      # end
    end
  end

end
