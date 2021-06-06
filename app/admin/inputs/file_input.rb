class FileInput < Formtastic::Inputs::FileInput
	def to_html
		input_wrapping do
			label_html <<
			builder.file_field(method, input_html_options) <<
			image_preview_content
		end
	end

	private

	def image_preview_content
		image_preview? ? image_preview_html : ""
	end

	def image_preview?
		begin
			@object.send(method).present?
		rescue
			puts 'Good'
		end
	end

	def image_preview_html
		begin
			template.image_tag(@object.send(method).url, class: "image-preview", width: 150 )
		rescue
			puts 'Good'
		end
	end
end
