module IconHelper
  def icon(name, options = {})
    file_path = Rails.root.join("app", "assets", "images", "icons", "#{name}.svg")
    return "(ícone #{name} não encontrado)" unless File.exist?(file_path)

    svg = File.read(file_path)

    if options[:class].present?
      svg = svg.sub("<svg", "<svg class=\"#{options[:class]}\"")
    end

    svg.html_safe
  end
end