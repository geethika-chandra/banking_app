class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts
  end

  def show
    @account = current_user.accounts.find(params[:id])
  end

  def new
    @account = Account.new
  end

  def create
    @account = current_user.accounts.build(account_params)
    @account.balance = 0

    if @account.save
      redirect_to accounts_path, notice: "Account created successfully"
    else
      render :new
    end
  end

  private

  def account_params
    params.require(:account).permit(:balance)
  end
end