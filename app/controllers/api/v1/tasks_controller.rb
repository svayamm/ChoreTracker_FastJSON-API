module Api::V1
  class TasksController < ApplicationController
    #   # Swagger Documentation
    swagger_controller :tasks, 'Tasks Management'
    swagger_api :index do
      summary 'Fetches all Tasks'
      notes 'This lists all the Tasks'
      param :query, :active, :boolean, :optional, 'Filter on whether or not the task is active'
      param :query, :alphabetical, :boolean, :optional, 'Order tasks by alphabetical'
    end
    swagger_api :show do
      summary 'Shows one Task'
      param :path, :id, :integer, :required, 'Task ID'
      notes 'This lists details of one Task'
      response :not_found
    end
    swagger_api :create do
      summary 'Creates a new Task'
      param :form, :name, :string, :required, 'Task Name'
      param :form, :points, :integer, :required, 'Task Points'
      param :form, :active, :boolean, :required, 'Active'
      response :not_acceptable
    end
    swagger_api :update do
      summary 'Updates an existing Task'
      param :path, :id, :integer, :required, 'Task Id'
      param :form, :name, :string, :optional, 'Task Name'
      param :form, :points, :integer, :optional, 'Task Points'
      param :form, :active, :boolean, :optional, 'Active'
      response :not_found
      response :not_acceptable
    end
    swagger_api :destroy do
      summary 'Deletes an existing Task'
      param :path, :id, :integer, :required, 'Task Id'
      response :not_found
    end

    before_action :set_task, only: %i[show update destroy]
    def index
      @tasks = Task.all
      if params[:active].present?
        @tasks = params[:active] == 'true' ? @tasks.active : @tasks.inactive
        end
      if params[:alphabetical].present? && params[:alphabetical] == 'true'
        @tasks = @tasks.alphabetical
        end

      # render json: @tasks
      render json: TaskSerializer.new(@tasks).serialized_json
    end

    def show
      # render json: @task
      render json: TaskSerializer.new(@task).serialized_json
    end

    def create
      @task = Task.new(task_params)

      if @task.save
        #   render json: @task, status: :created, location: [:v1, @task]
        render json: TaskSerializer.new(@task).serialized_json, status: :created, location: [:v1, @task]

      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    def update
      if @task.update(task_params)
        #   render json: @task
        render json: TaskSerializer.new(@task).serialized_json
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @task.destroy
    end

    private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.permit(:name, :points, :active)
    end
    end
end
