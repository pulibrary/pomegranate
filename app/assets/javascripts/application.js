// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
// Required by Blacklight
//= require blacklight/blacklight
//= require pul-assets
//= require 'blacklight_oembed/jquery.oembed.js'
//= require blacklight_gallery
//= require openseadragon
//= require spotlight
// ES6 modules
//= require almond
//= require universal_viewer
//= require pom_boot
//= require more_link
//= require back_to_top
//= require sir_trevor/blocks/recent_items

Blacklight.onLoad(function() {
  Initializer = require('pom_boot')
  window.pom = new Initializer()
})
