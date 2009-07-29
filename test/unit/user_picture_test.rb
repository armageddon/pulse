require 'test_helper'

class UserPictureTest < ActiveSupport::TestCase
  
  def setup
    super
    UserPicture.attachment_options[:path_prefix] = "test/tmp/user_pictures/"
  end

  test "uploads file" do
    user = User.make
    pic = UserPicture.new(:uploaded_data => upload)
    pic.user = user
    assert pic.valid?
    assert pic.save
    assert File.exists?(pic.full_filename)
  end
  
  test "first upload defaults to icon" do
    user = User.make
    icon = UserPicture.new(:uploaded_data => upload)
    icon.user = user
    assert icon.save
    assert icon.icon
    #
  end
  
  test "upload only has one icon" do
    user = User.make
    pic1 = UserPicture.new(:uploaded_data => upload)
    pic1.user = user
    pic1.save
    assert pic1.icon
    assert UserPicture.count(:conditions => ["user_id = ? AND icon = ?", user.id, true]) == 1
    pic2 = UserPicture.new(:uploaded_data => upload)
    pic2.user = user
    pic2.save
    assert !pic2.icon
    assert UserPicture.count(:conditions => ["user_id = ? AND icon = ?", user.id, true]) == 1
    pic2.icon = true
    assert pic2.save
    assert UserPicture.count(:conditions => ["user_id = ? AND icon = ?", user.id, true]) == 1
    assert !pic1.reload.icon
  end
  
  test "belongs to user" do
    user = User.make
    pic = UserPicture.new(:uploaded_data => upload)
    pic.user_id = user.id
    assert pic.save
    assert_equal pic.user, user
  end
  
  test "requires user" do
    pic = UserPicture.new(:uploaded_data => upload)
    assert !pic.valid?
    assert pic.errors.on(:user_id)
  end
  
  private
  
  def upload(name="hotel_delmano.jpg", mimetype = "image/jpg")
    path = upload_path(name)
    ActionController::TestUploadedFile.new(path, mimetype)
  end
  
  def upload_path(name="hotel_delmano.jpg", mimetype = "image/jpg")
    File.join(RAILS_ROOT, "test/data/#{name}")
  end

end
