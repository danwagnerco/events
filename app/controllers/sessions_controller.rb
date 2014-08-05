class SessionsController < ApplicationController

  def new
    render
  end

  def create
    params[:email]
    params[:password]
  end

end
