ActiveAdmin.register_page "Log" do

  menu priority: 1, label: "Log"

  # Here is an example of a simple dashboard with columns and panels.
  #
  content title: "Log" do
    columns do
      column do
        panel "Logs recientes" do
          if Rails.env == "production"
            IO.readlines("/home/rails/agroneto/current/log/production.log").last(5000).reverse
          else
            IO.readlines("/Users/simoncorrea/Development/MrQuick/log/development.log").last(5000).reverse
          end
        end
      end
    end # content
  end # content
end
