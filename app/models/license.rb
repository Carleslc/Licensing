class License < ApplicationRecord
  after_create :serialize_key
  belongs_to :product
  has_many :activations, dependent: :destroy

  has_secure_token :key

  validates :name, presence: true

  def reached_limit?
    activations.size >= quantity
  end

  def expired?
    return false if expiration.nil?
    expiration < DateTime.current
  end

  def activate(fingerprint)
    activations.create!(fingerprint: fingerprint) unless reached_limit? || expired?
  end

  def as_json(options = nil)
    super(options.reverse_merge(except: [:id, :license_id, :created_at, :updated_at, :product_id]))
      .merge(product: product.name)
      .reject { |_, v| v.nil? }
  end

  private

  def serialize_key
    serial = key.upcase
    update(key: serial.insert(4, '-').insert(9, '-')
                    .insert(14, '-').insert(19, '-').insert(24, '-'))
  end

end
