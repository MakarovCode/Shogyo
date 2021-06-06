class Blog::PostsController < ApplicationController

  before_action :load_data

  def index
    page = params[:page]
    @posts = Post.actives.smarth_search params[:tag], params[:category], params[:subcategory]
    if page.nil?
      page = 1
    end
    @posts = @posts.page(page).per(10)
  end

  def show
    @post = Post.friendly.find params[:id]
    @post.update_attribute :views_count, @post.views_count + 1
    @related = Post.includes([:tags, :subcategories]).actives.where({tags: {id: @post.tags.pluck(:id)}, subcategories: {id: @post.subcategories.pluck(:id)}}).where("posts.id != ?", @post.id).order("views_count DESC").references([:tags, :subcategories]).first(3)
    if @related.empty?
      @related = Post.where("id != ?", @post.id).order("views_count DESC").first(3)
    end
    if @post.created_at < "2017-07-06".to_date
      begin
        if Rails.env.development?
          @post.image.recreate_versions!(:original)
          @post.save!
        else
          @post.image.cache_stored_file!
          @post.image.retrieve_from_cache!(@post.image.cache_name)
          @post.image.recreate_versions!(:original)
          @post.save!
        end
      rescue => e
        puts  "ERROR: YourModel: #{ym.id} -> #{e.to_s}"
      end
    end
    if @post.subcategories.count > 0
      @subtitle = @post.subcategories.first.category.name
    end
  end

  private

  def load_data
    @categories = Category.for_news
    @tags = Tag.all
    @subtitle = "Noticias"
  end

end
