// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { startOnLoad } from "./packs/startJs";
import "./channels"

document.addEventListener("DOMContentLoaded", () => {
    console.log("DOM loaded");
    startOnLoad();
});