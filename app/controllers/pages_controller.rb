class PagesController < ApplicationController

  def index 
    @title = "Index"
  end


  def home
    @title = "Home"
  end

  def contact
    @title = "Contact"
  end

end
