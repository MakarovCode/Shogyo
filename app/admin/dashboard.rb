ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  # content title: proc{ I18n.t("active_admin.dashboard") } do
  #   div class: "blank_slate_container", id: "dashboard_default_message" do
  #     javascript_include_tag "https://www.google.com/jsapi", "chartkick"
  #   end
  #
  #   columns do
  #     column do
  #       panel "Visitas Diarias" do
  #         area_chart Visit.where(started_at: (Date.today - 1.month)..Date.today+1.days).group_by_day(:started_at).count
  #       end
  #     end
  #   end
  #
  #   columns do
  #     column do
  #       panel "Registros Diarios" do
  #         area_chart User.where(created_at: (Date.today - 1.month)..Date.today+1.days).group_by_day(:created_at).count
  #       end
  #     end
  #   end
  #
  #   columns do
  #     column do
  #       panel "Publicaciones Diarias" do
  #         area_chart Publication.where(created_at: (Date.today - 1.month)..Date.today+1.days).group_by_day(:created_at).count
  #       end
  #     end
  #   end
  #
  #   columns do
  #     column do
  #       panel "Profesiones" do
  #         professions = ["Ganadería:ganade,vacun", "Zootecnista:zoo,anim", "Caficultor/Café:cafe,cafi", "Técnico:tec,inge", "Veterinaria y Medicina:doc,vet,medi", "Docente:maes,docen", "Agricultura/Cultivos:agri,culti", "Administrador:admin,gesti", "Reproducción/Crianzarepro:cria,porci,pisc", "Productores:lech,carn", "Estudiante:estudi", "Comercio:comer,comp", "Biología:bio,gene", "Maquinaria/Equipamiento:maqui,equi"]
  #         @users = User.all
  #         theusers = []
  #         professions.each_with_index do |profession, i|
  #           words = profession.split(":")
  #           theusers.push([words[0], [], 0])
  #           words[1].split(",").each do |word|
  #
  #             @users.where("UNACCENT(LOWER(profession)) ILIKE '%#{word}%' OR UNACCENT(LOWER(main_activity)) ILIKE '%#{word}%'").each do |u|
  #               unless theusers[i][1].include?(u)
  #                 theusers[i][1].push(u)
  #                 theusers[i][2] += 1
  #               end
  #             end
  #
  #           end
  #         end
  #         theusers.each do |user|
  #           user.delete_at(1)
  #         end
  #         bar_chart theusers
  #       end
  #     end
  #   end
  #
  #   # columns do
  #   #     column do
  #   #         panel "Dispositivos" do
  #   #             pie_chart Visit.group(:device_type).count
  #   #         end
  #   #     end
  #   #
  #   #     column do
  #   #         panel "Dominio referido" do
  #   #             pie_chart Visit.group(:search_keyword).count
  #   #         end
  #   #     end
  #   # end
  #   #
  #   # columns do
  #   #   column do
  #   #       panel "Palabras de búsquedas" do
  #   #           bar_chart Visit.group(:search_keyword).count
  #   #       end
  #   #   end
  #   # end
  #
  #   columns do
  #     column do
  #       panel "Intereses" do
  #         bar_chart @users.includes(:interests).group("interests.name").references(:interests).count
  #       end
  #     end
  #   end
  #   #
  #   # columns do
  #   #     column do
  #   #         panel "Visitas por país" do
  #   #             geo_chart Visit.where(started_at: (Date.today - 1.month)..Date.today+1.days).group(:country).count
  #   #         end
  #   #     end
  #   # end
  #   #
  #   # columns do
  #   #     column do
  #   #         panel "Visitas por región" do
  #   #             pie_chart Visit.where(started_at: (Date.today - 1.month)..Date.today+1.days).group(:region).count
  #   #         end
  #   #     end
  #   #
  #   #     column do
  #   #         panel "Visitas por ciudad" do
  #   #             pie_chart Visit.where(started_at: (Date.today - 1.month)..Date.today+1.days).group(:city).count
  #   #         end
  #   #     end
  #   # end
  # end
end
