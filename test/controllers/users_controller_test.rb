require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
	
	def setup
		@user = users(:michael)
		@other_user = users(:archer)
	end


  	test "should get new" do
    	get signup_path
   	 	assert_response :success
  	end

  	test "should redirect edit when not logged in" do
  		get edit_user_path(@user)
  		assert_not flash.empty?
  		assert_redirected_to login_url
  	end

  	test "should redirect update when not logged in" do
  		patch user_path(@user), params: { user: { name: @user.name, 
  			email: @user.email} }
  		assert_not flash.empty?
  		assert_redirected_to login_url
  	end

  	test "should redirect edit when logged in as wrong user" do
  		log_in_as(@other_user)
  		get edit_user_path(@user)
  		assert flash.empty?
  		assert_redirected_to root_url
  	end

  	test "should redirect index when not logged in" do
  		get users_path
  		assert_redirected_to login_url
  	end

  	test "should redirect update when logged in as wrong user" do
  		log_in_as(@other_user)
  		patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
  		assert flash.empty?
  		assert_redirected_to root_url
  	end

  	test "should not allow the admin attribute to be edited via the web" do
  		log_in_as(@other_user)
  		assert_not @other_user.admin?
  		patch user_path(@other_user), params: {
  					user: {
  						password: @other_user.password,
  						password_confirmation: @other_user.password_confirmation,
  						admin: true
  					}
  		}
  		assert_not @other_user.reload.admin?
  	end

  	test "should redirect destroy when not logged in" do
  		assert_no_difference 'User.count' do
  			delete user_path(@user)
  		end
  		assert_redirected_to login_url
  	end

  	test "should redirect destroy when logged in as non-admin" do
  		log_in_as(@other_user)
  		assert_no_difference 'User.count' do
  			delete user_path(@user)
  		end
  		assert_redirected_to root_url
  	end

  	test "only show profiles of activated users" do
  		log_in_as(@user)
  		get users_path
  		assert_template 'users/index'
  		assert_select 'div.pagination'
  		my_test_users = assigns(:users)
  		x = my_test_users.total_pages
  		for i in (1..x)
  			page_of_users = User.paginate(page: i)
  			page_of_users.each do |user|
    			assert_equal true, user.activated?
  			end
		end
	end
end
