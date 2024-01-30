require 'rails_helper'

RSpec.describe UsersController do
    
    describe "POST create" do
        context "with valid parameters" do
            # attributes_for is an inbuilt method in factory_bot
            let(:valid_params) { attributes_for(:user) }

            before do
                post :create, params: valid_params
            end

            it "should return a created HTTP status" do
                expect(response).to have_http_status(:created)
            end
            
            it "should have valid body" do
                expect(JSON.parse(response.body)).to include("name", "username", "email")
            end
        end
        
        context "with invalid parameters" do
            let(:invalid_params) { attributes_for(:user, email: "invalid_email") }
            
            before do
                post :create, params: invalid_params
            end
            
            it "should return an unprocessable_entity HTTP status" do
                expect(response).to have_http_status(:unprocessable_entity)
            end
            
            it "should return error message" do
                expect(JSON.parse(response.body)).to include("errors")
            end
        end
    end
    
    
    
    
    describe "GET index" do
        let(:user) { create :user }
        let(:token) { JsonWebToken.encode(user_id: user.id)}
        
        before do
            request.headers['Authorization'] = "Bearer #{token}"
            get :index
        end

        it 'should assign to @users' do
            expect(assigns(:users)).to eq([user])
        end
        
        it 'should return an ok HTTP status' do
            expect(response).to have_http_status(:ok)
        end

    end
end