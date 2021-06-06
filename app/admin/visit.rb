ActiveAdmin.register Visit do

  actions :all, only: [:show]

  menu parent: 'Monetización'

  # controller do
  #   before_action :protected_attributes
  #   def protected_attributes
  #     params.permit!
  #   end
  # end

end
