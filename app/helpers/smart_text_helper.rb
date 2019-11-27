module SmartTextHelper
  def smart_format(text, html_options = {}, options = {})
    parsed_text = simple_format(ERB::Util.html_escape(text), html_options, options).to_str
    raw(auto_link(parsed_text,
      html: {class: 'auto_link', target: '_blank'},
      link: :urls,
      sanitize: false))
  end
end