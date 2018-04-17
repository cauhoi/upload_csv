class UsersController < ApplicationController

  def index
    @users = User.all.includes(:company)
  end

  def create
  end

  def new
  end

  def destroy
    @id = user.id
    user.destroy
    respond_to do |format|
      format.js {}
    end
  end

  def remove_all
    User.delete_all
    redirect_to users_path
  end

  def show
  end

  def bulk_upload

  end

  def upload
    uploaded_file = params[:user_csv]
    if uploaded_file.nil?
      flash[:warning] = "Please select a csv file"
      redirect_to users_bulk_upload_path and return
    end
    arr = load_from_csv(uploaded_file)
    errors = arr.map do |row|
      User.create_user_from_hash(row)
    end
    errors.compact!
   if errors.present?
     if errors.length > 5
       error_message = errors.take(5).map {|e| CGI::escapeHTML(e)}.join('</br>')
       flash[:error] = "#{error_message} <br>There are more than 5 errors when importing users. Please see the log for details".html_safe
     else
       flash[:error] = errors.map {|e| CGI::escapeHTML(e)}.join('</br>').html_safe
     end
     redirect_to users_bulk_upload_path
   else
     flash[:success] = "Users were successfully imported"
     redirect_to users_bulk_upload_path
   end



  end

private
  def user
      @user||= User.find_by(id: params[:id])
  end


end
