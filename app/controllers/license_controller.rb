class LicenseController < ApplicationController
  before_action :fetch_product, :fetch_license
  before_action :fetch_device, only: :validate

  # GET /products/:name/licenses/:key?fingerprint=#[&lang=(en|es)]
  def validate
    activation = @license.activations.find_by_fingerprint(@device)
    if activation
      render json: activation, status: :ok
    else
      activate
    end
  end

  # GET /products/:name/licenses/:key[?lang=(en|es)]/uses
  def uses
    render json: @license.activations, status: :ok
  end

  private

  def activate
    if @license.reached_limit?
      render json: { message: t('limit_reached').gsub('#', @license.quantity.to_s) }, status: :unauthorized
    else
      activation = @license.activate(@device)
      render json: activation, status: :ok
    end
  end

  def fetch_product
    @product = Product.find_by_name(params[:name])
    render json: { message: t('invalid_product') }, status: :unauthorized unless @product
  end

  def fetch_license
    @license = @product.licenses.find_by_key(params[:key])
    render json: { message: t('invalid_license') }, status: :unauthorized unless @license
  end

  def fetch_device
    params.require(:fingerprint)
    @device = params[:fingerprint]
  end

end
