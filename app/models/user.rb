class User < ApplicationRecord

  acts_as_token_authenticatable

  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable, :lockable #, :confirmable

  belongs_to :city
  belongs_to :level
  belongs_to :country


  has_many :user_visits
  has_many :visited_publications, through: :user_visits, source: :publication

  has_many :notifications
  has_many :purchases
  has_many :feedbacks
  has_many :publications
  has_many :user_authentications
  has_many :devices

  has_many :publication_questions

  has_many :favorites
  has_many :favorites_publications, through: :favorites, source: :publication

  has_many :user_achivements
  has_many :achivements, through: :user_achivements

  has_many :user_contacts
  has_many :interested_contacts, class_name: "UserContact", foreign_key: "interested_id"

  has_many :consult_questions
  has_many :consult_answers

  has_many :user_consult_question_visits
  has_many :user_consult_question_votes
  has_many :user_consult_answer_votes

  has_many :user_interests
  has_many :interests, through: :user_interests

  mount_uploader :image, LogoUploader

  #validates :image, file_size: { less_than_or_equal_to: 2.megabytes },
  #file_content_type: { allow: ['image/jpeg', 'image/png'] }

  after_create :fix_achivements
  before_save :camelcasing

  def camelcasing
    self.name = self.name.titleize unless self.name.nil?
    self.profession = self.profession.titleize unless self.profession.nil?
    self.address = self.address.titleize unless self.address.nil?
    self.main_activity = self.main_activity.capitalize unless self.main_activity.nil?
  end

  def fix_achivements
    if self.level.nil?
      level = Level.where(number: 1).last
      self.update_attribute :level_id, level.id
      self.update_attribute :current_points, 0
      # achivement = Achivement.find_by_id(1)
      Notification.create_with_achivement(1, self, self)
      # self.user_achivements.create achivement_id: achivement.id, points: achivement.points
    end
  end

  def self.consult_managers
    where consult_manager: true
  end

  # def self.create_from_omniauth(params)
  #   attributes = {
  #     email: params['info']['email'],
  #     password: Devise.friendly_token
  #   }
  #
  #   create(attributes)
  # end

  def get_profile_image
    unless self.image.url.nil?
      self.image.square.url
    else
      "/images/no-profile-image.jpg"
    end
  end

  def confirmed?
    true
  end

  def achivement_acomplished(achivement)
    !self.achivements.find_by_id(achivement.id).nil?
  end

  def achivement_acomplished_by_id(achivement_id)
    !self.achivements.find_by_id(achivement_id).nil?
  end

  def get_reputation_data
    purchases = Purchase.by_seller self
    count = purchases.count
    count = 1 if purchases.count == 0

    purchases_buyer = purchases
    count_buyer = purchases_buyer.count
    count_buyer = 1 if purchases_buyer.count == 0
    {percent: purchases.positives.count*100/count, sells_count: purchases.count, percent_buyer: purchases_buyer.positives.count*100/count, buys_count: purchases_buyer.count}
  end

  def already_contacted(publication)
    !self.purchases.find_by_publication_id(publication.id).nil?
  end

  def completed?
    get_profile_percent >= 100
  end

  def get_profile_percent
    value = 0
    unless email.nil?
      value += 10
    end
    unless name.nil?
      value += 20
    end
    unless profession.nil?
      value += 10
    end
    unless birthdate.nil?
      value += 10
    end
    unless phone.nil?
      value += 20
    end
    unless city.nil?
      value += 20
    end
    unless address.nil?
      value += 10
    end
    value
  end

  def self.profile_complete
    where("(name IS NOT NULL AND name != ?) AND (profession IS NOT NULL AND profession != ?) AND (phone IS NOT NULL AND phone != ?) AND (city_id IS NOT NULL)", "", "", "")
  end

  def get_voted_question(question)
    self.user_consult_question_votes.where(consult_question_id: question.id).first
  end

  def has_voted_question?(question)
    self.user_consult_question_votes.where(consult_question_id: question.id).count > 0
  end

  def has_voted_question_as?(question)
    vote = self.user_consult_question_votes.where(consult_question_id: question.id).first
    unless vote.nil?
      vote.value_name
    else
      "Error: No has calificado la pregunta"
    end
  end

  def has_voted_question_as_value?(question, value)
    self.user_consult_question_votes.where(consult_question_id: question.id, points: value).count > 0
  end

  def get_voted_answer(answer)
    self.user_consult_answer_votes.where(consult_answer_id: answer.id).first
  end

  def has_voted_answer?(answer)
    self.user_consult_answer_votes.where(consult_answer_id: answer.id).count > 0
  end

  def has_voted_answer_as?(answer)
    vote = self.user_consult_answer_votes.where(consult_answer_id: answer.id).first
    unless vote.nil?
      vote.value_name
    else
      "Error: No has calificado la pregunta"
    end
  end

  def has_voted_answer_as_value?(answer, value)
    self.user_consult_answer_votes.where(consult_answer_id: answer.id, points: value).count > 0
  end

  def self.finish_profile_notification
    User.all.each do |user|
      if user.achivement_acomplished_by_id(7) == false
        notifications = user.notifications.where(text: "Completa tu perfil y has parte de la red.")
        if notifications.count < 3 && notifications.where("created_at >= ?", Time.now - 1.week).count == 0
          Notification.create_and_send(Notification::FINISH_YOUR_PROFILE, user, user)
        end
      end
    end
  end

  def self.daily_push(country_id)
    country_name = "El Mundo"

    if country_id.nil? || country_id == 1
      @users_ids = User.where(country_id: [nil, country_id]).pluck(:id)
    else
      @users_ids = User.where(country_id: country_id).pluck(:id)
    end

    unless country_id.nil?
      country = Country.find country_id
      country_name = country.name
    end

    (1..@users_ids.count).step(200) do |i|
      DailyPusherWorker.perform_async(@users_ids[i..(i+199)], country_name)
    end
  end

  def self.periodic_updates(period)
    posts = Post.includes({subcategories: :category}).all
    publications = Publication.includes([{subcategory: :category}, :user]).all

    wday = (Date.today.wday + 1)

    if period.nil?
      users = User.includes(:interests).where(receive_email_ads: true)
    else
      users = User.page(wday).per((User.count/7).to_i)
    end

    users.where(receive_email_ads: true).each do |user|
      if user.interests.count > 0
        categories_ids = []

        user.interests.each do |interest|
          categories_ids = categories_ids | interest.categories.select(:id).pluck(:id)
        end

        posts_to_send = posts.where({subcategories: {category_id: categories_ids}}).order(created_at: :desc, views_count: :desc).references({subcategories: :category})
        publications_to_send = publications.where("publications.status = ? AND publications.start_date <= ?", 1, Date.today).where({subcategories: {category_id: categories_ids}}).order(created_at: :desc).references([{subcategory: :category}, :user])
        unless user.country.nil?
          posts_to_send = posts_to_send.where("country_id = ? OR scope_location = ?", user.country_id, "Internacional")
          publications_to_send = publications_to_send.where("users.country_id = ?", user.country_id)
        end

        if posts_to_send.count > 0 || publications_to_send.count > 0
          Notification.create_and_send(Notification::PERIODIC_UPDATES, {posts: posts_to_send.first(3), publications: publications_to_send.first(3)}, user)
        end
      end
    end
  end

  def self.terms_update(only)

    wday = (Date.today.wday + 1)

    users = User.page(wday).per((User.count/7).to_i)

    unless only.blank?
      users = User.where email: only
    end

    terms_version = TermsVersion.last

    users.each do |user|
      if user.terms_version_accepted != terms_version.version
        user.update_attribute :terms_version_accepted, terms_version.version
        user.update_attribute :terms_accepted, true
        user.update_attribute :last_terms_notified, true
        user.update_attribute :last_terms_notified_at, Time.now

        Notification.create_and_send(Notification::TERMS_UPDATES, terms_version, user)
      end
    end
  end

  #Devise
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  def self.actives
    where.not(deleted_at: nil)
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

end
