module ApplicationHelper

 # Returns the full title on a per-page basis.
  def full_title(page_title)
    # debugger
    base_title = "Aramex Shopify App"
    #logger.debug "page_title: #{page_title}"
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  # Determines the appropriate Bootstrap class for the Rails flash message
  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end 

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

end
