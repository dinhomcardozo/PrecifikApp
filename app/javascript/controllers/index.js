import { Application } from "@hotwired/stimulus"

import ProductCompositionController from "./product_composition_controller"
import AggregatedCostsController from "./aggregated_costs_controller"
import PricingController from "./pricing_controller"
import NestedFormController from "./nested_form_controller"
import TabsController from "./tabs_controller"
import CompositionRowController from "./composition_row_controller"
import DepreciationController from "./depreciation_controller"
import DropdownController from "./dropdown_controller"
import ServiceNestedFormController from "./service_nested_form_controller"
import ServiceFormController from "./service_form_controller"
import Select2Controller from "./select2_controller"
import TableFilterController from "./table_filter_controller"
import CnpjVerificationController from "./cnpj_verification_controller"
import CalendarController from "./calendar_controller"
import SalesTargetAlertController from "./sales_target_alert_controller"
import NoticeController from "./notice_controller"
import SimulationController from "./simulation_controller"
import PortionPackagesController from "./portion_packages_controller"
import ProductPortionPricingController from "./product_portion_pricing_controller"
import InlineEditController from "./inline_edit_controller"
import AutosubmitController from "./autosubmit_controller"
import PriceListController from "./price_list_controller"
import NewBrandInputsController from "./new_brand_inputs_controller"
import NewRoleProfessionalsController from "./new_role_professionals_controller"

const application = Application.start()

application.register("product-composition", ProductCompositionController)
application.register("aggregated-costs", AggregatedCostsController)
application.register("pricing", PricingController)
application.register("nested-form", NestedFormController)
application.register("tabs", TabsController)
application.register("composition-row", CompositionRowController)
application.register("depreciation", DepreciationController)
application.register("dropdown", DropdownController)
application.register("service-nested-form", ServiceNestedFormController)
application.register("service-form", ServiceFormController)
application.register("select2", Select2Controller)
application.register("table-filter", TableFilterController)
application.register("cnpj-verification", CnpjVerificationController)
application.register("calendar", CalendarController)
application.register("sales-target-alert", SalesTargetAlertController)
application.register("notice", NoticeController)
application.register("simulation", SimulationController)
application.register("portion-packages", PortionPackagesController)
application.register("product-portion-pricing", ProductPortionPricingController)
application.register("inline-edit", InlineEditController)
application.register("autosubmit", AutosubmitController)
application.register("price-list", PriceListController)
application.register("new-brand-inputs", NewBrandInputsController)
application.register("new-role-professionals", NewRoleProfessionalsController)

window.Stimulus = application