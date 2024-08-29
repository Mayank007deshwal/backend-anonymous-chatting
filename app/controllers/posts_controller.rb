class PostsController < ApplicationController
  def index
    # posts = Post.all.order(id: :desc)
    post_per_page = 3
    page_number = params[:page].to_i || 1
    offset = post_per_page * (page_number - 1)
    posts = Post.order(id: :desc).offset(offset).limit(post_per_page)

    total_posts = Post.count
    # is_more_posts_available = total_posts - ( offset + posts.count)
    is_more_posts_available = offset + posts.size < total_posts


  # render json: { posts: posts, has_more: is_more_posts_available }

  # Include image URL in each post only if image is present
  posts_with_images = posts.map do |post|
    post_data = post.as_json
    if post.image.attached?
    # post_data[:image_url] = post.image.attached? ? url_for(post.image) : nil
    # post_data[:image_type] = post.image.attached? ? post.image.content_type : nil
    post_data[:image_url] = url_for(post.image)
    post_data[:image_type] = post.image.content_type
    end
    post_data
  end

  render json: { posts: posts_with_images, has_more: is_more_posts_available }

  end

  def create
    post = Post.new(post_params)

    if post.save
      post_data = post.as_json
      post_data[:image_url] = post.image.attached? ? url_for(post.image) : nil
      post_data[:image_type] = post.image.attached? ? post.image.content_type : nil
      render json: post_data
    else
      render josn: {error: "unable to create post" }
    end
  end

  def update
    post = Post.find(params[:id])

    if post.update(post_params)
      post_data = post.as_json
      post_data[:image_url] = post.image.attached? ? url_for(post.image) : nil
      post_data[:image_type] = post.image.attached? ? post.image.content_type : nil
      render json: post_data
    else
      render json: {errors: post.errorrs.full_messages}
    end
  end

  def destroy
    post = Post.find(params[:id])

    post.destroy
    render json: { msg: "post deleted success" }
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :image)
  end
end

