module Api::V1
    class ChoresController < ApplicationController 
        # Swagger Documentation
        swagger_controller :Chores, "Chores Management"
        swagger_api :index do
            summary "Fetches all Chores"
            notes "This lists all the Chores"
            
            param :query, :chronological, :boolean, :optional, "Order chores by chronology"
            param :query, :by_task, :boolean, :optional, "Order chores by task"
    
            param :query, :done, :boolean, :optional, "Filter on whether or not the chore is done/pending"
            param :query, :upcoming, :boolean, :optional, "Filter on whether or not the chore is upcoming/past"
        end
        swagger_api :show do
            summary "Shows one Chore"
            param :path, :id, :integer, :required, "Chore ID"
            notes "This lists details of one Chore"
            response :not_found
        end
        swagger_api :create do
            summary "Creates a new Chore"
            param :form, :child_id, :integer, :required, "Child ID"
            param :form, :task_id, :integer, :required, "Task ID"
            param :form, :due_on, :date, :required, "Due Date"
            param :form, :completed, :boolean, :required, "Completed"
            response :not_acceptable
        end
        swagger_api :update do
            summary "Updates an existing Chore"
            param :path, :id, :integer, :required, "Chore Id"
            param :form, :child_id, :integer, :optional, "Child ID"
            param :form, :task_id, :integer, :optional, "Task ID"
            param :form, :due_on, :date, :optional, "Due Date"
            param :form, :completed, :boolean, :optional, "Completed"
            response :not_found
            response :not_acceptable
        end
        swagger_api :destroy do
            summary "Deletes an existing Chore"
            param :path, :id, :integer, :required, "Chore Id"
            response :not_found
        end
        
        before_action :set_chore, only: [:show, :update, :destroy]
        def index
            @chores = Chore.all 
    
            if(params[:done].present?)
                @chores = params[:done] == "true" ? @chores.done : @chores.pending
              end
            if(params[:upcoming].present?)
                @chores = params[:upcoming] == "true" ? @chores.upcoming : @chores.past
            end
            if params[:chronological].present? && params[:chronological] == "true"
                @chores = @chores.chronological
            end
            if params[:by_task].present? && params[:by_task] == "true"
                @chores = @chores.by_task
            end
    
            # render json: @chores
            render json: ChoreSerializer.new(@chores).serialized_json
        end
    
        def show
            # render json: @chore
            render json: ChoreSerializer.new(@chore).serialized_json
        end
        
        def create
            @chore = Chore.new(chore_params)
    
            if @chore.save
                # render json: @chore, status: :created, location: [:v1, @chore]
                render json: ChoreSerializer.new(@chore).serialized_json, status: :created, location: [:v1, @chore]
            else
                render json: @chore.errors, status: :unprocessable_entity
            end
        end
        
        def update
            if @chore.update(chore_params)
                # render json: @chore
                render json: ChoreSerializer.new(@chore).serialized_json
            else
                render json: @chore.errors, status: :unprocessable_entity
            end
        end
        
        def destroy
            @chore.destroy
        end
    
        private
        def set_chore
            @chore = Chore.find(params[:id])
        end
    
        def chore_params
            params.permit(:task_id, :child_id, :due_on, :completed)
        end
    end
end

