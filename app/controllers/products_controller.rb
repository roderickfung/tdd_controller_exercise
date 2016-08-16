class ProductsController < ApplicationController

  def new
    @product = Product.new
  end

  def index
    @product = Product.order(created_at: :asc)
  end

  def create
    @product = Product.new params.require(:product).permit(:name, :description, :price, :inventory)
    if @product.save
      redirect_to product_path(@product), notice: "Product saved"
    else
      render :new
    end

  end

  def show
    @product = Product.find params[:id]
  end

  def edit
    @product = Product.find params[:id]
  end

  def update
    @product = Product.find params[:id]

    if @product.update params.require(:product).permit([:name,:description,:price,:inventory])
      redirect_to product_path(@product), notice: "Product saved"
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find params[:id]
    @product.destroy
    redirect_to products_path
  end
end
