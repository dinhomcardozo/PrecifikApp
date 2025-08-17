module ApplicationHelper
  def link_to_add_fields(name, f, association, options = {})
    new_object = f.object.send(association).klass.new
    marker = "NEW_RECORD"

    fields = f.fields_for(association, new_object, child_index: marker) do |builder|
      render("#{association}_fields", f: builder)
    end

    link_to(
      name,
      "#",
      options.merge(data: {
        id: marker,
        fields: fields.gsub("\n", "").gsub(/<!--.*?-->/m, "")
      })
    ).html_safe
  end

    # retorna um ActionView::Helpers::FormBuilder já configurado para partials de composição
  def form_builder_for(ps)
    ActionView::Helpers::FormBuilder.new(
      :product_subproduct,
      ps,
      self,
      { parent: @product, index: ps.persisted? ? ps.id : "NEW_RECORD" }
    )
  end

  # Gera um link que alterna a direção (asc ↔ desc) e preserva os filtros
  def sortable(column, title = nil)
    title ||= column.titleize
    # Direção atual e a direção que vamos gerar
    current_col  = params[:sort] == column
    current_dir  = params[:direction] == "asc" ? "asc" : "desc"
    new_dir      = current_col && current_dir == "asc" ? "desc" : "asc"

    css_class = current_col ? "sorted #{current_dir}" : nil

    link_to title,
      url_for(
        request.query_parameters
               .merge(sort: column, direction: new_dir, page: nil)
      ),
      class: css_class
  end
end