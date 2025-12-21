require 'action_view/helpers/tags/base'
# Most input types need the form-control class on them.  This is the easiest way to get that into every form input
# These method signature *must* match https://api.rubyonrails.org/files/actionview/lib/action_view/helpers/tags/base_rb.html
# Rails 7 version
module BootstrapTag
  def content_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
    # puts("content_tag(name=#{name}, content_or_options_with_block=#{content_or_options_with_block}, options=#{options}, escape=#{escape})")
    options = add_bootstrap_class_to_options(options, 'form-control') if name.to_s == 'textarea'
    options = add_bootstrap_class_to_options(options, 'form-select') if name.to_s == 'select'
    super
  end

  def select_tag(name, option_tags = nil, options = {})
    # puts("select_tag(name=#{name}, option_tags=#{option_tags}, options=#{options})")
    super
  end

  def submit_tag(value = 'Save changes', options = {})
    # puts("submit_tag(value=#{value}, options=#{options})")
    options = add_bootstrap_class_to_options(options, 'btn btn-primary')
    super
  end

  def tag(name = nil, options = nil, open = false, escape = true)
    # puts("tag(name=#{name}, options=#{options}, open=#{open}, escape=#{escape})")
    if options && options['dummy'] == true
      # drop the name from 'main_object[attribute]' to 'attribute' so is ignored suring allowed_params
      options['name'] = options['name'].match(/\[(.*)\]/)[1]
      options['readonly'] = true
    end
    options = add_bootstrap_class_to_options(options, 'form-check-input') if options.present? && options['type'] =~ /checkbox|radio/
    options = add_bootstrap_class_to_options(options, 'form-control', true) if name.to_s == 'input'
    # puts("now -> #{name} : #{options}")
    super
  end

  def hidden_label_tag(name = nil, content_or_options = nil, options = nil, &block)
    # puts("hidden_label_tag(name=#{name}, content_or_options=#{content_or_options}, options=#{options}, &block)")
    options = add_bootstrap_class_to_options(options, 'visually-hidden')
    # puts("hidden_label_tag(name=#{name}, content_or_options=#{content_or_options}, options=#{options}, &block)")
    label_tag(name, content_or_options, options, &block)
  end

  private

  def add_bootstrap_class_to_options(options, default, check_type = false)
    options = {} if options.nil?
    options.stringify_keys!
    if !check_type || options['type'].to_s.in?(%w(date email number password text))
      options['class'] = [] unless options.has_key? 'class'
      options['class'] << default if options['class'].is_a?(Array) && !options['class'].include?(default)
      options['class'] << " #{default}" if options['class'].is_a?(String) && options['class'] !~ /\b#{default}\b/
    end
    options
  end

  def content_tag_string(name, content, options, escape = true)
    # puts("content_tag_string(name=#{name}, content=#{content}, options=#{options}, escape=#{escape})")
    options = add_bootstrap_class_to_options(options, 'form-control') if name.to_s.in? %w(select textarea)
    super
  end

  def label_tag(name = nil, content_or_options = nil, options = nil, &block)
    # puts("label_tag(name=#{name}, content_or_options=#{content_or_options}, options=#{options}, &block)")
    options = add_bootstrap_class_to_options(options, 'form-label') unless options.present? && [options['class']].join =~ /form-.*label/
    super
  end
end

ActionView::Helpers::Tags::Base.send :include, BootstrapTag
ActionView::Base.send :include, BootstrapTag
