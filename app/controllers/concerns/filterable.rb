# app/controllers/concerns/filterable.rb
module Filterable
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def apply_filters(relation)
    r = relation
    fp = filter_params

    r = r.with_subproduct_ids(fp[:subproduct_ids])
    r = r.with_input_ids(fp[:input_ids])
    r = r.with_brand_id(fp[:brand_id])
    r = r.search_desc(fp[:q])
    r = r.by_cost(fp[:cost_dir])
    r = r.by_name(fp[:name_dir])
    r.distinct
  end

  private

  def filter_params
    params.fetch(:f, {}).permit(
      subproduct_ids: [],
      input_ids: [],
      brand_id: [],
      cost_dir: :string,
      name_dir: :string,
      q: :string
    )
  end
end