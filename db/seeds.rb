# puts "REINDEX START"
# Post.reindex
# ConsultQuestion.reindex
# puts "REINDEX DONE"
#
# #
#
require 'faker'
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
#
# info = Information.new
# info.remote_logo_url = "#{Rails.root}/uploads/information/logo/1/logotype.png"
# info.facebook_link = "http://facebook.com"
# info.twitter_link ="http://facebook.com"
# info.linkedin_link ="http://facebook.com"
# info.remote_meta_image_url = "#{Rails.root}/uploads/information/meta_image/1/mall.jpg"
# info.blog_sidebar_title = "LOS MAS VISTOS"
# info.copyrights_text = "Todos los derechos reservados"
# info.contact_email = "contacto@agroneto.com"
# info.contact_address = "CALLE 67 A NO 29 A 48"
# info.contact_phone ="3165793255"
# info.remote_small_logo_url = "#{Rails.root}/uploads/information/small_logo/1/logo.png"
# info.save validate: false
#
# puts "Restarting CATEGORIES and SUBCATEGORIES tables indexes"
#
# Country.create name: "Colombia"
#
# puts "Iniciando Departamentos..."
# Department.create(
#   [
#     {name: 'Amazonas', country_id: 1},
#     {name: 'Antioquia', country_id: 1},
#     {name: 'Arauca', country_id: 1},
#     {name: 'Archipiélago de San Andrés Providencia y Santa Catalina', country_id: 1},
#     {name: 'Atlántico', country_id: 1},
#     {name: 'Bogotá D.C', country_id: 1},
#     {name: 'Bolívar', country_id: 1},
#     {name: 'Boyacá', country_id: 1},
#     {name: 'Caldas', country_id: 1},
#     {name: 'Caquetá', country_id: 1},
#     {name: 'Casanare', country_id: 1},
#     {name: 'Cauca', country_id: 1},
#     {name: 'Cesar', country_id: 1},
#     {name: 'Chocó', country_id: 1},
#     {name: 'Córdoba', country_id: 1},
#     {name: 'Cundinamarca', country_id: 1},
#     {name: 'Guainía', country_id: 1},
#     {name: 'Guaviare', country_id: 1},
#     {name: 'Huila', country_id: 1},
#     {name: 'La Guajira', country_id: 1},
#     {name: 'Magdalena', country_id: 1},
#     {name: 'Meta', country_id: 1},
#     {name: 'Nariño', country_id: 1},
#     {name: 'Norte de Santander', country_id: 1},
#     {name: 'Putumayo', country_id: 1},
#     {name: 'Quindio', country_id: 1},
#     {name: 'Risaralda', country_id: 1},
#     {name: 'Santander', country_id: 1},
#     {name: 'Sucre', country_id: 1},
#     {name: 'Tolima', country_id: 1},
#     {name: 'Valle del Cauca', country_id: 1},
#     {name: 'Vaupés', country_id: 1},
#     {name: 'Vichada', country_id: 1}
#   ]
# )
# puts "Terminado Departamentos"

if City.all.count < 9
  puts "Iniciando Ciudades..."
  require 'csv'
  #csv_text = File.read('/Users/jacksonflorez/Desktop/Jack Air/proyectos/rubi/db/DIVIPOLA_Codigos_municipios.csv')
  csv_text = File.read("#{Rails.root}/db/DIVIPOLA_Codigos_municipios.csv")

  csv = CSV.parse(csv_text, headers: true)
  csv.each do |raw_row|
    row = raw_row.to_hash
    departamento = Department.find_by_name(row["Nombre Departamento"])
    unless departamento.nil?
      departamento.cities.create(name: row["Nombre Municipio"], department_id: departamento.id)
    end
  end
  puts "Terminado Ciudades"
end


codes_no_created = []

puts "Loading CATEGORIES from CSV..."

csv_text = File.read(Rails.root.to_s+'/db/categories.csv')
csv = CSV.parse(csv_text, :headers => true)

puts "Saving CATEGORIES Data..."
csv.each do |raw_row|
  row = raw_row.to_hash
  puts "===>#{row}"
  begin
    puts "SAVING CATEGORY: #{row}"

    category = Category.new id: row["id"].to_i + 14, name: row["name"], subject: Publication.getSubjectFromInt(row["subject"].to_s)
    category.for_news = false
    category.save

  rescue => error
    puts "ERROR Creating row #{row["id"]}..."
    #codes_no_created.push row.to_hash
  end
end

puts "Loading SUBCATEGORIES from CSV..."

csv_text = File.read(Rails.root.to_s+'/db/subcategories.csv')
csv = CSV.parse(csv_text, :headers => true)

puts "Saving SUBCATEGORIES Data..."
csv.each do |raw_row|
  row = raw_row.to_hash
  puts "===>#{row}"
  begin
    puts "SAVING SUBCATEGORY: #{row}"

    Subcategory.create name: row["name"], category_id: row["category_id"].to_i + 14

  rescue => error
    puts "ERROR Creating row #{row["id"]}..."
    # puts "ERROR #{error.backtrace}..."
    #codes_no_created.push row.to_hash
  end
