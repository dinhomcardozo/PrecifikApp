import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

// Inicializa o Stimulus
const application = Application.start()
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Inicializa o Turbo
import "@hotwired/turbo-rails"
import "@rails/activestorage"