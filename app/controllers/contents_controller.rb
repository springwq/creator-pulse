class ContentsController < ApplicationController
  before_action :set_creator
  before_action :set_content, only: [ :edit, :update, :destroy ]

  def new
    @content = @creator.contents.build
  end

  def create
    result = Contents::Create.new(@creator.id, content_params).call

    if result.success?
      redirect_to creator_path(@creator), notice: "Content was successfully created."
    else
      @content = @creator.contents.build(content_params)
      result.errors.each do |field, messages|
        messages.each { |msg| @content.errors.add(field, msg) }
      end
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @content.update(content_params)
      redirect_to creator_path(@creator), notice: "Content was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @content.destroy
    redirect_to creator_path(@creator), notice: "Content was successfully deleted."
  end

  private

  def set_creator
    @creator = Creator.find(params[:creator_id])
  end

  def set_content
    @content = @creator.contents.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:title, :social_media_url, :social_media_provider)
  end
end
