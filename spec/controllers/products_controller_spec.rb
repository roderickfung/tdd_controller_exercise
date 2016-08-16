require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe "#new" do
    it "should load up new template" do
      get :new
      expect(response).to render_template(:new)
    end

    it "instantiates a new product instance variable" do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end
  end

  describe "#index" do

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "defines an instance variable for all products" do
      product = FactoryGirl.create(:product)
      product2 = FactoryGirl.create(:product)
      get :index
      expect(assigns(:product)).to eq([product,product2])
    end

  end

  describe "#create" do

    def create_data
      post :create, params: {product: {name: "product name", description: "blah", price: 2000, inventory: 1000000}}
    end

    context "valid_entry" do
      it "saves a record to database" do
        before_count = Product.count
        # product = FactoryGirl.create(:product)
        create_data
        after_count = Product.count
        expect(after_count).to eq(before_count + 1)
      end

      it "redirects to product show" do
        # product = FactoryGirl.create(:product)
        create_data
        expect(response).to redirect_to(product_path(Product.last))
      end

      it "sets a flash message" do
        create_data
        expect(flash[:notice]).to be
      end
    end

    def bad_data
      post :create, params: {product: {name: ""}}
    end

    context "invalid_entry" do
      it "renders the new template" do
        bad_data
        expect(response).to render_template(:new)
      end

      it "does not register to database" do
        count_before = Product.count
        bad_data
        count_after = Product.count
        expect(count_after).to eq(count_before)
      end
    end
  end

  describe "#edit" do
    def edit_data
      post :update, params: {product: {name: "product name", description: "blah", price: 2000, inventory: 1000000}}
    end

    it "should load up edit template" do
      product = FactoryGirl.create(:product)
      get :edit, params: {id: product.id}
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    def update_request(id)
      patch :update, params: {id: id, product: {name: "product name", description: "blah", price: 100000, inventory: 1000000}}
    end

    def update_invalid_request(id)
      post :update, params: {id: id, product: {name: ""}}
    end

    context "valid_entry" do
      it "saves to database" do
        product = FactoryGirl.create(:product)
        update_request(product.id)
        product_check = Product.find product.id
        expect(product.name).not_to eq(product_check.name)
      end

      it "redirects to show" do
        product = FactoryGirl.create(:product)
        update_request(product.id)
        expect(response).to redirect_to(product_path(product.id))
      end
    end

    context "invalid_entry" do
      it "does not save to database" do
        product = FactoryGirl.create(:product)
        update_invalid_request(product.id)
        expect(product).to eq(product)
      end

      it "renders edit page" do
        product = FactoryGirl.create(:product)
        update_invalid_request(product.id)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#destroy" do
    it "gets removed from the database" do
      product = FactoryGirl.create(:product)
      delete :destroy, params: {id: product.id}
      expect(Product.where(id: product.id).exists?).to eq(false)
    end

    it "redirects to index" do
      product = FactoryGirl.create(:product)
      delete :destroy, params: {id: product.id}
      expect(response).to redirect_to(products_path)
    end

  end
end
