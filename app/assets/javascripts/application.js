//= require jquery
//= require govcraft_ujs
//= require jquery_ujs
//= require bootstrap
//= require unobtrusive_flash
//= require unobtrusive_flash_bootstrap
//= require imagesloaded.pkgd
//= require masonry.pkgd
//= require redactor2_rails/config
//= require redactor
//= require redactor2_rails/langs/ko
//= require alignment
//= require fontcolor
//= require jssocials
//= require chartkick
//= require lodash
//= require select2
//= require select2_ko
//= require jquery.slick
//= require kakao
//= require mobile-detect
//= require magnific-popup
//= require jquery.validate
//= require jquery.validate.messages_ko
//= require jquery.webui-popover
//= require cocoon
//= require moment
//= require bootstrap-datetimepicker
//= require perfect-scrollbar
//= require jquery.waypoints
//= require waypoints.debug.js
//= require sticky
//= require infinite
//= require clipboard
//= require js.cookie

UnobtrusiveFlash.flashOptions['timeout'] = 3000;

// blank
$.is_blank = function (obj) {
  if (!obj || $.trim(obj) === "") return true;
  if (obj.length && obj.length > 0) return false;

  for (var prop in obj) if (obj[prop]) return false;

  if (obj) return false;
  return true;
}

$.is_present = function(obj) {
  return ! $.is_blank(obj);
}

$(document).imagesLoaded( { }, function() {
  $('.masonry-container').masonry({
    // itemSelector: '.masonry-item'
  });
  $('select.dropdown').dropdown();
});

// Kakao Key
Kakao.init('6a30dead1bff1ef43b7e537f49d2f655');

