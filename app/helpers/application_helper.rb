module ApplicationHelper
  def index_in_paginate(index)
    page = params[:page].to_i
    offset_page = page > 1 ? page - 1 : 0
    index + Kaminari.config.default_per_page * offset_page
  end

  def page_title(title)
    content_for(:title) { title + " - " + ENV['APP_NAME'] }
  end

  def paginate_for(records)
    content_tag :div, paginate(records), class: 'paginate-nav'
  end

  def errors_for(record)
    content_tag :ul, class: 'record-error' do
      result = ""
      record.errors.full_messages.each do |message|
        result += content_tag('li', message, class: 'record-error-field')
      end
      result.html_safe
    end
  end

  def flash_config
    config = {key: '', value: ''}
    flash.map do |key, value|
      config[:key] = key
      config[:value] = value
    end
    config
  end

  def flash_messages
    trans = { 'alert' => 'alert-danger', 'notice' => 'alert alert-success' }

    content_tag :div, class: 'alert-animate' do
      flash.map do |key, value|
        content_tag 'div', value, class: "alert #{trans[key]} alert-body"
      end.join('.').html_safe
    end
  end

  def breadcrumb options=nil
    content_tag(:ul, breadcrumb_str(options), :class => "breadcrumb")
  end

  def breadcrumb_str options
    items = []
    if(!options.blank?)
      items <<  content_tag(:li, link_home("Home", root_path) , :class => "active")
      options.each do |option|
        items << breadcrumb_node(option.first)
      end
    else
      icon = content_tag "i", " ", :class => "icon-user  icon-home"
      items << content_tag(:li, icon + "Home", :class => "active")
    end
    items.join("").html_safe
  end

  def breadcrumb_node option
    key = option[0]
    value = option[1]
    value ? content_tag(:li){ link_to(key, value)} : content_tag(:li, key, :class =>"active")
  end

  def page_header title, options={},  &block
    content_tag :div,:class => "list-header clearfix" do
      if block_given?
        content_title = content_tag :div, :class => "left" do
          content_tag(:h3, title, :class => "header-title")
        end

        output = with_output_buffer(&block)
        content_link = content_tag(:div, output, {:class => " right"})
        content_title + content_link
      else
        content_tag :div , :class => "" do
          content_tag(:h3, title, :class => "header-title")
        end
      end
    end
  end

  def email_template_params_for selector
    template_params = %w(url keyword member_name date)
    template_params_selector template_params, selector
  end

  def sms_template_params_for selector
    template_params = %w(url keyword member_name date)
    template_params_selector template_params, selector
  end

  def boolean_text state
    if state
      text = "Yes"
      klass = 'label-primary'
    else
      text = "No"
      klass = "label-danger"
    end
    content_tag :span, text, class: "bool-text label #{klass}"
  end

  def template_params_selector template_params, selector
    template_params.map do |anchor|
      link_to("{{#{anchor}}}", 'javascript:void(0)', data: {selector: selector}, class: 'param-link')
    end.join(", ").html_safe
  end

  def link_destroy value , url, options={}, &block
    link_icon "glyphicon-trash", value, url, options, &block
  end

  def link_edit value , url, options={}, &block
    link_icon "glyphicon-pencil", value, url, options, &block
  end

  def link_new value , url, options={}, &block
    options ||= {}
    options[:class] = "btn-icon btn btn-primary #{options[:class]}"

    link_icon "glyphicon-plus", value, url, options, &block
  end

  def link_home value, url, options={}, &block
    link_icon "glyphicon glyphicon-home", value, url, options, &block

  end

  def link_icon icon, value, url, options={}, &block
    options ||= {}
    options[:class] = "btn-icon #{options[:class]}"
    icon = content_tag :i, ' ',  class: "#{icon} glyphicon"
    text = content_tag :span, " #{value}"
    link_to icon+text, url, options, &block
  end

  def children_tree_for places
    places.map do |place, children|
      selected_class = (place.id == params["place_id"].to_i ? 'selected' : '')
      item = link_to("#{place.my_type} - #{place.name} (#{place.code})", "#", class: "tree-node #{selected_class}", data: {id: place.id})
      item += content_tag(:ul, children_tree_for(children)) if children.size > 0

      expanded_class = (!place.parent || place.id == params[:place_id].to_i) ? 'active' : ''
      content_tag(:li, item, class: "tree-node-wrapper #{expanded_class}")
      
    end.join('').html_safe
  end

  def tree_for places
    if !params[:place_id].present?
      active_root = 'active'
      selected_class = 'selected'
    else
      active_root = ''
      selected_class = ''
    end

    content_tag(:li, class: "tree-node-wrapper #{active_root}", id: 'tree-root') do
      link_to("Cambodia", '#', class: "tree-node #{selected_class}", data: {id: ''}) + content_tag(:ul, children_tree_for(places))
    end
  end

  def display_parent_for place
    content_tag :p, parent_for(place).reverse.join("<br/>").html_safe, class: 'p-desc'
  end

  def parent_for place
    result = []
    if place.parent
      text = "#{place.parent.my_type} - #{place.parent.name} ( #{place.parent.code} )"
      result << text
      result += parent_for(place.parent)
    end
    result
  end

  def display_hierachy_for place
    content_tag :p, hierachy_for(place).reverse.join("<br />").html_safe, class: 'p-desc'
  end

  def hierachy_for place
    result = []
    if place
      text = "#{place.my_type} - #{place.name} ( #{place.code} )"
      result << text
      result += hierachy_for(place.parent)
    end
    result
  end
end
