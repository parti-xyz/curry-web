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
//= require sticky
//= require infinite

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
  $('.masonry-container').masonry();
  // Initialize Redactor
  $('.redactor').redactor({
    buttons: ['format', 'bold', 'italic', 'deleted', 'lists', 'image', 'file', 'link', 'horizontalrule'],
    callbacks: {
      imageUploadError: function(json, xhr) {
        UnobtrusiveFlash.showFlashMessage(json.error.data[0], {type: 'notice'})
      }
    },
    toolbarFixed: true,
    plugins: ['fontcolor', 'alignment']
  });
  $('.redactor .redactor-editor').prop('contenteditable', true);
  $('select.dropdown').dropdown();
});

// Kakao Key
Kakao.init('6a30dead1bff1ef43b7e537f49d2f655');

$(function(){
  $(".slick").slick();

  $("#js-campaign-confirm-privacy").click(function(){
    $("#js-campaign-confirm-privacy-body").toggle();
  })

  $(".js-published_at").datetimepicker({
    format: 'YYYY-MM-DD'
  });

  $( ".js-organization-area" ).hover(
    function() {
      $( this ).find(".desc").toggle();
    }
  );

  $('.share-box').each(function(i, elm) {
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
                text: '우주당에서 보기',
                url: url
              }
            });

            return $result;
          }
        }
      ]
    });
  });

  $('.js-top-menu i').click(function(){
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

  // 폼 검증
  $('.gov-action-form-validation').each(function(i, elm) {
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
        console.log("========");
        console.log(str_widget_id);
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

  $('.gov-action-sidbar').on('click', function(e) {
    $('#site-sidebar').sidebar('toggle');
  });

  $('.js-popover').each(function(i, elm) {
    var $elm = $(elm);

    var options = {}
    var style = $elm.data('style');
    if(style) {
      options['style'] = style;
    }

    $elm.webuiPopover(options);
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
  if($('.js-sticky-sign-button').length > 0){
    var sticky = new Waypoint.Sticky({
      element: $('.js-sticky-sign-button')[0],
      direction: 'up',
      offset: 'bottom-in-view'
    })
  }

  if ($('.js-infinite-container').length > 0) {
    var infinite = new Waypoint.Infinite( { element: $('.js-infinite-container')[0] } );
  }

  if ($('#CommentTarget').length > 0) {
    $('#CommentTarget').change(
      function() {
        var target = this.value
        if (target == "") {
          $('#comment .comment').filter(
            function() {
              $(this).toggle(true)
            }
          )
        } else {
          $('#comment .comment').filter(
            function() {
              if (this.children['filter-agents']) {
                $(this).toggle(
                  JSON.parse(
                    this.children['filter-agents'].value
                  ).indexOf(target) > -1
                )
              } else {
                $(this).toggle(false)
              }
            }
          )
        }
      }
    )
  }

  $('.js-order-by-recent').click(function () {
    comments = $('#comment .comments').children('.comment').get()
    comments.sort(function(a, b) {
      return b.children['sort-date'].value - a.children['sort-date'].value
    })
    $.each(comments, function(i,x) { $('#comment .comments').append(x) })
    $('.js-order-by-recent').css('color', '#303030')
    $('.js-order-by-recent').css('font-weight', '500')
    $('.js-order-by-like-count').css('color', '#aaaaaa')
    $('.js-order-by-like-count').css('font-weight', 'initial')
  })

  $('.js-order-by-like-count').click(function () {
    comments = $('#comment .comments').children('.comment').get()
    comments.sort(function(a, b) {
      return b.children['sort-like'].value - a.children['sort-like'].value
    })
    $.each(comments, function(i,x) { $('#comment .comments').append(x) })
    $('.js-order-by-like-count').css('color', '#303030')
    $('.js-order-by-like-count').css('font-weight', '500')
    $('.js-order-by-recent').css('color', '#aaaaaa')
    $('.js-order-by-recent').css('font-weight', 'initial')
  })

  $('.js-my-comment').click(function() {
    $.ajax({
      url: 'http://govcraft.test/comments?commentable_id=79&commentable_type=Campaign&page=1&test=signs&comment_user_id=997'
    }).done(function(data) {
      comments = $('.infinite-item', data).get()
      $.each($('#comment .comment').get(), function(i,x) { x.remove() })
      $.each(comments, function(i,x) { $('#comment .comments').append(x) })
    })
  })

  if ($('.js-campaign-time-to-left').length > 0) {
    setInterval(function() {
      var format = function(n) { if (n < 10) {return "0" + n} else return "" + n }
      var diff = Math.floor(Math.abs(campaign_due_date - (new Date())) / 1000)
      $('.js-campaign-time-to-left .days')[0].innerHTML = Math.floor(diff / (24 * 3600))
      $('.js-campaign-time-to-left .hours')[0].innerHTML = format(Math.floor((diff % (24 * 3600)) / 3600))
      $('.js-campaign-time-to-left .minutes')[0].innerHTML = format(Math.floor((diff % 3600) / 60))
      $('.js-campaign-time-to-left .seconds')[0].innerHTML = format(Math.floor(diff % 60))
    }, 1000)
  }

  $(document).ready(function(){
    $('[data-toggle="popover"]').popover();
  });

});

function copy_campaign_url() {
  if ($('#share-url').length > 0) {
    var elm = document.createElement('textarea')
    elm.textContent = $('#share-url')[0].value
    elm.style.width = 0
    elm.style.height = 0
    $('body').append(elm)
    elm.select()
    document.execCommand('copy')
    elm.remove()
  }
}

function no_op() {}


$(document).ajaxError(function (e, xhr, settings) {
  if(xhr.status == 500) {
    UnobtrusiveFlash.showFlashMessage('뭔가 잘못되었습니다. 곧 고치겠습니다.', {type: 'error'})
  } else if(xhr.status == 404) {
    UnobtrusiveFlash.showFlashMessage('어머나! 누가 지웠네요. 페이지를 새로 고쳐보세요.', {type: 'notice'})
  } else if(xhr.status == 401) {
    UnobtrusiveFlash.showFlashMessage('먼저 로그인해 주세요.', {type: 'notice'})
  }
});
