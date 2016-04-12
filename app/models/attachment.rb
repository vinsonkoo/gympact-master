class Attachment < ActiveRecord::Base
  # mount_uploader :attachment, AttachmentUploader
  belongs_to    :pact
  validates     :pact, presence: true
end