$(function(){
  $('[data-toggle="offcanvas"]').on('click', function () {
    $('.offcanvas-collapse').toggleClass('open');
  });

  $(".slick").slick();

  $(".js-published_at").datetimepicker({
    format: 'YYYY-MM-DD'
  });

  $( ".js-organization-area" ).hover(
    function() {
      $( this ).find(".desc").toggle();
    }
  );

  $('.js-top-menu').click(function(){
    $('#header-container').toggleClass('drop-main-menu');
  })

  $('.js-achv-folding-category').click(function(){
    $(this).next('.menu').toggle();
    $(this).find('.fa').toggle();
  })

  $('#communities .js-tab-toggle').click(function(){
    var flag = $(this).hasClass('active');
    if(!flag){
      $('.toggle-body').toggle();
      $('.tab-title div').toggleClass("active");
    }
  })

  $('.post-block__body iframe').addClass('embed-responsive-item');
  $('.post-block__body iframe').parent().addClass('embed-responsive embed-responsive-16by9');
  $('[data-toggle="tooltip"]').tooltip();
  AOS.init();

  $('.js-link').on('click', function(e) {
    var href = $(e.target).closest('a').attr('href')
    if (href && href != "#") {
      return true;
    }

    var $no_parti_link = $(e.target).closest('[data-no-parti-link="no"]')
    if ($no_parti_link.length) {
      return true;
    }

    e.preventDefault();
    var url = $(e.currentTarget).data("url");

    if(url) {
      if($.is_present($(this).data('link-target'))) {
        window.open(url, $(this).data('link-target'));
      } else {
        window.location.href  = url;
      }
    }
  });

  $('.js-select2').select2();

  $('.js-select2-ajax').each(function(index, elm) {
    var $elm = $(elm);
    $elm.select2({
      ajax: {
        url: $elm.data('select2-url'),
        dataType: 'json',
        delay: 250,
        language: "ko",
        data: function (params) {
          var query = {
            q: params.term,
            page: params.page || 1
          }
          return query;
        }, processResults: function (data, params) {
          // parse the results into the format expected by Select2
          // since we are using custom formatting functions we do not need to
          // alter the remote JSON data, except to indicate that infinite
          // scrolling can be used
          params.page = params.page || 1;

          return {
            results: data.items,
            pagination: {
              more: (params.page * 30) < data.total_count
            }
          };
        },
        cache: true
      }
    });
  });

  $('.gov-action-people-select').select2({
    ajax: {
      url: "/people/search.json",
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          q: params.term
        };
      },
      processResults: function (data, params) {
        return { results: data };
      },
      cache: true
    },
    escapeMarkup: function (markup) { return markup; }, // let our custom formatter work
    minimumInputLength: 1,
    templateResult: function (person) {
      if (person.loading) return person.text;
      return "<img src='" + person.image_url + "' style='max-height: 2em'/>" + person.text;
    },
    templateSelection: function (person) {
      if (person.loading) return person.text;
      return "<img src='" + person.image_url + "' style='max-height: 2em'/>" + person.text;
    },
  });

  $('.gov-action-targets-select').select2({
    ajax: {
      url: "/agents/search.json",
      dataType: 'json',
      delay: 250,
      data: function (params) {
        return {
          q: params.term
        };
      },
      processResults: function (data, params) {
        a = _.map(data.agents, function(el) {
            return { id: 'agent:' + el.id, name: el.name }
          })
        b = _.map(data.agencies, function(el) {
            return { id: 'agency:' + el.id, name: el.name }
          })
        return {
          results: a.concat(b)
        };
      },
      cache: true
    },
    escapeMarkup: function (markup) { return markup; },
    minimumInputLength: 1,
    templateResult: function (target) {
      return target.name
    },
    templateSelection: function (target) {
      return target.name
    },
  });

  $('.popup-youtube').magnificPopup({
    disableOn: 700,
    type: 'iframe',
    mainClass: 'mfp-fade',
    removalDelay: 160,
    preloader: false,

    fixedContentPos: false
  });

  $('.gov-action-sidbar').on('click', function(e) {
    $('#site-sidebar').sidebar('toggle');
  });

  // agenda theme bootstrap tab & location hash
  $('a.js-agenda-theme-tab[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    $('.tab-pane.active .js-loading').show();
    $('.tab-pane.active .js-tab-content').hide();

    window.location.hash = e.target.hash.substr(1) ;
    $('html, body').animate({scrollTop: ($('.tab-content').first().offset().top - 40)});

    var agenda_id = $(this).data("agenda-id");
    var href = $(this).attr("href");
    $.ajax({
      type: "GET",
      url: href,
      data: { agenda_id: agenda_id },
      dataType: "script",
      complete: function() {
        $('html, body').animate({scrollTop: ($('.tab-content').first().offset().top - 40)});
      }
    });
  });

  (function() {
    $('.js-horizontal-scroll-container').each(function(i, elm) {
      var ps = new PerfectScrollbar(elm);
      var $elm = $(elm);
      var $left_indicator = $($elm.data('scroll-indicator-left'));
      var $right_indicator = $($elm.data('scroll-indicator-right'));

      var update_indicators = function() {
        if(ps.scrollbarXActive) {
          if(ps.reach.x == 'start') {
            $left_indicator.hide();
            $right_indicator.show();
          }
          else if(ps.reach.x == 'end') {
            $left_indicator.show();
            $right_indicator.hide();
          } else {
            $left_indicator.show();
            $right_indicator.show();
          }
        } else {
          $left_indicator.hide();
          $right_indicator.hide();
        }

      }

      $elm.on('ps-scroll-x', function() {
        update_indicators();
      });
      update_indicators();

      $left_indicator.on('click', function(e) {
        e.preventDefault();
        $elm.stop().animate({
            scrollLeft: ps.lastScrollLeft - 500
        }, 500);
      });

      $right_indicator.on('click', function(e) {
        e.preventDefault();
        $elm.stop().animate({
            scrollLeft: ps.lastScrollLeft + 500
        }, 500);
      });
      $( window).resize(function() {
        $('.js-horizontal-scroll-container').each(function(i, elm) {
          ps.update();
        });
      });
    });
  })();

  if (location.hash !== '' && location.hash.startsWith('#agenda_tab_')) {
    $('.tab-pane.active .js-tab-content').hide();
    var agenda_id = location.hash.replace('#agenda_tab_','');
    $('a.js-agenda-theme-tab[data-toggle="tab"][data-agenda-id="' + agenda_id + '"]').tab('show');
  }

  $('.js-close-modal').click(function(){
    $($(this).closest('.modal')).modal('hide');
  });

  // 내 홈 탭
  $('.js-sticky-sign-button').each(function() {
    var sticky = new Waypoint.Sticky({
      element: $('.js-sticky-sign-button')[0],
      direction: 'up',
      offset: 'bottom-in-view'
    })
  });

  (function() {
    $('.js-campaign-time-to-left').each(function() {
      setInterval(update_campaign_time_laps, 1000);
    });

    function padding_zero(n) { if (n < 10) { return "0" + n } else return "" + n }

    function update_campaign_time_laps() {
      var elm = $('.js-campaign-time-to-left')
      var from = new Date($('.js-campaign-time-to-left').data('campaign-time-to-left-due-date').replace(/\s/, 'T') + "+09:00")
      var diff = Math.floor(Math.abs(from - (new Date())) / 1000)
      elm.find('.days')[0].innerHTML = Math.floor(diff / (24 * 3600))
      elm.find('.hours')[0].innerHTML = padding_zero(Math.floor((diff % (24 * 3600)) / 3600))
      elm.find('.minutes')[0].innerHTML = padding_zero(Math.floor((diff % 3600) / 60))
      elm.find('.seconds')[0].innerHTML = padding_zero(Math.floor(diff % 60))
    }
  })();

  //clipboard
  $('.js-clipboard').each(function() {
    var clipboard = new Clipboard(this);
    clipboard.on('success', function(e) {
      var $target = $(e.trigger);
      $target.tooltip('show');
      e.clearSelection();

      setTimeout(function() { $target.tooltip('hide'); }, 1000);
    });
  });

  (function() {
    $.each($('.js-tags-read-more'), function(index, elm) {
      var $elm = $(elm);
      var ORIGIN_HEIGHT = $elm.css('height');
      if(elm.scrollHeight > elm.clientHeight) {
        $elm.find('.js-tags-read-more-button').show();
      }

      $elm.find('.js-tags-read-more-button').on('click', function(e) {
        var mode = $elm.data('tags-read-more-mode');
        if(!mode || mode == 'collapse') {
          $elm.css('height', 'auto');
          $elm.data('tags-read-more-mode', 'extend');
          $(e.currentTarget).text('접어보기');
        } else {
          $elm.css('height', ORIGIN_HEIGHT);
          $elm.data('tags-read-more-mode', 'collapse');
          $(e.currentTarget).text('더 보기');
        }
      });
    });
  })();

});

