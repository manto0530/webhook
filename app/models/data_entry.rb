class DataEntry < ApplicationRecord
  validates :name, presence: true
  validates :data, presence: true
end
