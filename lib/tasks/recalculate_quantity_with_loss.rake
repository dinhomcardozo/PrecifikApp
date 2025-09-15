namespace :products do
  desc "Recalcula quantity_with_loss para todos os subprodutos"
  task recalc_quantity_with_loss: :environment do
    Product.find_each do |product|
      product.update_subproducts_quantity_with_loss
    end
    puts "Recalculo concluído!"
  end
end