class Purchase < ApplicationRecord
  belongs_to :publication
  belongs_to :user
  belongs_to :city

  validates :consult, presence: true, unless: Proc.new { |a| (a.publication.subject == Publication::PRODUCTOS) }
  validates :review, :recommended, :received, presence: true, if: Proc.new { |a| (a.reviewed == true) }
  validates :buyer_review, :buyer_recommended, :delivered, presence: true, if: Proc.new { |a| (a.buyer_reviewed == true) }

  def self.by_seller(user)
    Purchase.includes(:publication).where({publications: {user_id: user.id}}).references(:publication)
  end

  def self.positives
    where recommended: 1
  end

  def self.negatives
    where recommended: -1
  end

  def self.neutrals
    where recommended: 0
  end

  def self.seller_not_rated
    where reviewed: [nil, false]
  end

  def self.seller_rated
    where reviewed: true
  end

  def self.buyer_not_rated(user)
    by_seller(user).where(buyer_reviewed: [nil, false])
  end

  def self.buyer_rated(user)
    by_seller(user).where(buyer_reviewed: true)
  end

  def self.reminders_notifications
    seller_not_rated.each do |purchase|
      if Date.today.at_beginning_of_day >= purchase.created_at + 7.days &&  Date.today.at_end_of_day <= purchase.created_at + 7.days
        Notification.create_and_send(Notification::SELLER_QUALIFICATION_REMINDER, purchase, purchase.user)
      end
    end
    where(buyer_reviewed: [nil, false]).each do |purchase|
      if Date.today.at_beginning_of_day >= purchase.created_at + 7.days &&  Date.today.at_end_of_day <= purchase.created_at + 7.days
        Notification.create_and_send(Notification::BUYER_QUALIFICATION_REMINDER, purchase, purchase.publication.user)
      end
    end
  end

end
