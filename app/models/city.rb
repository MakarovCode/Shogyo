class City < ApplicationRecord
  belongs_to :department
  has_many :users

  def full_name
    unless self.department.nil?
      unless self.department.country.nil?
        "#{self.name} - #{self.department.name} - #{self.department.country.name}"
      else
        "#{self.name} - #{self.department.name}"
      end
    else
      "#{self.name}"
    end
  end

  def self.by_term(term)
    where("cities.name ILIKE '%#{term}%'").order("cities.name asc")
  end
end
