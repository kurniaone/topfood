module ApplicationHelper
  # @author Wawan Kurniawan <wawan@domikado.com>
  # Show form error messages
  def error_messages(object)
    html = ""
    if object && !object.errors.blank?
      html << "<ul class='form-error'>"
      object.errors.full_messages.each do |error|
        html << "\t<li>#{error}</li>\n"
      end
      html << "</ul>"
    end
    html
  end

  # @author Wawan Kurniawan <wawan@domikado.com>
  # Indonesian Curreny Format
  def to_rupiach(number, rp = false)
    formated_number = rp ? "Rp " : ""
    formated_number += "#{number_to_currency(number, :separator => ',', :delimiter => '.', :unit => '')}"
  end

  # @author Wawan Kurniawan <wawan@domikado.com>
  # DateTime format
  def date_time_format(date_time)
    date_time.strftime("%d %b %Y %H:%M:%S") if date_time
  end

  # @author Wawan Kurniawan <wawan@domikado.com>
  # Date format
  def date_format(date, str = true)
    format = str ? "%d %b %Y" : "%d/%m/%Y"
    date.strftime(format) if date
  end

  # remove order details
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  # add order details
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_row", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end


  def link_to_remove_approvals(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_approvals(this)", :class => 'remove-approval')
  end

  def link_to_add_approvals(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end

    link_to_function(name, "add_approvals(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => 'add-approval')
  end

end
