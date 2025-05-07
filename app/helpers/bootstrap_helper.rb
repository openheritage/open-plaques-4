# assist Bootstrap
module BootstrapHelper
  # turn Markdown into Bootstrap-friendly html
  def markdown(text)
    markdown = Redcarpet::Markdown.new(
      CustomRender,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true,
      footnotes: true,
      highlight: true,
      no_intra_emphasis: true,
      superscript: true,
      tables: true,
      underline: true
    )
    ERB.new(markdown.render(text || "").html_safe).result(binding).html_safe
  end

  # render Bootstrap-friendly html
  # see https://github.com/vmg/redcarpet/blob/master/ext/redcarpet/rc_render.c
  class CustomRender < Redcarpet::Render::HTML
    def paragraph(text)
      text.gsub!(/plaque ([0-9]+)/) do |match|
        %(<div class="col-xs-6 col-sm-4 col-md-3"><%= render partial: 'plaques/tile', object: Plaque.find(#{match[7..-1]}), as: :plaque  %></div>)
      end
      %(#{text})
    end

    def table(header, body)
      %(<div class='table-responsive'><table class='mx-auto w-auto table table-striped text-center mx-auto'>#{header}#{body}</table></div>)
    end
  end

  # Generate <li><a href=...></a></li> appropriate for the Bootstrap navbar.
  # If :active_when hash is provided in the options, a class=active will
  # automatically be added to the <li> when appropriate.
  #
  # Example:
  #
  #     <%= navbar_link_to(
  #           "Home",
  #           root_path,
  #           active_when: { controller: :home }) %>
  #
  def navbar_link_to(label, path, options = {})
    active_when = options.delete(:active_when) { {} }
    active = active_when.all? do |key, value|
      params[key].to_s == value.to_s
    end
    active_class = ""
    active_class = " active" if active
    options[:class] = "nav-link"
    content_tag(:li, class: "nav-item#{active_class}") do
      link_to(label, path, options)
    end
  end
end
