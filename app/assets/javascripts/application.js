// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

var deals_listing = {
  initialize: function(){
    $('.expires').each(function(i, el){
      var obj = $(el);
      var expire = obj.attr("data-exp");
      var expires = new Date(expire*1000);
      obj.countdown({until: expires, layout: "&nbsp;expires in {dn} {dl}, {hn} {hl}, {mn} {ml}, and {sn} {sl}"});
    });

    $('button.btn').click(function(e){
      el = $(this);
      window.open(el.parents('form').attr('action'));
      if (el.hasClass('code')) {
        alert("code is" + el.attr("data-code"));
      }
      e.preventDefault();
    });
  }
}

var product_details = {
  initialize: function(){
    $('.thumbnail').fancybox({
      openEffect  : 'none',
      closeEffect : 'none'
    });
    $('#myTab a:first').tab('show');
    $('#myTab a').click(function (e) {
      e.preventDefault();
      $(this).tab('show');
    });

    
    $('.carousel').carousel({
        interval: false
    });
  }
}


$(document).ready(function() {
  body = $("body");
  if (body.hasClass('products') && body.hasClass("show")) {
    product_details.initialize();
  }
  if (body.hasClass('deals') && body.hasClass("index")) {
    deals_listing.initialize();
  }
});