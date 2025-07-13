// app/javascript/controllers/index.js
import { Application } from "@hotwired/stimulus"
import ProductCompositionController from "./product_composition_controller"
import AggregatedCostsController      from "./aggregated_costs_controller"
import PricingController              from "./pricing_controller"
import NestedFormController from "./nested_form_controller"
import TabsController from "./tabs_controller"
import CompositionRowController from "./composition_row_controller"

const application = Application.start()
application.register("product-composition", ProductCompositionController)
application.register("aggregated-costs",        AggregatedCostsController)
application.register("pricing",                 PricingController)
application.register("nested-form",  NestedFormController)
application.register("tabs", TabsController)
application.register("composition-row", CompositionRowController)