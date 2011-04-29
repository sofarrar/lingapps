module ApplicationHelper

# Return a title on a per-page basis.
   def title
      base_title = "LingApps"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  
  
  def logo
      image_tag("ling-apps-logo.jpg", :alt => "Sample App", :class => "round")
        end
  end


  def signup_button 
      image_tag("sign_up_yellow.png", :alt => "Sample App", :class => "round")
  end