end

# CSV.open("/home/rails/rails_project/db/codes_no_created.csv", "wb") do |csv|
#     csv << ["code_segment", "name_segment", "code_family", "name_family", "code_class", "name_class", "code_product", "name_product"]
#     codes_no_created.each do |hash|
#         csv << [hash["code_segment"], hash["name_segment"], hash["code_family"], hash["name_family"], hash["code_class"], hash["name_class"], hash["code_product"], hash["name_product"]]
#     end
# end

# -  Hacer 20 usuarios
# -  Cada usuario que tenga 50 publicaciones
# -  Tendrá 5 vehiculos, 5 inmuebles, 3 servicios, 12 animales, 25 productos
# -  Cada vehiculo estará en un random de subcategorias de vehiculos
# -  Cada inmueble estará en una ciudad diferentes
# -  Cada servicio estará en una categoría diferente.
# -  Cada 3 animales estarán en categorías diferentes
# -  Cada producto estará en categorías diferentes, con unidades diferentes, misma locación, mitad nuevos mitad usados
# -  15 de las publicaciones de productos serán GOLD
# -  la mitad de publicaciones que tengan preguntas y respuestas

imageO = PublicationImage.new
imageO.remote_source_url = Faker::Avatar.image
imageO.save validate: false

cities = City.all
(2..10).each do |i|
  Level.create name: Faker::Games::Pokemon.name, min: i*100, max: i*100*2, number: i, description: Faker::Lorem.paragraphs
end
(1..30).each do |i|
  Achivement.create name: Faker::JapaneseMedia::DragonBall.character, remote_icon_url: Faker::Avatar.image, description: Faker::Lorem.paragraph, points: i*10, kind: i <= 10 ? 1 : i <= 20 ? 2 : 3
end
(1..20).each do |i|
  Interest.create name: Faker::Movie.title, description: Faker::Movie.quote
end

Plan.create name: "Free", price: 0, visibility_level: 1, unlimited_time: false, points: 50, color: "grey", description: Faker::Lorem.paragraph, priority: 1
Plan.create name: "Pro", price: 20000, visibility_level: 2, unlimited_time: true, points: 200, color: "gold", description: Faker::Lorem.paragraph, priority: 1

