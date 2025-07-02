// app/javascript/controllers/index.js
import { Application } from "@hotwired/stimulus"
import ProductCompositionController from "./product_composition_controller"
import AggregatedCostsController      from "./aggregated_costs_controller"
import PricingController              from "./pricing_controller"
import SubproductNestedFormController from "./subproduct_nested_form_controller"
import TabsController from "./tabs_controller"

const application = Application.start()
application.register("product-composition",      ProductCompositionController)
application.register("aggregated-costs",        AggregatedCostsController)
application.register("pricing",                 PricingController)
application.register("subproduct-nested-form",  SubproductNestedFormController)
application.register("tabs", TabsController)