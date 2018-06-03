module Api::V2
  class ChildrenController < ApplicationController
    # Swagger Documentation
    swagger_controller :children, 'Children Management'
    swagger_api :index do
      summary 'Fetches all Children'
      notes 'This lists all the children'
      param :query, :active, :boolean, :optional, 'Filter on whether or not the child is active'
      param :query, :alphabetical, :boolean, :optional, 'Order children by alphabetical'
    end
    swagger_api :show do
      summary 'Shows one Child'
      param :path, :id, :integer, :required, 'Child ID'
      notes 'This lists details of one child'
      response :not_found
    end
    swagger_api :create do
      summary 'Creates a new Child'
      param :form, :first_name, :string, :required, 'First name'
      param :form, :last_name, :string, :required, 'Last name'
      param :form, :active, :boolean, :required, 'Active'
      response :not_acceptable
    end
    swagger_api :update do
      summary 'Updates an existing Child'
      param :path, :id, :integer, :required, 'Child Id'
      param :form, :first_name, :string, :optional, 'First name'
      param :form, :last_name, :string, :optional, 'Last name'
      param :form, :active, :boolean, :optional, 'Active'
      response :not_found
      response :not_acceptable
    end
    swagger_api :destroy do
      summary 'Deletes an existing Child'
      param :path, :id, :integer, :required, 'Child Id'
      response :not_found
    end
  
    # Controller Code
  
    before_action :set_child, only: %i[show update destroy]
  
    # GET /children
    def index
      @children = Child.all
      if params[:active].present?
        @children = params[:active] == 'true' ? @children.active : @children.inactive
      end
      if params[:alphabetical].present? && params[:alphabetical] == 'true'
        @children = @children.alphabetical
      end
      json_string = ChildSerializer.new(@children).serialized_json
      render json: json_string
    end
  
    # GET /children/1
    def show
      render json: ChildSerializer.new(@child).serialized_json
    end
  
    # POST /children
    def create
      @child = Child.new(child_params)
  
      if @child.save
        json_string = ChildSerializer.new(@children).serialized_json
        render json: json_string, status: :created, location: [:v1, @child]
      else
        render json: @child.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /children/1
    def update
      if @child.update(child_params)
        json_string = ChildSerializer.new(@children).serialized_json
        render json: json_string
      else
        render json: @child.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /children/1
    def destroy
      @child.destroy
    end
  
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_child
      @child = Child.find(params[:id])
    end
  
    # Only allow a trusted parameter "white list" through.
    def child_params
      params.permit(:first_name, :last_name, :active)
    end
  end
  
end
