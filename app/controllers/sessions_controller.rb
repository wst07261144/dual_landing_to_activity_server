class SessionsController < ApplicationController

  require 'rest_client'
  skip_before_filter :verify_authenticity_token, :process_clients_login, :process_synchronous

  def login
    if session[:current_user_id]!=nil
      @user = User.find(session[:current_user_id])
      sign_up(@user)
    end
  end

  def create
    p "----------code---------#{params[:code]}-------------------"
    @user = User.find_by(name: params[:session][:name])
    VarifyCode.find_or_create_by :code=>params[:code],:user_id=>@user.id
    if @user && @user.authenticate(params[:session][:password])
      sign_in(@user)
    else
      @err = 'true'
      render '/sessions/login'
    end
  end

  def check_is_login
    respond_to do |form|
      form.json {render json:'aaa'}
    end
  end

  def logout
    session[:current_user_id] = nil
    session[:admin?] = nil
    redirect_to root_path
  end

  def process_clients_login
    @user = User.find_by(name: params[:account])
    respond_to do |format|
    if @user && @user.authenticate( params[:key])
      format.json { render json: 'true' }
    else
      format.json { render json: 'false' }
     end
    end
  end

  def process_synchronous
    Activity.synchronous_activities(params)
    SignUp.synchronous_sign_ups(params)
    Bid.synchronous_bids(params)
    BidList.synchronous_bidlists(params)
    Winner.synchronous_winners(params)
    respond_to do |format|
      if check_synchronous_success(params)=='true'
        format.json { render json: 'true' }
      else
        format.json { render json: 'false' }
      end
    end
  end

  def save_activity
    Activity.update_activity(params)
    redirect_to '/shows/show'
  end

  def save_sign_up
    sign_up= SignUp.where(:activity_id => params[:update_sign_up][:activity_id])
    if  sign_up.empty?||SignUp.where(:activity_id =>params[:update_sign_up][:activity_id]).last[:phone]!=params[:update_sign_up][:phone]
      SignUp.update_sign_up(params)
    end
    redirect_to '/shows/show'
  end

  def save_bid
    if params.length!=2
      if params[:update_data][:bid][:phone]!=nil
        Bid.update_bid(params)
      end
      BidList.update_bidlist(params)
      Winner.update_winner(params)
    end
    redirect_to user_index_path(id: User.find(session[:current_user_id]).name)
  end

  def sign_up(user)
    if user.name=='admin'
      return redirect_to '/manage_index'
    end
    redirect_to  '/shows/show'
  end

  def sign_in(user)
    if user.name!="admin"
      session[:current_user_id] = user.id
      redirect_to '/shows/show'
      return
    else
      session[:current_user_id] = user.id
      redirect_to '/manage_index'
    end
  end

  def check_synchronous_success(params)
    current_user = params[:sync_data][:user]
    if params[:sync_data][:activities].length == Activity.all.where(:user=>current_user).length&&
        params[:sync_data][:sign_ups].length == SignUp.all.where(:user=>current_user).length&&
        params[:sync_data][:bids].length == Bid.all.where(:user=>current_user).length&&
        params[:sync_data][:bid_lists].length == BidList.all.where(:user=>current_user).length&&
        params[:sync_data][:winners].length == Winner.all.where(:user=>current_user).length
      return 'true'
    end
  end
end