//
// AJAX partial 로딩 된 콘텐츠에도 작동해야하는 동작들
//
$.parti_apply = function($base, query, callback) {
  $.each($base.find(query).addBack(query), function(i, elm){
    callback(elm);
  });
}

function parti_partial$($partial) {
  $partial.find('.js-infinite-container').each(function() {
    if ($(this).hasClass('masonry-container')) {
      var container = $('.masonry-container');
      console.log('container');
      console.log(container);
      new Waypoint.Infinite( {
        element: this,
        items: '.masonry-item',
        loadingClass: 'infinite-loading',
        onAfterPageLoad: function($items) {
          // parti_partial$($items);
          console.log('reload');
          console.log(container);
          container.masonry('reloadItems');
          container.masonry('layout');
        }
      });
    } else {
      new Waypoint.Infinite( {
        element: this,
        onAfterPageLoad: function($items) {
          parti_partial$($items);
        }
      });
    }
  });

  $.parti_apply($partial, '.js-popover', function(elm) {
    var $elm = $(elm);

    var options = {}
    var style = $elm.data('style');
    if(style) {
      options['style'] = style;
    }

    if($(elm).data('type') == 'async') {
      options['type'] = 'async';
    }

    $elm.webuiPopover(options);
  });

  $.parti_apply($partial, '.redactor', function(elm) {
    // Initialize Redactor
    $(elm).redactor({
      buttons: ['format', 'bold', 'italic', 'deleted', 'lists', 'image', 'file', 'link', 'horizontalrule'],
      callbacks: {
        imageUploadError: function(json, xhr) {
          UnobtrusiveFlash.showFlashMessage(json.error.data[0], {type: 'notice'})
        }
      },
      toolbarFixed: true,
      plugins: ['fontcolor', 'alignment']
    });
    $(elm).find('.redactor-editor').prop('contenteditable', true);
  });

  // 폼 검증
  $.parti_apply($partial, '.gov-action-form-validation', function(elm) {
    var $form = $(elm);

    var options = {
      ignore: ':hidden:not(.validate)',
      errorPlacement: function(error, $element) {
        error.insertAfter($element);
        $('.masonry-container').masonry();
      }
    };
    var $grecaptcha_control = $form.find('.gov-action-form-grecaptcha');
    if($grecaptcha_control.length > 0) {
      options['submitHandler'] = function (form) {
        var str_widget_id = $grecaptcha_control.data('grecaptcha_widget_id');
        if(typeof str_widget_id != 'undefined') {
          var widget_id = parseInt(str_widget_id, 10);
          if (grecaptcha.getResponse(widget_id)) {
            // 2) finally sending form data
            form.submit();
          }else{
            // 1) Before sending we must validate captcha
            grecaptcha.reset(widget_id);
            grecaptcha.execute(widget_id);
          }
        } else {
          form.submit();
        }
      }
    }

    $form.validate(options);
  });

  $.parti_apply($partial, '.share-box', function(elm) {
    var $elm = $(elm);
    $elm.jsSocials({
      // 윈도우 resize 할때 다시 로딩을 방지합니다.
      showLabel: false,
      showCount: false,

      shares: [{
          renderer: function() {
            var $result = $("<div>");

            var script = document.createElement("script");
            script.text = "(function(d, s, id) {var js, fjs = d.getElementsByTagName(s)[0]; if (d.getElementById(id)) return; js = d.createElement(s); js.id = id; js.src = \"//connect.facebook.net/ko_KR/sdk.js#xfbml=1&version=v2.3\"; fjs.parentNode.insertBefore(js, fjs); }(document, 'script', 'facebook-jssdk'));";
            $result.append(script);

            $("<div>").addClass("fb-share-button")
                .attr("data-layout", "button_count")
                .appendTo($result);

            return $result;
          }
        }, {
          renderer: function() {
            var $result = $("<div>");

            var script = document.createElement("script");
            script.text = "window.twttr=(function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],t=window.twttr||{};if(d.getElementById(id))return t;js=d.createElement(s);js.id=id;js.src=\"https://platform.twitter.com/widgets.js\";fjs.parentNode.insertBefore(js,fjs);t._e=[];t.ready=function(f){t._e.push(f);};return t;}(document,\"script\",\"twitter-wjs\"));";
            $result.append(script);

            $("<a>").addClass("twitter-share-button")
                .text("Tweet")
                .attr("href", "https://twitter.com/share")
                .appendTo($result);

            return $result;
          }
        }, {
          image_url: $elm.data('shareImage'),
          renderer: function(options) {
            var md = new MobileDetect(window.navigator.userAgent);
            if(!md.mobile()) {
              return;
            }
            if(!this.image_url) {
              return;
            }
            var $result = $("<div class='kakao-share-button'><span class='kakao-share-button--label'>카카오톡</span></div>");

            var url = this.url;
            var text = this.text;
            var image_url = this.image_url;
            var image_width = '300';
            var image_height = '155';

            Kakao.Link.createTalkLinkButton({
              container: $result[0],
              label: text,
              image: {
                src: image_url,
                width: image_width,
                height: image_height
              },
              webLink: {
                text: '빠띠 캠페인즈에서 보기',
                url: url
              }
            });

            return $result;
          }
        }
      ]
    });
  });

  if(!$(document).is($partial)) {
    $(document).trigger('govcraft-grecaptcha-for-partial', $partial);
  }
}

