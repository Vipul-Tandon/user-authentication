require 'rails_helper'

RSpec.describe AuthenticationController do
    
    describe "POST login" do
        let!(:user) { create(:user, email: "brad.pitt@gmail.com", password: "brad.pitt403") }

        context "with valid credentials" do
            before do
                post :login, params: {email: "brad.pitt@gmail.com", password: "brad.pitt403"}
            end
            
            it "should find the user by email" do
                expect(assigns(:user)).not_to be_nil
            end

            it "should authenticates the user with the provided password" do
                expect(assigns(:user).authenticate("brad.pitt403")).to eq(user)
            end

            it 'should return an ok HTTP status' do
                expect(response).to have_http_status(:ok)
            end

            it "should return a JWT token" do
                expect(JSON.parse(response.body)).to include("token", "exp", "username")
            end
            
        end

        context "with invalid credentials" do
            before do
                post :login, params: { email: "brad.pitt@gmail.com", password: "invalid" }
            end

            it "should return an unauthorized HTTP status" do
                expect(response).to have_http_status(:unauthorized)
            end

            it "should return error message" do
                expect(JSON.parse(response.body)).to include("error")
            end
        end
    end


    describe "POST logout" do
        let(:user) { create(:user) }
        let(:token) { JsonWebToken.encode(user_id: user.id) }
        
        before do
            request.headers['Authorization'] = "Bearer #{token}"
            post :logout
        end

        it "should return an ok HTTP status" do
            expect(response).to have_http_status(:ok)
        end

        it "should return a success message" do
            expect(JSON.parse(response.body)).to include("message" => "Logged out successfully")
        end
    end
end