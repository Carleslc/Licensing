class Activation < ApplicationRecord
  belongs_to :license

  validates :fingerprint, presence: true

  def as_json(options = nil)
    super(options.reverse_merge(except: [:id, :license_id, :created_at, :updated_at]))
      .merge(activated_at: created_at)
      .merge(license: license.as_json(options))
      .reject { |_, v| v.nil? }
  end
end