$(function(){
  $(document).on('change', '.js-select-link', function(e) {
    var $selected_option = $(e.currentTarget).find('option:selected');
    var url = $selected_option.data('url');
    if(url) {
      var remote = $(e.currentTarget).data('select-link-remote');
      if(remote) {
        $.ajax({
          url: url,
          type: "get"
        });
      } else {
        location.href = url;
      }
    }
  });

  parti_partial$($(document));
});

$(function(){
  $(".js-checkbox-signup-all").change(function(e) {
    e.preventDefault();
    var checkboxState = e.target.checked;
    $(".js-checkbox-signup").prop("checked", checkboxState);
  });

  $(".js-checkbox-signup").on('change', function(e) {
    e.preventDefault();
    // validate(e);

    var $elm = $(e.currentTarget);
    var $form = $elm.closest('form');
    var totalLength = $form.find('.js-checkbox-signup').length;
    var uncheckd_confirm = $form.find('.js-checkbox-signup:checked').length;
    $form.find(".js-checkbox-signup-all").prop("checked", totalLength == uncheckd_confirm);
  });

  $(".js-confirm_third_party").on('change', function(e) {
    e.preventDefault();
    var isChecked = e.target.checked;
    if(isChecked){
      $(".js-confirm_third_party-help").removeClass("hidden");
    }else{
      $(".js-confirm_third_party-help").addClass("hidden");
    }
  });
});

$(function() {
  $("#js-notice-button-close").click(function() {
    Cookies.set("skip_notice", "Y", { expires: 60 })
  })
});


$(document).ajaxError(function (e, xhr, settings) {
  if(xhr.status == 500) {
    UnobtrusiveFlash.showFlashMessage('뭔가 잘못되었습니다. 곧 고치겠습니다.', {type: 'error'})
  } else if(xhr.status == 404) {
    UnobtrusiveFlash.showFlashMessage('어머나! 누가 지웠네요. 페이지를 새로 고쳐보세요.', {type: 'notice'})
  } else if(xhr.status == 401) {
    UnobtrusiveFlash.showFlashMessage('먼저 로그인해 주세요.', {type: 'notice'})
  }
});
