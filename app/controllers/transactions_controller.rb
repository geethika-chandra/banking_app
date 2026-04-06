class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @account = current_user.accounts.find(params[:account_id])
  end

  def create
    @account = current_user.accounts.find(params[:account_id])
    amount = params[:amount].to_f
    type = params[:transaction_type]

    ActiveRecord::Base.transaction do
      case type
      when "deposit"
        @account.update!(balance: @account.balance + amount)

      when "withdraw"
        raise "Insufficient Balance" if @account.balance < amount
        @account.update!(balance: @account.balance - amount)

      when "transfer"
        receiver = Account.find_by(account_number: params[:receiver_account])

        raise "Invalid Receiver" unless receiver
        raise "Insufficient Balance" if @account.balance < amount

        @account.update!(balance: @account.balance - amount)
        receiver.update!(balance: receiver.balance + amount)
      end

      @account.transactions.create!(
        transaction_type: type,
        amount: amount,
        status: "success"
      )
    end

    redirect_to account_path(@account), notice: "Transaction successful"

  rescue => e
    redirect_to account_path(@account), alert: e.message
  end
end