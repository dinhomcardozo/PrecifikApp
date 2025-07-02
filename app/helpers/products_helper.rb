module ProductsHelper
    def product_composition_fields_template(form_builder)
        form_builder.fields_for :product_subproducts, ProductSubproduct.new, child_index: "NEW_RECORD" do |ps|
        render(partial: "products/product_composition_fields", locals: { f: ps })
        end
    end
end