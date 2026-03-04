class CreatorsController < ApplicationController
  def index
    @creators = Creator.ordered_by_name.with_content_count
    @creators = @creators.search_by_name(params[:search]) if params[:search].present?
    @creators = @creators.page(params[:page]).per(12)

    @stats = {
      total_creators: Creator.count,
      total_contents: Content.count,
      provider_counts: Content.group(:social_media_provider).count
    }
  end

  def show
    @creator = Creator.find(params[:id])
    @contents = @creator.contents.order(created_at: :desc)
    @contents = @contents.where(social_media_provider: params[:provider]) if params[:provider].present?
    @contents = @contents.page(params[:page]).per(10)
  end
end
