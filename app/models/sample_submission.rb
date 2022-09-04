class SampleSubmission < ApplicationRecord

  has_attached_file :sample, :styles => { },:path => ":rails_root/public/images/:basename.:extension"
  validates :name,:age,:gender, presence: true
  validates :sample, attachment_presence: true
  validates_with AttachmentPresenceValidator, attributes: :sample
  validates_attachment_content_type :sample, :content_type => ["image/jpg", "image/jpeg"]

end
