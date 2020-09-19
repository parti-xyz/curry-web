class ArchiveCategory < ApplicationRecord
  belongs_to :archive
  belongs_to :parent, class_name: 'ArchiveCategory', optional: true
  has_many :children, class_name: 'ArchiveCategory', dependent: :destroy, foreign_key: :parent_id
  has_many :documents, class_name: 'ArchiveDocument', dependent: :nullify, primary_key: :slug, foreign_key: :category_slug

  accepts_nested_attributes_for :children, allow_destroy: true

  validates :slug, uniqueness: { scope: [:archive_id] }, presence: true
  validates :name, presence: true
end