(1..20).each do |i|
  puts "CREATING USER"
  name = Faker::JapaneseMedia::OnePiece.character
  birthdate = Faker::Date.between(from:50.years.ago, to: 15.years.ago)

  offset = rand(cities.count)
  city_id = cities.offset(offset).first.id

  profession = Faker::Job.title
  phone = Faker::PhoneNumber.cell_phone
  address = Faker::Address.street_address
  main_activity = Faker::Job.field
  email = "#{name.downcase.gsub(' ','_')}.#{i}@shogyo_geekoi.com"

  image = Faker::Avatar.image
  current_points = 0

  user = User.new name: name, birthdate: birthdate, city_id: city_id, profession: profession, phone: phone, address: address, main_activity: main_activity, email: email, current_points: current_points, password: "12345678", password_confirmation: "12345678"

  user.remote_image_url = Faker::Avatar.image

  # user.skip_confirmation!
  user.save validate: false
  user.remote_image_url = Faker::Avatar.image
  subcategories = Subcategory.includes(:category).where({categories: {for_news: [nil, false]}}).references(:category)

  puts "CREATING PUBLICATIONS FOR USER: #{user.id} - #{user.name}"

  (1..100).each do |j|

    publication = user.publications.new status: 1

    publication.description = Faker::Lorem.paragraphs(number: 5).join
    publication.start_date = Faker::Date.between(from: 15.days.ago, to: 3.days.ago)
    publication.end_date = publication.start_date + 1.month
    publication.address = Faker::Address.street_address
    publication.city_id = user.city_id
    publication.step = 4
    publication.visits_count = rand(300)

    if j <= 5
      #VEHICULOS
      publication.title = "#{Faker::Games::Zelda.item} #{Faker::Games::Zelda.location}"
      publication.subject = Publication::VEHICULOS
      publication.price = Faker::Number.between(20000000, 100000000)

      aux_subcategories = subcategories.where({categories: {subject: publication.subject}})
      offset = rand(aux_subcategories.count)
      publication.subcategory_id = aux_subcategories.offset(offset).first.id

      publication.year = Faker::Date.between(from: 30.years.ago, to: 1.year.ago).year
      publication.brand = Faker::Vehicle.manufacture
      publication.km = rand(100000)
      publication.cylinder = Faker::Number.between(1000, 5000)
      publication.model = Faker::Movies::HarryPotter.spell

      tr_array = ["Manual", "Manual", "Automático", "Secuencial"]
      tr_random = Faker::Number.between(from: 1, to: 3)
      publication.transmission = tr_array[tr_random]

      publication.color = Faker::Color.color_name.camelcase

      fl_array = ["Gasolina", "Gasolina", "Disel", "Gas", "Eléctrico"]
      fl_random = Faker::Number.between(from: 1, to: 4)
      publication.fuel_type = fl_array[fl_random]

      ac_random = Faker::Number.between(from: 0, to: 1)
      ac_array = [true, false]
      publication.with_ac = ac_array[ac_random]

      uniq_random = Faker::Number.between(from: 0, to: 1)
      uniq_array = [true, false]
      publication.uniq_owner = uniq_array[ac_random]

      #CREAR PUBLICACION
      publication.save validate: false
    elsif j <= 10
      #INMUEBLES
      publication.title = "Inmuble en #{Faker::Space.star}"
      publication.subject = Publication::INMUEBLES
      publication.price = Faker::Number.between(from: 20000000, to: 500000000)

      aux_subcategories = subcategories.where({categories: {subject: publication.subject}})
      offset = rand(aux_subcategories.count)
      publication.subcategory_id = aux_subcategories.offset(offset).first.id

      publication.total_mtr = Faker::Number.between(from: 1000, to: 10000)
      publication.builded_mtr = Faker::Number.between(from: 60, to: 200)
      publication.estrato = Faker::Number.between(from: 1, to: 6)
      publication.admin_price = Faker::Number.between(from: 200000, to: 500000)
      publication.characteristics = Faker::Lorem.paragraphs(number: 2).join
      publication.number = Faker::Lorem.characters(7)
      publication.kind = Faker::Number.between(from: 1, to: 2)
      publication.mode = Faker::Number.between(from: 1, to: 2)
      #FALTAN CAMPOS

      #CREAR PUBLICACION
      publication.save validate: false
    elsif j <= 13
      #SERVICIOS
      publication.title = Faker::Job.field
      publication.subject = Publication::SERVICIOS
      publication.price = Faker::Number.between(from: 100000, to: 2000000)

      aux_subcategories = subcategories.where({categories: {subject: publication.subject}})
      offset = rand(aux_subcategories.count)
      publication.subcategory_id = aux_subcategories.offset(offset).first.id

      ta_random = Faker::Number.between(from: 0, to: 1)
      ta_array = [true, false]
      publication.to_agree = ta_array[ta_random]

      wta_random = Faker::Number.between(from: 0, to: 1)
      wta_array = [true, false]
      publication.willing_to_move = wta_array[wta_random]


      # CREAR PUBLICACION
      publication.save validate: false
    elsif j <= 25
      #ANIMALES
      publication.title = "#{Faker::Games::ElderScrolls.creature} de #{Faker::Games::ElderScrolls.region}"
      publication.subject = Publication::ANIMALES
      publication.price = Faker::Number.between(from: 500000, to:  5000000)
      publication.units = Faker::Number.between(from: 1, to:  100)

      aux_subcategories = subcategories.where({categories: {subject: publication.subject}})
      offset = rand(aux_subcategories.count)
      publication.subcategory_id = aux_subcategories.offset(offset).first.id

      fa_random = Faker::Number.between(from: 0, to: 1)
      fa_array = [true, false]
      publication.for_adoption = fa_array[fa_random]

      lot_random = Faker::Number.between(from: 0, to: 1)
      lot_array = [true, false]
      publication.is_lot = lot_array[lot_random]
      publication.lot_size = Faker::Number.between(from: 10, to: 40)

      publication.age = Faker::Number.between(from: 1, to: 10)

      #CREAR PUBLICACION
      publication.save validate: false
    else
      #PRODUCTOS
      publication.title = "#{Faker::Commerce.material} #{Faker::Beer.name} de #{Faker::TvShows::GameOfThrones.city}"
      publication.subject = Publication::PRODUCTOS
      publication.price = Faker::Number.between(from: 10000, to: 900000)
      publication.units = Faker::Number.between(from: 1, to: 50)

      aux_subcategories = subcategories.where({categories: {subject: publication.subject}})
      offset = rand(aux_subcategories.count)
      publication.subcategory_id = aux_subcategories.offset(offset).first.id

      publication.kind = Faker::Number.between(from: 1, to: 2)

      wa_random = Faker::Number.between(from: 0, to: 1)
      wa_array = [true, false]
      publication.warranty = wa_array[wa_random]

      if publication.warranty == true
        publication.warranty_description = Faker::Lorem.paragraphs(number: 2).join
      end

      #CREAR PUBLICACION
      publication.save validate: false
    end
    puts "PUBLICACION: #{publication.title}"
    unless publication.id.nil?
      # (1..3).each do |k|
      image_clone = PublicationImage.new
      image_clone.publication_id = publication.id
      image_clone.remote_source_url = Faker::Avatar.image
      unless image_clone.save
        puts "ERROR: #{image.errors.full_messages}"
      end
      # end
    end
  end
end
