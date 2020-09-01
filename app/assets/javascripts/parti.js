//= require masonry.pkgd
//= require sticky

// 내 홈 탭
$(document).imagesLoaded( { }, function() {
  $('.masonry-container').masonry({
    // itemSelector: '.masonry-item'
  });
  $('select.dropdown').dropdown();
});

$(function(){
  $('.js-sticky-sign-button').each(function() {
    var sticky = new Waypoint.Sticky({
      element: $('.js-sticky-sign-button')[0],
      direction: 'up',
      offset: 'bottom-in-view'
    })
  });
  $('[data-toggle="offcanvas"]').on('click', function () {
    $('.offcanvas-collapse').toggleClass('open');
  });
});