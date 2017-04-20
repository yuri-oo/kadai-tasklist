class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def index
    @user = current_user
    @tasks = @user.tasks.order('created_at DESC').page(params[:page])
  end
  
  def show
    @task = Task.find(params[:id])
    @task.user_id = current_user.id
     
    
  end
  
  def new
    @task = Task.new
 #   @user = User.find(params[:id])
  end
  
  def create
    @task = Task.new(task_params)
    @user = current_user
    @task.user_id = @user.id   
#  @user = User.find(params[:id])
    
    if @task.save
      flash[:success] = 'Taskが正常に追加されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Taskが追加されませんでした'
      render :new
    end
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] ='Task は更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    
    flash[:success] = 'Task は正常に削除されました'
    redirect_to root_path
  end
  
  private
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
   def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_path
    end
  end
  
end
