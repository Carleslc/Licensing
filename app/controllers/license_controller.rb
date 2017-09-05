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

  # GET /products/:name/trial?fingerprint=#[&type=(demo|short|long)&lang=(en|es)]
  def trial
    trial_name = 'Trial-' + @device
    activated = @product.licenses.find_by_name(trial_name)
    if activated
      if activated.expired?
        render json: message('trial_limit'), status: :unauthorized
      else
        render json: activated.activations.first, status: :ok
      end
      return
    end
    @license = @product.licenses.create!(name: trial_name, expiration: DateTime.current + fetch_days)
    activate
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
      render json: message('expired').merge(expiration: @license.expiration), status: :unauthorized
    end
  end

  def fetch_device
    params.require(:fingerprint)
    @device = params[:fingerprint]
  end

  def fetch_days
    duration = params[:type] || 'short'
    if duration == 'demo'
      3
    elsif duration == 'short'
      7
    else
      30
    end
  end

  def message(message_id, substitution = nil)
    message = t(message_id)
    message = message.gsub('#', substitution) if substitution
    { message: message }
  end

end
