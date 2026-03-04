module ApplicationHelper
  def sanitize_url(url)
    uri = URI.parse(url.to_s)
    uri.scheme&.match?(/\Ahttps?\z/i) ? url : '#'
  rescue URI::InvalidURIError
    '#'
  end
end
