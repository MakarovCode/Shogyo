object @users
attributes :id, :name, :profession, :main_activity

child :city do
  attributes :id, :name

  child :department do
    attributes :id, :name

    child :country do
      attributes :id, :name
    end
  end
end
