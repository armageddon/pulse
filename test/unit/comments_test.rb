require 'test_helper' 
class CommentsTest < ActiveSupport::TestCase 
  
  
  def test_add_comment
        @francois = User.find(1);
        @comment = PlaceComment.new
        @comment.user_id = @francois.id
        @comment.comment_text= "First place comment"
        
        start_count = PlaceComment.count
        @comment.save
        end_count = PlaceComment.count

        assert_not_equal (start_count ,end_count ,"should be unequal")
    
  end
  
end
