class BlogController < ApplicationController
  def index
    @posts = Railspress::Post.published
                             .includes(:category, :tags)
                             .ordered
                             .page(params[:page])
                             # .per(10)
  end

  def show
    @post = Railspress::Post.published.find_by!(slug: params[:slug])
    @related_posts = @post.category&.posts
                          &.published
                          &.where.not(id: @post.id)
                          &.ordered
                          &.limit(3) || []
  end

  def category
    @category = Railspress::Category.find_by!(slug: params[:slug])
    @posts = @category.posts
                      .published
                      .includes(:tags)
                      .ordered
                      .page(params[:page])
                      .per(10)
  end

  def tag
    @tag = Railspress::Tag.find_by!(slug: params[:slug])
    @posts = @tag.posts
                 .published
                 .includes(:category)
                 .ordered
                 .page(params[:page])
                 .per(10)
  end

  def search
    @query = params[:q].to_s.strip
    @posts = if @query.present?
               Railspress::Post.published
                               .where("title ILIKE ? OR slug ILIKE ?", "%#{@query}%", "%#{@query}%")
                               .includes(:category, :tags)
                               .ordered
                               .page(params[:page])
                               .per(10)
             else
               Railspress::Post.none
             end
  end
end
