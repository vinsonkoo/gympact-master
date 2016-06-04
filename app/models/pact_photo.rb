class PactPhoto < ActiveRecord::Base

  belongs_to :pact
  mount_uploader :photo, PhotoUploader
  
end
