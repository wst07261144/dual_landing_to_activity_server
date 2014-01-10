class UserController < ApplicationController

  before_action :check_login ,only: [:admin_create]

  def register
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user[:admin]='false'
    if @user.save
      session[:current_user_id]= @user.id
      redirect_to '/shows/show'
    else
      render 'register'
    end
  end

  def reset_key1_check_account
  end

  def reset_key2_check_question
    @question = session[:question]
  end

  def reset_key3_to_reset_key
    @user = User.new
  end

  def handle_reset_key1
    @user=User.find_by_name params[:user][:name]
    if @user
      update_session(@user)
      redirect_to '/reset_key2_check_question'
    else
      @err_msg = 'true'
      render "reset_key1_check_account"
    end
  end

  def handle_reset_key2
    @question = session[:question]
    if session[:answer]==params[:user][:answer]
      redirect_to '/reset_key3_to_reset_key'
    else
      @err_msg='true'
      render "reset_key2_check_question"
    end
  end

  def handle_reset_key3
    User.delete_user(session[:account])
    @user = User.new(get_params(params))
    if @user.save
      redirect_to root_path
    else
      render 'reset_key3_to_reset_key'
    end
  end

  def admin_create
    @user = User.new(user_params)
    @user[:admin]='false'
    if @user.save
      redirect_to '/manage_index'
    else
      render 'register'
    end
  end

  def update_session(user)
    session[:answer]=user.answer
    session[:account]= user.name
    session[:question] = user.question
    session[:password] = user.password_digest
  end

  def get_params(params)
    return {:name => session[:account],:password=>params[:user][:password],
            :password_confirmation=> params[:user][:password_confirmation],
            :question=>session[:question], :answer=>session[:answer],
            :admin=>'false'}
  end

  def is_used
     if VarifyCode.is_used params[:code]
       #user_name = User.find_by(code:params[:code]).name
       #render :text => user_name
       render :text=>'ok'
     else
       render :text => 'error'
     end
  end

  def send_data
    #id= session[:current_user_id]
    #user = User.find(id).name
    #sign_ups = SignUp.all.where(:user=>user).group(:activity_id)
    #bids = Bid.all.where(:user=>user)
    p '--------------------------'
    p session[:current_user_id]
    respond_to do |format|
      #format.json {render :json=>[{name:123,phone:4567},{name:'wer',phone:123456}].to_json}
      format.json {render :json=>[{'name'=>123,'phone'=>4567},{'name'=>'wer','phone'=>123456}].to_json}
    end
  end


  private
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :question, :answer)
  end
end