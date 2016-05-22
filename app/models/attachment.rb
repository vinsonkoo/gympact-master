class Attachment < ActiveRecord::Base
  belongs_to    :pact
  mount_uploader :attachment, AttachmentUploader
  validates     :pact, presence: true
end
