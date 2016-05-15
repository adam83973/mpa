require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do

  let(:attendance_experience){FactoryGirl.create(:attendance_experience)}
  let(:attendance){FactoryGirl.create(:attendance)}

  # This should return the minimal set of attributes required to create a valid
  # Attendance. As you add validations to Attendance, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip(attendance.attributes)
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AttendancesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:user){FactoryGirl.create(:admin)}

  describe "GET #index" do
    it "assigns all attendances as @attendances" do
      sign_in user
      attendances = Attendance.all
      get :index, {}, valid_session
      expect(assigns(:attendances)).to eq([attendance])
    end
  end

  describe "GET #show" do
    it "assigns the requested attendance as @attendance" do
      sign_in user
      get :show, {:id => attendance.to_param}, valid_session
      expect(assigns(:attendance)).to eq(attendance)
    end
  end

  describe "GET #new" do
    it "assigns a new attendance as @attendance" do
      sign_in user
      get :new, {}, valid_session
      expect(assigns(:attendance)).to be_a_new(Attendance)
    end
  end

  describe "GET #edit" do
    it "assigns the requested attendance as @attendance" do
      sign_in user
      get :edit, {:id => attendance.to_param}, valid_session
      expect(assigns(:attendance)).to eq(attendance)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Attendance" do
        sign_in user
        expect {
          post :create, {:attendance => valid_attributes}, valid_session
        }.to change(Attendance, :count).by(1)
      end

      it "assigns a newly created attendance as @attendance" do
        sign_in user
        post :create, {:attendance => valid_attributes}, valid_session
        expect(assigns(:attendance)).to be_a(Attendance)
        expect(assigns(:attendance)).to be_persisted
      end

      it "redirects to the created attendance" do
        sign_in user
        post :create, {:attendance => valid_attributes}, valid_session
        expect(response).to redirect_to(Attendance.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved attendance as @attendance" do
        sign_in user
        post :create, {:attendance => invalid_attributes}, valid_session
        expect(assigns(:attendance)).to be_a_new(Attendance)
      end

      it "re-renders the 'new' template" do
        sign_in user
        post :create, {:attendance => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested attendance" do
        put :update, {:id => attendance.to_param, :attendance => new_attributes}, valid_session
        attendance.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested attendance as @attendance" do
        sign_in user
        put :update, {:id => attendance.to_param, :attendance => valid_attributes}, valid_session
        expect(assigns(:attendance)).to eq(attendance)
      end

      it "redirects to the attendance" do
        sign_in user
        put :update, {:id => attendance.to_param, :attendance => valid_attributes}, valid_session
        expect(response).to redirect_to(attendance)
      end
    end

    context "with invalid params" do
      it "assigns the attendance as @attendance" do
        sign_in user
        put :update, {:id => attendance.to_param, :attendance => invalid_attributes}, valid_session
        expect(assigns(:attendance)).to eq(attendance)
      end

      it "re-renders the 'edit' template" do
        sign_in user
        put :update, {:id => attendance.to_param, :attendance => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested attendance" do
      sign_in user

      expect {
        delete :destroy, {:id => attendance.to_param}, valid_session
      }.to change(Attendance, :count).by(-1)
    end

    it "redirects to the attendances list" do
      sign_in user
      delete :destroy, {:id => attendance.to_param}, valid_session
      expect(response).to redirect_to(attendances_url)
    end
  end

end
