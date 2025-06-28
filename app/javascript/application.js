// app/javascript/application.js
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "./controllers"       // agora é um caminho relativo!

ActiveStorage.start()
