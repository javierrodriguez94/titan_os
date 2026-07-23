class Api::V1::ListsController < ApplicationController
  rescue_from ListContentFetcher::InvalidContentTypeError, with: :render_invalid_content_type

  def show
    result = ListContentFetcher.call(
      list_id: show_params[:id],
      content_type: show_params[:content_type],
      page: show_params[:page],
      per_page: show_params[:per_page]
    )

    render json: ListContentPresenter.new(result)
  end

  private

  def show_params
    params.permit(:id, :content_type, :page, :per_page)
  end

  def render_invalid_content_type(error)
    render_error(error.message, status: :unprocessable_entity)
  end
end
