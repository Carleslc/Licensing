class LicenseController < ApplicationController
  before_action :fetch_product
  before_action :fetch_license, except: :trial
  before_action :fetch_device, except: :uses

  # GET /products/:name/licenses/:key?fingerprint=#[&lang=(en|es)]
  def validate
    activation = @license.activations.find_by_fingerprint(@device)
    if activation
      render json: activation, status: :ok
    else
      activate
    end
  end

  # GET /products/:name/licenses/:key/uses
  def uses
    render json: @license.activations, status: :ok
  end

  # GET /products/:name/trial?fingerprint=#[&type=(short|long)&lang=(en|es)]
  def trial
    trial_name = 'Trial-' + @device
    if @product.licenses.exists?(name: trial_name)
      render json: message('trial_limit'), status: :unauthorized
      return
    end
    duration = params[:type] || 'short'
    days = duration == 'short' ? 7 : 30
    license = @license.create!(name: trial_name, expiration: Date.current + days)
    render json: license, status: :ok
  end

  private

  def activate
    if @license.reached_limit?
      render json: message('limit_reached', @license.quantity.to_s), status: :unauthorized
    else
      activation = @license.activate(@device)
      render json: activation, status: :ok
    end
  end

  def fetch_product
    @product = Product.find_by_name(params[:name])
    render json: message('invalid_product'), status: :unauthorized unless @product
  end

  def fetch_license
    @license = @product.licenses.find_by_key(params[:key])
    if @license.nil?
      render json: message('invalid_license'), status: :unauthorized
    elsif @license.expired?
      render json: message('expired', @license.expiration.to_s), status: :unauthorized
    end
  end

  def fetch_device
    params.require(:fingerprint)
    @device = params[:fingerprint]
  end

  def message(message_id, substitution = nil)
    message = t(message_id)
    message.gsub('#', substitution) if substitution
    { message: message }
  end

end
