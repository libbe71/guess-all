# Pin npm packages by running ./bin/importmap

pin "application"
pin "scheduler" # @0.23.0
pin "@rails/actioncable", to: "actioncable.esm.js"
# pin_all_from "app/assets/javascript/channels", under: "channels"
