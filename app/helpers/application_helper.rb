module ApplicationHelper
  def button_delete(path)
    button_to(t("buttons.delete"), path, { method: :delete, class: "btn btn-danger" })
  end

  def alternate_link_to(text, path, format)
    link_to text, path, type: Mime::Type.lookup_by_extension(format.to_s).to_s, rel: %i[alternate nofollow]
  end

  def div(options = {}, &block)
    content_tag(:div, options, &block)
  end

  def csv_escape(string)
    return "" if string.blank?

    '"' + string.gsub(/[\r\n]/, " ").gsub(/\s\s+/, " ").strip + '"'
  end

  def block_tag(tag, options = {}, &block)
    concat(content_tag(tag, capture(&block), options), block.binding)
  end

  # h() replaces some characters, but not apostrophes or carriage returns
  def html_safe(phrase)
    h(phrase).gsub(/'/, "&#39;").gsub(/\r\n/, "<br/>")
  end

  def unknown(text = "unknown")
    content_tag(:span, text, class: :unknown)
  end

  # Outputs an abbreviation tag for 'circa'.
  #
  # ==== Example output:
  #   <abbr title="circa">c</abbr>
  def circa_tag
    content_tag(:abbr, "c", { title: "circa" })
  end

  # Produces a link wrapped in a list item element (<li>).
  def list_link_to(link_text, options = {}, html_options = {})
    content_tag(:li, link_to(link_text, options, html_options))
  end

  # Returns 'a' or 'an' depending on whether the word starts with a vowel or not
  #
  # ==== Parameters
  # <tt>name</tt> - the word
  # <tt>include_name - whether to include the name in the string output or not.
  def a_or_an(name, include_name = true)
    return "" unless name.present?

    article = if name[0, 1] =~ /[aeiou]/
                "an".html_safe
    else
                "a".html_safe
    end
    if include_name
      article + " ".html_safe + name
    else
      article
    end
  end

  # Returns "hasn't" or "haven't" depending on whether a number is more than 1.
  def havent_or_hasnt(number)
    if number == 1
      "hasn't"
    else
      "haven't"
    end
  end

  def pluralize_is_or_are(number, name)
    word = number > 1 ? "are" : "is"
    "#{word} #{pluralize(number, name)}"
  end

  def pluralize_no_count(count, singular, plural = nil)
    if [ 1, "1" ].include?(count)
      singular
    else
      plural || singular.pluralize
    end
  end

  # A persistant navigation link, as used in "top navs" or "left navs".
  # The main difference is that the link is replaced by a <span> tag when
  # the link would otherwise lead to the page you're already on. This can be used
  # for styling in CSS.
  def navigation_link_to(name, options = {}, html_options = {})
    current_page?(options) ? content_tag(:span, name) : link_to(name, options, html_options)
  end

  # A (persistant) navigation link embedded within a list item.
  # === Example
  #   <%= navigation_list_link_to("Home", root_path) %>
  # Produces:
  #   <li><a href="/">Home</a></li>
  def navigation_list_link_to(name, options = {}, html_options = {})
    content_tag(:li, navigation_link_to(name, options, html_options))
  end

  def pluralize_with_no(number, name)
    number.zero? ? "no #{name}" : pluralize(number, name)
  end

  def pluralize_word(count, singular, plural = nil)
    count == 1 || count.to_s =~ %r{^1(\.0+)?$} ? singular : plural || singular.pluralize
  end

  def make_slug_not_war
    return unless slug.blank?

    self.slug = name.to_s.strip.downcase.tr(" ", "_").tr("-", "_").tr(",", "_").tr(".", "_").tr("'", "").gsub("__", "_")
  end
end
