/**
 * Kakao Javascript SDK for Kakao Open Platform Service - v1.39.8
 *
 * Copyright 2017 Kakao Corp.
 *
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *
 *
 * OSS Notice | KakaoSDK-Javascript
 *
 * This application is Copyright © Kakao Corp. All rights reserved.
 * The following sets forth attribution notices for third party software that may be contained in this application.
 * If you have any questions or concerns, please contact us at opensource@kakaocorp.com
 *
 *
 *  crypto-js
 *
 * https://github.com/brix/crypto-js
 *
 * Copyright 2009-2013 Jeff Mott
 * Copyright 2013-2016 Evan Vosberg
 *
 * MIT License
 *
 *
 *  easyXDM
 *
 * https://github.com/oyvindkinsey/easyXDM/
 *
 * Copyright 2009-2011 Øyvind Sean Kinsey, oyvind@kinsey.no
 *
 * MIT License
 *
 *
 *  ES6-Promise
 *
 * https://github.com/stefanpenner/es6-promise
 *
 * Copyright 2014 Yehuda Katz, Tom Dale, Stefan Penner and contributors
 *
 * MIT License
 *
 *
 *  Underscore
 *
 * https://github.com/jashkenas/underscore
 *
 * Copyright 2009-2017 Jeremy Ashkenas, DocumentCloud and Investigative Reporters & Editors
 *
 * MIT License
 *
 *
 *  Web2App Library
 *
 * https://github.com/kakao/web2app
 *
 * Copyright 2015 Kakao Corp. http://www.kakaocorp.com
 *
 * MIT License
 *
 *
 * ``````````
 * MIT License
 *
 * Copyright (c) <year> <copyright holders>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * ``````````
 */
var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

(function (f) {
  if ((typeof exports === "undefined" ? "undefined" : _typeof(exports)) === "object" && typeof module !== "undefined") {
    module.exports = f();
  } else if (typeof define === "function" && define.amd) {
    define([], f);
  } else {
    var g; if (typeof window !== "undefined") {
      g = window;
    } else if (typeof global !== "undefined") {
      g = global;
    } else if (typeof self !== "undefined") {
      g = self;
    } else {
      g = this;
    } g.Kakao = f();
  }
})(function () {
  var define, module, exports; return function () {
    function r(e, n, t) {
      function o(i, f) {
        if (!n[i]) {
          if (!e[i]) {
            var c = "function" == typeof require && require; if (!f && c) return c(i, !0); if (u) return u(i, !0); var a = new Error("Cannot find module '" + i + "'"); throw a.code = "MODULE_NOT_FOUND", a;
          } var p = n[i] = { exports: {} }; e[i][0].call(p.exports, function (r) {
            var n = e[i][1][r]; return o(n || r);
          }, p, p.exports, r, e, n, t);
        } return n[i].exports;
      } for (var u = "function" == typeof require && require, i = 0; i < t.length; i++) {
        o(t[i]);
      } return o;
    } return r;
  }()({
    1: [function (require, module, exports) {
      var process = module.exports = {};


      var cachedSetTimeout;
      var cachedClearTimeout;

      function defaultSetTimout() {
        throw new Error('setTimeout has not been defined');
      }
      function defaultClearTimeout() {
        throw new Error('clearTimeout has not been defined');
      }
      (function () {
        try {
          if (typeof setTimeout === 'function') {
            cachedSetTimeout = setTimeout;
          } else {
            cachedSetTimeout = defaultSetTimout;
          }
        } catch (e) {
          cachedSetTimeout = defaultSetTimout;
        }
        try {
          if (typeof clearTimeout === 'function') {
            cachedClearTimeout = clearTimeout;
          } else {
            cachedClearTimeout = defaultClearTimeout;
          }
        } catch (e) {
          cachedClearTimeout = defaultClearTimeout;
        }
      })();
      function runTimeout(fun) {
        if (cachedSetTimeout === setTimeout) {
          return setTimeout(fun, 0);
        }
        if ((cachedSetTimeout === defaultSetTimout || !cachedSetTimeout) && setTimeout) {
          cachedSetTimeout = setTimeout;
          return setTimeout(fun, 0);
        }
        try {
          return cachedSetTimeout(fun, 0);
        } catch (e) {
          try {
            return cachedSetTimeout.call(null, fun, 0);
          } catch (e) {
            return cachedSetTimeout.call(this, fun, 0);
          }
        }
      }
      function runClearTimeout(marker) {
        if (cachedClearTimeout === clearTimeout) {
          return clearTimeout(marker);
        }
        if ((cachedClearTimeout === defaultClearTimeout || !cachedClearTimeout) && clearTimeout) {
          cachedClearTimeout = clearTimeout;
          return clearTimeout(marker);
        }
        try {
          return cachedClearTimeout(marker);
        } catch (e) {
          try {
            return cachedClearTimeout.call(null, marker);
          } catch (e) {
            return cachedClearTimeout.call(this, marker);
          }
        }
      }
      var queue = [];
      var draining = false;
      var currentQueue;
      var queueIndex = -1;

      function cleanUpNextTick() {
        if (!draining || !currentQueue) {
          return;
        }
        draining = false;
        if (currentQueue.length) {
          queue = currentQueue.concat(queue);
        } else {
          queueIndex = -1;
        }
        if (queue.length) {
          drainQueue();
        }
      }

      function drainQueue() {
        if (draining) {
          return;
        }
        var timeout = runTimeout(cleanUpNextTick);
        draining = true;

        var len = queue.length;
        while (len) {
          currentQueue = queue;
          queue = [];
          while (++queueIndex < len) {
            if (currentQueue) {
              currentQueue[queueIndex].run();
            }
          }
          queueIndex = -1;
          len = queue.length;
        }
        currentQueue = null;
        draining = false;
        runClearTimeout(timeout);
      }

      process.nextTick = function (fun) {
        var args = new Array(arguments.length - 1);
        if (arguments.length > 1) {
          for (var i = 1; i < arguments.length; i++) {
            args[i - 1] = arguments[i];
          }
        }
        queue.push(new Item(fun, args));
        if (queue.length === 1 && !draining) {
          runTimeout(drainQueue);
        }
      };

      function Item(fun, array) {
        this.fun = fun;
        this.array = array;
      }
      Item.prototype.run = function () {
        this.fun.apply(null, this.array);
      };
      process.title = 'browser';
      process.browser = true;
      process.env = {};
      process.argv = [];
      process.version = '';
      process.versions = {};

      function noop() { }

      process.on = noop;
      process.addListener = noop;
      process.once = noop;
      process.off = noop;
      process.removeListener = noop;
      process.removeAllListeners = noop;
      process.emit = noop;
      process.prependListener = noop;
      process.prependOnceListener = noop;

      process.listeners = function (name) {
        return [];
      };

      process.binding = function (name) {
        throw new Error('process.binding is not supported');
      };

      process.cwd = function () {
        return '/';
      };
      process.chdir = function (dir) {
        throw new Error('process.chdir is not supported');
      };
      process.umask = function () {
        return 0;
      };
    }, {}], 2: [function (require, module, exports) {
      (function (setImmediate, clearImmediate) {
        var nextTick = require('process/browser.js').nextTick;
        var apply = Function.prototype.apply;
        var slice = Array.prototype.slice;
        var immediateIds = {};
        var nextImmediateId = 0;


        exports.setTimeout = function () {
          return new Timeout(apply.call(setTimeout, window, arguments), clearTimeout);
        };
        exports.setInterval = function () {
          return new Timeout(apply.call(setInterval, window, arguments), clearInterval);
        };
        exports.clearTimeout = exports.clearInterval = function (timeout) {
          timeout.close();
        };

        function Timeout(id, clearFn) {
          this._id = id;
          this._clearFn = clearFn;
        }
        Timeout.prototype.unref = Timeout.prototype.ref = function () { };
        Timeout.prototype.close = function () {
          this._clearFn.call(window, this._id);
        };

        exports.enroll = function (item, msecs) {
          clearTimeout(item._idleTimeoutId);
          item._idleTimeout = msecs;
        };

        exports.unenroll = function (item) {
          clearTimeout(item._idleTimeoutId);
          item._idleTimeout = -1;
        };

        exports._unrefActive = exports.active = function (item) {
          clearTimeout(item._idleTimeoutId);

          var msecs = item._idleTimeout;
          if (msecs >= 0) {
            item._idleTimeoutId = setTimeout(function onTimeout() {
              if (item._onTimeout) item._onTimeout();
            }, msecs);
          }
        };

        exports.setImmediate = typeof setImmediate === "function" ? setImmediate : function (fn) {
          var id = nextImmediateId++;
          var args = arguments.length < 2 ? false : slice.call(arguments, 1);

          immediateIds[id] = true;

          nextTick(function onNextTick() {
            if (immediateIds[id]) {
              if (args) {
                fn.apply(null, args);
              } else {
                fn.call(null);
              }
              exports.clearImmediate(id);
            }
          });

          return id;
        };

        exports.clearImmediate = typeof clearImmediate === "function" ? clearImmediate : function (id) {
          delete immediateIds[id];
        };
      }).call(this, require("timers").setImmediate, require("timers").clearImmediate);
    }, { "process/browser.js": 1, "timers": 2 }], 3: [function (require, module, exports) {
      module.exports = function () {
        var authSecret = require('../Auth/secret');

        function accessToken() {
          return "Bearer " + authSecret.getAccessToken();
        }

        function appKey() {
          return "KakaoAK " + authSecret.getAppKey();
        }

        return {
          accessToken: accessToken,
          appKey: appKey,
          tokenOrKey: authSecret.getAccessToken() ? accessToken : appKey
        };
      }();
    }, { "../Auth/secret": 16 }], 4: [function (require, module, exports) {
      module.exports = function () {
        var _k = require('../common');

        var API = {};
        var cleanups = [];

        _k.initSubModules(API, [require('./request')(cleanups)]);

        API.cleanup = function () {
          _k.emptyCleanups(cleanups);
        };

        return API;
      }();
    }, { "../common": 19, "./request": 5 }], 5: [function (require, module, exports) {
      module.exports = function (cleanups) {
        require('../../vendor/es6-promise');
        var _easyXDM = require('../../vendor/easyXDM');
        var _ = require('../util');
        var _k = require('../common');

        var rules = require('./rules');
        var authType = require('./authType');

        var proxyForRequest = null;
        function request(settings) {
          settings = _k.processRules(settings, rules.request, 'API.request');

          var url = settings.url;
          var urlRule = rules.api[url].data;
          if (urlRule) {
            settings.data = _k.processRules(settings.data, urlRule, "API.request - " + url);
          }

          if (!proxyForRequest) {
            proxyForRequest = getProxy();

            cleanups.push(function () {
              proxyForRequest.destroy();
              proxyForRequest = null;
            });
          }

          return new Promise(function (resolve, reject) {
            getConfig(settings).then(function (config) {
              proxyForRequest.request(config, function (res) {
                settings.success(res);
                settings.always(res);

                resolve(res);
              }, function (xdmError) {
                var error = parseXdmError(xdmError);
                settings.fail(error);
                settings.always(error);

                reject(error);
              });
            }, function (error) {
              reject(error);
            });
          });
        }

        function getProxy() {
          return _k.guardCreateEasyXDM(function () {
            return new _easyXDM.Rpc({
              remote: _k.URL.apiRemote
            }, {
              remote: {
                request: {}
              }
            });
          });
        }

        function parseXdmError(xdmError) {
          try {
            _k.logDebug(xdmError);

            return JSON.stringify(xdmError.message.responseText);
          } catch (e) {
            return {
              code: -777,
              msg: 'Unknown error'
            };
          }
        }

        function getConfig(settings) {
          var url = settings.url;

          var urlSpec = rules.api[url];

          var stringifiedData = {};
          _.each(settings.data, function (value, key) {
            stringifiedData[key] = _.isString(value) ? value : JSON.stringify(value);
          });

          var config = {
            url: url,
            method: urlSpec.method,
            headers: {
              KA: _k.KAKAO_AGENT,
              Authorization: (urlSpec.authType || authType.accessToken)(),
              'Cache-Control': 'no-cache',
              Pragma: 'no-cache'
            },
            data: stringifiedData
          };

          return new Promise(function (resolve, reject) {
            if (isFileRequired(url) || settings.data.file) {
              var files = settings.files || settings.data.file;
              if (!files) {
                throw new _k.KakaoError("'files' parameter should be set for " + url);
              }

              getFileConfig(files).then(function (fileConfig) {
                var searchParams = [];
                for (var prop in stringifiedData) {
                  if (prop !== 'file') {
                    searchParams.push(prop + "=" + encodeURIComponent(stringifiedData[prop]));
                  }
                }

                if (searchParams.length > 0) {
                  config.url += "?" + searchParams.join('&');
                }

                config.file = fileConfig;
                resolve(config);
              }, function (error) {
                reject(error);
              });
            } else {
              resolve(config);
            }
          });
        }

        function isFileRequired(url) {
          return url === '/v1/api/story/upload/multi' || url === '/v2/api/talk/message/image/upload';
        }

        function getFileConfig(files) {
          var serializePromises = _.map(files, function (file) {
            return _k.serializeFile(file).then(function (serialized) {
              return {
                name: file.name,
                type: file.type,
                str: serialized
              };
            });
          });

          return new Promise(function (resolve, reject) {
            Promise.all(serializePromises).then(function (serializedFiles) {
              resolve({
                paramName: 'file',
                data: serializedFiles
              });
            }, function (error) {
              reject(error);
            });
          });
        }

        return {
          request: request
        };
      };
    }, { "../../vendor/easyXDM": 31, "../../vendor/es6-promise": 32, "../common": 19, "../util": 28, "./authType": 3, "./rules": 6 }], 6: [function (require, module, exports) {
      module.exports = function () {
        var _ = require('../util');
        var authType = require('./authType');

        var postApiCommonParams = {
          permission: _.isOneOf(['A', 'F', 'M']),
          enable_share: _.isBoolean,
          android_exec_param: _.isString,
          ios_exec_param: _.isString,
          android_market_param: _.isString,
          ios_market_param: _.isString
        };

        var secureResource = {
          secure_resource: _.isBoolean
        };

        function storyActivityContentValidator(obj) {
          if (!_.isString(obj)) {
            return false;
          }

          if (obj.length === 0 || obj.length > 2048) {
            throw new _k.KakaoError('content length should be between 0 and 2048');
          }

          return true;
        }

        function kageImageUrlListValidator(obj) {
          if (!_.isArray(obj)) {
            return false;
          }

          return _.every(obj, function (path) {
            if (!_.isString(path)) {
              return false;
            }

            if (_.isURL(path)) {
              throw new _k.KakaoError("url in image_url_list should be a kage url, obtained from '/v1/api/story/upload/multi'.");
            }

            return true;
          });
        }

        function hasHeaderBackgroundImage(obj) {
          if (obj.header_image_url || obj.header_image_width || obj.header_image_height) {
            delete obj.header_image_url;
            delete obj.header_image_width;
            delete obj.header_image_height;

            if (console) {
              var params = ['header_image_url', 'header_image_width', 'header_image_height'];
              console.warn("KakaoWarning: The parameters (" + params.join(', ') + ") for header background image are deprecated.");
            }
          }

          return true;
        }

        var rules = {
          request: {
            required: {
              url: function url(_url) {
                return _.isOneOf(_.keys(rules.api))(_url);
              }
            },
            optional: {
              data: _.isObject,
              files: function files(obj) {
                return _.passesOneOf([_.isArray, _.isFileList])(obj) && _.every(obj, _.passesOneOf([_.isFile, _.isBlob]));
              },

              file: _.isFile,
              success: _.isFunction,
              fail: _.isFunction,
              always: _.isFunction
            },
            defaults: {
              data: {},
              success: _.emptyFunc,
              fail: _.emptyFunc,
              always: _.emptyFunc
            }
          },
          api: {
            '/v1/user/signup': {
              method: 'post',
              data: {
                optional: {
                  properties: _.isObject
                }
              }
            },
            '/v1/user/unlink': {
              method: 'post'
            },
            '/v2/user/me': {
              method: 'get',
              data: {
                optional: _.extend({
                  property_keys: _.isArray
                }, secureResource)
              }
            },
            '/v1/user/logout': {
              method: 'post',
              data: {}
            },
            '/v1/user/update_profile': {
              method: 'post',
              data: {
                required: { properties: _.isObject }
              }
            },

            '/v1/api/talk/profile': {
              method: 'get',
              data: {
                optional: secureResource
              }
            },
            '/v1/api/talk/memo/send': {
              method: 'post',
              data: {
                required: {
                  template_id: _.passesOneOf([_.isNumber, _.isString])
                },
                optional: {
                  args: _.isString
                }
              }
            },
            '/v2/api/talk/memo/send': {
              method: 'post',
              data: {
                required: {
                  template_id: _.isNumber
                },
                optional: {
                  args: _.isString
                }
              }
            },
            '/v2/api/talk/memo/scrap/send': {
              method: 'post',
              data: {
                required: {
                  request_url: _.isString
                },
                optional: {
                  template_id: _.isNumber,
                  template_args: _.isObject
                }
              }
            },
            '/v2/api/talk/memo/default/send': {
              method: 'post',
              data: {
                required: {
                  template_object: function template_object(obj) {
                    return _.isObject(obj) && hasHeaderBackgroundImage(obj);
                  }
                }
              }
            },

            '/v1/api/story/profile': {
              method: 'get',
              data: {
                optional: secureResource
              }
            },
            '/v1/api/story/isstoryuser': {
              method: 'get'
            },
            '/v1/api/story/mystory': {
              method: 'get',
              data: {
                required: {
                  id: _.isString
                }
              }
            },
            '/v1/api/story/mystories': {
              method: 'get',
              data: {
                optional: {
                  last_id: _.isString
                }
              }
            },
            '/v1/api/story/linkinfo': {
              method: 'get',
              data: {
                required: {
                  url: _.isString
                }
              }
            },
            '/v1/api/story/post/note': {
              method: 'post',
              data: {
                required: {
                  content: storyActivityContentValidator
                },
                optional: postApiCommonParams
              }
            },
            '/v1/api/story/post/photo': {
              method: 'post',
              data: {
                required: {
                  image_url_list: kageImageUrlListValidator
                },
                optional: _.extend({
                  content: storyActivityContentValidator
                }, postApiCommonParams)
              }
            },
            '/v1/api/story/post/link': {
              method: 'post',
              data: {
                required: {
                  link_info: _.isObject
                },
                optional: _.extend({
                  content: storyActivityContentValidator
                }, postApiCommonParams)
              }
            },
            '/v1/api/story/upload/multi': {
              method: 'post',
              data: {}
            },
            '/v1/emoticon/my_items': {
              method: 'get',
              data: {},
              authType: authType.appKey
            },
            '/v1/emoticon/item_resources': {
              method: 'get',
              data: {
                required: {
                  id: _.isString
                }
              },
              authType: authType.appKey
            },
            '/v1/api/story/delete/mystory': {
              method: 'delete',
              data: {
                required: {
                  id: _.isString
                }
              }
            },

            '/v2/emoticon/items': {
              method: 'get',
              authType: authType.tokenOrKey
            },
            '/v2/emoticon/item': {
              method: 'get',
              data: {
                required: {
                  id: _.passesOneOf([_.isNumber, _.isString])
                }
              },
              authType: authType.tokenOrKey
            },
            '/v2/emoticon/item_resources': {
              method: 'get',
              authType: authType.tokenOrKey
            },
            '/v2/emoticon/item_resource': {
              method: 'get',
              data: {
                required: {
                  id: _.passesOneOf([_.isNumber, _.isString])
                }
              },
              authType: authType.tokenOrKey
            },

            '/v2/api/kakaolink/talk/template/validate': {
              method: 'get',
              data: {
                required: {
                  link_ver: _.isString,
                  template_id: _.isNumber
                },
                optional: {
                  template_args: _.isObject
                }
              },
              authType: authType.appKey
            },
            '/v2/api/kakaolink/talk/template/scrap': {
              method: 'get',
              data: {
                required: {
                  link_ver: _.isString,
                  request_url: _.isString
                },
                optional: {
                  template_id: _.isNumber,
                  template_args: _.isObject
                }
              },
              authType: authType.appKey
            },
            '/v2/api/kakaolink/talk/template/default': {
              method: 'get',
              data: {
                required: {
                  link_ver: _.isString,
                  template_object: _.isObject
                }
              },
              authType: authType.appKey
            },
            '/v1/user/access_token_info': {
              method: 'get',
              data: {}
            },
            '/v2/api/talk/message/image/upload': {
              method: 'post',
              data: {
                required: {
                  file: _.isObject
                }
              },
              authType: authType.appKey
            },
            '/v2/api/talk/message/image/delete': {
              method: 'delete',
              data: {
                required: {
                  image_url: _.isString
                }
              },
              authType: authType.appKey
            },
            '/v2/api/talk/message/image/scrap': {
              method: 'post',
              data: {
                required: {
                  image_url: _.isString
                }
              },
              authType: authType.appKey
            },
            '/v1/vision/face/detect': {
              method: 'post',
              data: {
                optional: {
                  file: _.isObject,
                  image_url: _.isString,
                  threshold: _.isNumber
                }
              },
              authType: authType.appKey
            },
            '/v1/vision/product/detect': {
              method: 'post',
              data: {
                optional: {
                  file: _.isObject,
                  image_url: _.isString,
                  threshold: _.isNumber
                }
              },
              authType: authType.appKey
            },
            '/v1/vision/thumbnail/crop': {
              method: 'post',
              data: {
                required: {
                  width: _.isInteger,
                  height: _.isInteger
                },
                optional: {
                  file: _.isObject,
                  image_url: _.isString
                }
              },
              authType: authType.appKey
            },
            '/v1/vision/thumbnail/detect': {
              method: 'post',
              data: {
                required: {
                  width: _.isInteger,
                  height: _.isInteger
                },
                optional: {
                  file: _.isObject,
                  image_url: _.isString
                }
              },
              authType: authType.appKey
            },
            '/v1/vision/multitag/generate': {
              method: 'post',
              data: {
                optional: {
                  file: _.isObject,
                  image_url: _.isString
                }
              },
              authType: authType.appKey
            },
            '/v1/vision/adult/detect': {
              method: 'post',
              data: {
                optional: {
                  file: _.isObject,
                  image_url: _.isString
                }
              },
              authType: authType.appKey
            },
            '/v1/vision/text/detect': {
              method: 'post',
              data: {
                optional: {
                  file: _.isObject
                }
              },
              authType: authType.appKey
            },
            '/v1/vision/text/recognize': {
              method: 'post',
              data: {
                optional: {
                  file: _.isObject,
                  boxes: _.passesOneOf([_.isString, _.isArray])
                }
              },
              authType: authType.appKey
            },
            '/v1/translation/translate': {
              method: 'post',
              data: {
                required: {
                  query: _.isString,
                  src_lang: _.isString,
                  target_lang: _.isString
                }
              },
              authType: authType.appKey
            },
            '/v1/friends': {
              method: 'get',
              data: {
                optional: _.extend({
                  offset: _.isNumber,
                  limit: _.isNumber,
                  order: _.isString,
                  friend_order: _.isString
                }, secureResource)
              }
            },
            '/v1/user/service/terms': {
              method: 'get'
            },
            '/v1/api/talk/plusfriends': {
              method: 'get',
              data: {
                optional: {
                  plus_friend_public_ids: _.isArray
                }
              }
            },
            '/v1/user/shipping_address': {
              method: 'get',
              data: {
                optional: {
                  address_id: _.isNumber,
                  from_updated_at: _.isNumber,
                  page_size: _.isNumber
                }
              }
            },
            '/v1/api/talk/friends': {
              method: 'get',
              data: {
                optional: _.extend({
                  offset: _.isNumber,
                  limit: _.isNumber,
                  order: _.isString
                }, secureResource)
              }
            },
            '/v1/api/talk/friends/message/send': {
              method: 'post',
              data: {
                required: {
                  template_id: _.isNumber,
                  receiver_uuids: _.isArray,
                  receiver_id_type: _.isString
                },
                optional: {
                  template_args: _.isObject
                },
                defaults: function defaults() {
                  return {
                    receiver_id_type: 'uuid'
                  };
                }
              }
            },
            '/v1/api/talk/friends/message/scrap/send': {
              method: 'post',
              data: {
                required: {
                  request_url: _.isString,
                  receiver_uuids: _.isArray,
                  receiver_id_type: _.isString
                },
                optional: {
                  template_id: _.isNumber,
                  template_args: _.isObject
                },
                defaults: function defaults() {
                  return {
                    receiver_id_type: 'uuid'
                  };
                }
              }
            },
            '/v1/api/talk/friends/message/default/send': {
              method: 'post',
              data: {
                required: {
                  template_object: function template_object(obj) {
                    return _.isObject(obj) && hasHeaderBackgroundImage(obj);
                  },

                  receiver_uuids: _.isArray,
                  receiver_id_type: _.isString
                },
                defaults: function defaults() {
                  return {
                    receiver_id_type: 'uuid'
                  };
                }
              }
            }
          }
        };

        return rules;
      }();
    }, { "../util": 28, "./authType": 3 }], 7: [function (require, module, exports) {
      module.exports = function () {
        function checkAuthorize(url, onResponse) {
          request({
            method: 'GET',
            url: url
          }, onResponse);
        }

        function getToken(url, data, onResponse) {
          request({
            method: 'POST',
            url: url,
            data: data
          }, onResponse);
        }

        function request(req, onResponse) {
          var url = req.url,
            method = req.method,
            data = req.data;


          var xhr = new XMLHttpRequest();
          if (typeof xhr.withCredentials !== 'undefined') {
            xhr.open(method, url);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function () {
              if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
                onResponse(xhr);
              }
            };

            xhr.send(data);
          } else {
            var xdr = new XDomainRequest();
            xdr.open(method.toLowerCase(), url);
            xdr.onload = function () {
              onResponse({
                status: xdr.responseText ? 200 : 'error',
                response: xdr.responseText
              });
            };

            setTimeout(function () {
              xdr.send(data);
            }, 0);
          }
        }

        return {
          checkAuthorize: checkAuthorize
        };
      }();
    }, {}], 8: [function (require, module, exports) {
      module.exports = function () {
        var _ = require('../util');
        var _k = require('../common');

        function openLoginPopup(url) {
          var LOGIN_POPUP_NAME = '_blank';
          return _k.windowOpen(url, LOGIN_POPUP_NAME, getLoginPopupFeatures());
        }

        function getLoginPopupFeatures() {
          var popupWidth = 480;
          var popupHeight = 700;

          var sLeft = window.screenLeft ? window.screenLeft : window.screenX ? window.screenX : 0;
          var sTop = window.screenTop ? window.screenTop : window.screenY ? window.screenY : 0;
          var popupLeft = screen.width / 2 - popupWidth / 2 + sLeft;
          var popupTop = screen.height / 2 - popupHeight / 2 + sTop;

          return ["width=" + popupWidth, "height=" + popupHeight, "left=" + popupLeft, "top=" + popupTop, 'scrollbars=yes', 'resizable=1'].join(',');
        }

        function makeAuthUrl(params) {
          return _k.URL.authorize + "?" + _.buildQueryString(params);
        }

        function makeAuthParams(settings) {
          var params = {
            client_id: _k.RUNTIME.appKey
          };

          if (settings.approvalType) {
            params['approval_type'] = settings.approvalType;
          }
          if (settings.scope) {
            params['scope'] = settings.scope;
          }
          if (settings.state) {
            params['state'] = settings.state;
          }

          return params;
        }

        function makeAuthExtraParams(settings) {
          var params = {};

          if (settings.plusFriendPublicId) {
            params['extra.plus_friend_public_id'] = settings.plusFriendPublicId;
          }
          if (settings.channelPublicId) {
            params['channel_public_id'] = settings.channelPublicId;
          }
          if (settings.serviceTerms) {
            params['extra.service_terms'] = settings.serviceTerms;
          }
          if (settings.autoLogin) {
            params['auto_login'] = settings.autoLogin;
          }
          if (settings.deviceType) {
            params['device_type'] = settings.deviceType;
          }

          return params;
        }

        function runAuthCallback(settings, resp) {
          _k.logDebug(resp);

          if (resp.error) {
            settings.fail(resp);
            settings.always(resp);
          } else {
            settings.success(resp);
            settings.always(resp);
          }
        }

        return {
          openLoginPopup: openLoginPopup,
          makeAuthUrl: makeAuthUrl,
          makeAuthParams: makeAuthParams,
          makeAuthExtraParams: makeAuthExtraParams,
          runAuthCallback: runAuthCallback
        };
      }();
    }, { "../common": 19, "../util": 28 }], 9: [function (require, module, exports) {
      module.exports = function () {
        var _k = require('../common');

        var Auth = {};
        var cleanups = [];

        _k.initSubModules(Auth, [require('./oauth'), require('./login')(cleanups), require('./secret')]);

        Auth.cleanup = function () {
          _k.emptyCleanups(cleanups);
        };

        return Auth;
      }();
    }, { "../common": 19, "./login": 11, "./oauth": 12, "./secret": 16 }], 10: [function (require, module, exports) {
      module.exports = function () {
        var _k = require('../common');

        var LOGIN_POPUP_NAME = '_blank';
        var POPUP_FEATURES = 'width=380, height=520, scrollbars=yes';
        var isIntentSupportAndroidWebView = /Version\/4.0/i.test(_k.UA.ua) || /; wv\)/i.test(_k.UA.ua);
        var isSupportWebView = /naver\(inapp|fb_iab|daumapps|instagram|ebay/g.test(_k.UA.ua);
        var _loginPopupWindow;

        return {
          isSupport: function isSupport() {
            var MIN_SUPPORT_VER_TO_APP_INTENT_FOR_ANDROID_CHROME = 30;
            if (_k.UA.os.ios) {
              var iOSBrowser = /safari|FxiOS|CriOS/.test(_k.UA.ua);
              var iOSWebView = !/KAKAOTALK/i.test(_k.UA.ua);
              return iOSBrowser || iOSWebView;
            } else if (_k.UA.os.android) {
              return _k.UA.browser.chrome && !/opr\//i.test(_k.UA.ua) && _k.UA.browser.version.major >= MIN_SUPPORT_VER_TO_APP_INTENT_FOR_ANDROID_CHROME && (!isIntentSupportAndroidWebView || isIntentSupportAndroidWebView && isSupportWebView);
            } else {
              return false;
            }
          },
          login: function login(stateToken, fallbackWebURL, authParams, redirectUri) {
            if (!this.isSupport()) {
              return;
            }
            if (_k.UA.os.ios) {
              var iOSTalkLoginScheme = createIOSTalkLoginScheme(stateToken, authParams);
              if (!redirectUri) {
                _loginPopupWindow = _k.windowOpen(_k.URL.universalKakaoLink + encodeURIComponent(iOSTalkLoginScheme) + '&web=' + encodeURIComponent(fallbackWebURL), LOGIN_POPUP_NAME, POPUP_FEATURES);
              } else {
                location.href = _k.URL.universalKakaoLink + encodeURIComponent(iOSTalkLoginScheme) + '&web=' + encodeURIComponent(fallbackWebURL);
              }
            } else if (_k.UA.os.android) {
              var androidTalkLoginIntent = createAndroidLoginIntent(stateToken, fallbackWebURL, authParams);
              if (!redirectUri) {
                if (isSupportNativeFallbackURL() && (!isIntentSupportAndroidWebView || isIntentSupportAndroidWebView && isSupportWebView)) {
                  _loginPopupWindow = _k.windowOpen(androidTalkLoginIntent, LOGIN_POPUP_NAME, POPUP_FEATURES);
                } else {
                  _loginPopupWindow = _k.windowOpen('', LOGIN_POPUP_NAME, POPUP_FEATURES);
                  if (_loginPopupWindow) {
                    _loginPopupWindow.addEventListener('unload', moveFallback);
                    _loginPopupWindow.location.href = androidTalkLoginIntent;
                  }
                }
              } else {
                location.href = androidTalkLoginIntent;
              }
            }
            return _loginPopupWindow;

            function isSupportNativeFallbackURL() {
              var MIN_SUPPORT_CHROME_VER = 40;
              return _k.UA.browser.version.major > MIN_SUPPORT_CHROME_VER;
            }

            function moveFallback() {
              setTimeout(function () {
                if (_loginPopupWindow && _loginPopupWindow.location) {
                  _loginPopupWindow.location.href = fallbackWebURL;
                }
              }, 10);
            }
          },
          hasWebLoginWindow: function hasWebLoginWindow() {
            try {
              if (_loginPopupWindow && _loginPopupWindow.location && _loginPopupWindow.location.href != "about:blank") {
                if (_k.UA.os.android) {
                  return !!_loginPopupWindow.location.href;
                } else {
                  return true;
                }
              }
              return false;
            } catch (CrossDomainAccessDomException) {
              return true;
            }
          }
        };

        function createIOSTalkLoginScheme(stateToken, authParams) {
          authParams.state = stateToken;
          return [_k.URL.talkLoginScheme, '?', 'client_id=' + _k.RUNTIME.appKey, '&', 'redirect_uri=' + _k.URL.redirectUri, '&', 'params=' + encodeURIComponent(JSON.stringify(authParams))].join('');
        }

        function createAndroidLoginIntent(stateToken, fallbackWebUrl, authParams) {
          return ['intent:#Intent', 'action=com.kakao.talk.intent.action.CAPRI_LOGGED_IN_ACTIVITY', 'launchFlags=0x08880000', 'S.com.kakao.sdk.talk.appKey=' + _k.RUNTIME.appKey, 'S.com.kakao.sdk.talk.redirectUri=' + _k.URL.talkLoginRedirectUri, 'S.com.kakao.sdk.talk.state=' + stateToken, 'S.com.kakao.sdk.talk.kaHeader=' + _k.KAKAO_AGENT, 'S.com.kakao.sdk.talk.extraparams=' + encodeURIComponent(JSON.stringify(authParams)), 'S.browser_fallback_url=' + encodeURIComponent(fallbackWebUrl), 'end;'].join(';');
        }
      }();
    }, { "../common": 19 }], 11: [function (require, module, exports) {
      module.exports = function (cleanups) {
        var _ = require('../util');
        var _k = require('../common');
        var _eventObserver = require('../eventObserver');
        var _webViewChecker = require('../webviewchecker')();
        var origin = require('../browserProxy.js').getOrigin();

        var rules = require('./rules');
        var authCommon = require('./common');
        var proxy = require('./proxy');
        var secret = require('./secret');
        var kakaotalk = require('./kakaotalk');
        var poller = require('./poller');

        var RESERVED_REDIRECT_URI = 'kakaojs';


        function createLoginButton(settings) {
          settings = _k.processRules(settings, rules.createLoginButton, 'Auth.createLoginButton');

          var container$ = _.getElement(settings.container);
          if (!container$) {
            throw new _k.KakaoError('container is required for Kakao login button: pass in element or id');
          }

          var buttonSize = settings.size === 'medium' ? '02' : settings.size === 'small' ? '03' : '01';
          var buttonUrl = _k.URL.authDomain + "/public/widget/login/" + settings.lang + "/" + settings.lang + "_" + buttonSize + "_medium";

          var buttonImage = buttonUrl + ".png";
          var hoverButtonImage = buttonUrl + "_press.png";

          container$.innerHTML = "<img\n      id=\"kakao-login-btn\"\n      src=" + buttonImage + "\n      onmouseover=this.src='" + hoverButtonImage + "'\n      onmouseout=this.src='" + buttonImage + "'\n      style=\"cursor: pointer\"\n    />";
          container$.onclick = function () {
            doLogin(settings);
          };
        }

        function login(settings) {
          settings = _k.processRules(settings, rules.login, 'Auth.login');
          doLogin(settings);
        }

        function doLogin(settings) {
          var stateToken = _.getRandomString() + _.getRandomString();

          if (kakaotalk.isSupport() && settings.throughTalk) {
            loginThroughTalk(settings, stateToken);
          } else if (settings.redirectUri) {
            location.href = redirectLoginThroughWeb(settings);
          } else if (_webViewChecker.isNewerAndroidKakaoTalkWebView()) {
            var params = _.extend({}, authCommon.makeAuthParams(settings), authCommon.makeAuthExtraParams(settings), {
              redirect_uri: _k.URL.talkLoginRedirectUri,
              response_type: 'code',
              state: stateToken,
              ka: _k.KAKAO_AGENT,
              origin: origin
            });

            var loginUrl = authCommon.makeAuthUrl(params);
            loginThroughTalk(settings, stateToken, loginUrl);
          } else {
            if (!(_k.UA.browser.msie && parseInt(_k.UA.browser.version.major) <= 9)) {
              addLoginEvent(settings, stateToken);
            }

            var _loginUrl = loginThroughWeb(settings, stateToken);
            authCommon.openLoginPopup(_loginUrl);
          }

          _eventObserver.dispatch('LOGIN_START');
        }

        function addLoginEvent(settings) {
          var messageHandler = function messageHandler(_ref) {
            var origin = _ref.origin,
              data = _ref.data;

            if (/\.kakao\.com$/.test(origin) && data && typeof data === 'string') {
              var arr = data.split(' ');
              if (arr[1] === 'postResponse') {
                var resp = JSON.parse(decodeURIComponent(arr[2]));
                handleAuthResponse(settings, resp);

                _.removeEvent(window, 'message', messageHandler);
              }
            }
          };
          _.addEvent(window, 'message', messageHandler);

          cleanups.push(function () {
            _.removeEvent(window, 'message', messageHandler);
          });
        }

        function loginForm(settings) {
          settings = _k.processRules(settings, rules.login, 'Auth.loginForm');

          var stateToken = _.getRandomString() + _.getRandomString();
          var reauthQueryString = '&auth_type=reauthenticate';

          if (settings.redirectUri) {
            location.href = "" + redirectLoginThroughWeb(settings) + reauthQueryString;
          } else {
            var loginUrl = "" + loginThroughWeb(settings, stateToken) + reauthQueryString;
            authCommon.openLoginPopup(loginUrl);
          }
        }

        function autoLogin(settings) {
          settings = _k.processRules(settings, rules.autoLogin, 'Auth.autoLogin');

          if (_webViewChecker.isIOSKakaoTalkWebView() || _webViewChecker.isAndroidKakaoTalkWebView()) {
            var stateToken = _.getRandomString() + _.getRandomString();
            var params = _.extend({}, authCommon.makeAuthParams(settings), {
              redirect_uri: _k.URL.talkLoginRedirectUri,
              response_type: 'code',
              state: stateToken,
              ka: _k.KAKAO_AGENT,
              origin: origin,
              auto_login: 'true'
            });

            var loginUrl = authCommon.makeAuthUrl(params);
            loginThroughTalk(settings, stateToken, loginUrl);
          } else {
            authCommon.runAuthCallback(settings, {
              error: 'auto_login',
              error_description: 'Auto-login is only supported by KakaoTalk InAppBrowser',
              error_code: '400',
              status: 'error'
            });
          }

          _eventObserver.dispatch('LOGIN_START');
        }

        var popupForTalk = null;
        var closePopup = function closePopup() {
          popupForTalk && popupForTalk.close && popupForTalk.close();
          popupForTalk = null;
        };

        var proxyForTalk = null;
        var prevCode = null;
        function loginThroughTalk(settings, stateToken, talkLoginUrl) {
          if (!proxyForTalk) {
            proxyForTalk = proxy.getProxy({}, function (response) {
              if (response.status === 'error' && (response.error_code === '500' || response.error_code === '600')) {
                poller.stop();

                handleAuthResponse(settings, {
                  error: response.error,
                  error_description: response.error_description
                });
              }

              if (response.status) {
                if (response.status === 'ok') {
                  poller.stop();

                  if (prevCode === response.code) {
                    return;
                  } else {
                    prevCode = response.code;
                  }

                  proxyForTalk.getAccessToken(response.code, _k.RUNTIME.appKey, _k.UA.os.ios && !talkLoginUrl ? _k.URL.redirectUri : _k.URL.talkLoginRedirectUri, settings.approvalType);

                  closePopup();
                } else {
                  if (_k.UA.os.ios && popupForTalk.location.href === 'about:blank') {
                    closePopup();
                  }
                }
              } else {
                handleAuthResponse(settings, response);
              }
            });

            cleanups.push(function () {
              proxyForTalk.destroy();
              proxyForTalk = null;
            });
          }

          var fallbackUrl = '';
          if (talkLoginUrl) {
            if (settings.redirectUri) {
              location.href = talkLoginUrl;
            } else {
              authCommon.openLoginPopup(talkLoginUrl);
            }
          } else {
            fallbackUrl = settings.redirectUri ? redirectLoginThroughWeb(settings) : loginThroughWeb(settings, stateToken, _k.UA.os.ios ? _k.URL.redirectUri : _k.URL.talkLoginRedirectUri);

            var params = _.extend({}, authCommon.makeAuthParams(settings), authCommon.makeAuthExtraParams(settings));

            setTimeout(function () {
              popupForTalk = kakaotalk.login(stateToken, fallbackUrl, params, settings.redirectUri);
            }, 500);
          }

          poller.start(function () {
            if (stateToken) {
              proxyForTalk.getCode(stateToken, _k.RUNTIME.appKey);
            }
          }, function () {
            handleAuthResponse(settings, {
              error: 'timeout',
              description: 'Account login timed out. Please login again.',
              error_description: 'Account login timed out. Please login again.'
            });

            if (settings.redirectUri) {
              location.href = fallbackUrl;
            } else {
              authCommon.openLoginPopup(fallbackUrl);
            }
          });
        }

        var proxyForWeb = null;
        var savedSettingsForWeb = {};
        function loginThroughWeb(settings, stateToken, fallbackUrl) {
          if (!proxyForWeb) {
            proxyForWeb = proxy.getProxy({}, function (response) {
              var savedSettings = getSavedSettingsWithResponseState(response, savedSettingsForWeb);
              handleAuthResponse(savedSettings, response);
            });

            cleanups.push(function () {
              proxyForWeb.destroy();
              proxyForWeb = null;
            });
          }

          savedSettingsForWeb[stateToken] = settings;

          var redirectUri = settings.redirectUri ? settings.redirectUri : fallbackUrl ? fallbackUrl : RESERVED_REDIRECT_URI;
          var params = _.extend({}, authCommon.makeAuthParams(settings), authCommon.makeAuthExtraParams(settings), {
            redirect_uri: redirectUri,
            response_type: 'code',
            state: stateToken,
            proxy: "easyXDM_Kakao_" + proxyForWeb.channel + "_provider",
            ka: _k.KAKAO_AGENT,
            origin: origin
          });

          return authCommon.makeAuthUrl(params);
        }

        function redirectLoginThroughWeb(settings) {
          var params = _.extend({}, authCommon.makeAuthParams(settings), authCommon.makeAuthExtraParams(settings), {
            redirect_uri: settings.redirectUri,
            response_type: 'code',
            ka: _k.KAKAO_AGENT,
            origin: origin
          });

          return authCommon.makeAuthUrl(params);
        }

        function getSavedSettingsWithResponseState(response, settings) {
          if (!_.has(settings, response.stateToken)) {
            throw new _k.KakaoError('security error: #CST2');
          }

          var savedSettings = settings[response.stateToken];
          delete settings[response.stateToken];
          delete response.stateToken;

          return savedSettings;
        }

        function handleAuthResponse(settings, resp) {
          if (resp.error) {
            if (resp.error !== 'access_denied') {
              secret.setAccessToken(null);
            }
          } else {
            secret.setAccessToken(resp.access_token, settings.persistAccessToken);
            _eventObserver.dispatch('LOGIN');
          }

          authCommon.runAuthCallback(settings, resp);
        }

        function logout(callback) {
          callback = callback || _.emptyFunc;
          _k.validate(callback, _.isFunction, 'Auth.logout');

          Kakao.API.request({
            url: '/v1/user/logout',
            always: function always() {
              secret.setAccessToken(null);
              _eventObserver.dispatch('LOGOUT');
              callback(true);
            }
          });
        }

        var proxyForAccessToken = null;
        function issueAccessToken(settings) {
          settings = _k.processRules(settings, rules.issueAccessToken, 'Auth.issueAccessToken');

          if (!proxyForAccessToken) {
            proxyForAccessToken = proxy.getProxy({}, function (response) {
              handleAuthResponse(settings, response);
            });

            cleanups.push(function () {
              proxyForAccessToken.destroy();
              proxyForAccessToken = null;
            });
          }

          proxyForAccessToken.getAccessToken(settings.code, _k.RUNTIME.appKey, settings.redirectUri);
        }

        var proxyForStoryChannel = null;
        var savedSettingsForStoryChannel = {};
        function selectStoryChannel(settings) {
          settings = _k.processRules(settings, rules.selectStoryChannel, 'Auth.selectStoryChannel');

          if (!proxyForStoryChannel) {
            proxyForStoryChannel = proxy.getProxy({}, function (response) {
              var savedSettings = getSavedSettingsWithResponseState(response, savedSettingsForStoryChannel);
              authCommon.runAuthCallback(savedSettings, response);
            });

            cleanups.push(function () {
              proxyForStoryChannel.destroy();
              proxyForStoryChannel = null;
            });
          }

          var stateToken = _.getRandomString();
          savedSettingsForStoryChannel[stateToken] = settings;

          var params = _.extend({}, authCommon.makeAuthParams(settings), {
            state: stateToken,
            proxy: "easyXDM_Kakao_" + proxyForStoryChannel.channel + "_provider",
            token: settings.extendedToken || ''
          });

          authCommon.openLoginPopup(_k.URL.storyChannel + "?" + _.buildQueryString(params));
        }

        return {
          createLoginButton: createLoginButton,
          login: login,
          loginForm: loginForm,
          autoLogin: autoLogin,
          logout: logout,
          issueAccessToken: issueAccessToken,
          selectStoryChannel: selectStoryChannel
        };
      };
    }, { "../browserProxy.js": 17, "../common": 19, "../eventObserver": 20, "../util": 28, "../webviewchecker": 29, "./common": 8, "./kakaotalk": 10, "./poller": 13, "./proxy": 14, "./rules": 15, "./secret": 16 }], 12: [function (require, module, exports) {
      module.exports = function () {
        var _ = require('../util');
        var _k = require('../common');
        var _eventObserver = require('../eventObserver');

        var rules = require('./rules');
        var authCommon = require('./common');
        var ajax = require('./ajax');
        var poller = require('./poller');

        function authorize(settings) {
          settings = _k.processRules(settings, rules.authorize, 'Auth.authorize');

          if (settings.autoLogin && !/KAKAOTALK/i.test(_k.UA.ua)) {
            handleResponse(settings, {
              error: 'auto_login',
              error_description: 'NOT_SUPPORTED_BROWSER'
            });
            return false;
          }

          var isEasyLogin = isSupport() && settings.throughTalk && !settings.autoLogin && !settings.reauthenticate;
          var authTranId = getTranId();

          var baseAuthParams = _.extend({}, authCommon.makeAuthParams(settings), authCommon.makeAuthExtraParams(settings), {
            redirect_uri: settings.redirectUri || _k.URL.redirectUri,
            response_type: 'code',
            auth_tran_id: authTranId
          });

          var webAuthParams = _.extend({}, baseAuthParams, {
            ka: _k.KAKAO_AGENT,
            is_popup: settings.isPopup
          });
          var webAuthUrl = authCommon.makeAuthUrl(webAuthParams);

          var loginUrl = isEasyLogin ? makeEasyLoginUrl(settings, baseAuthParams, webAuthUrl) : settings.reauthenticate ? webAuthUrl + "&auth_type=reauthenticate" : webAuthUrl;

          var popup = null;
          if (settings.isPopup) {
            popup = authCommon.openLoginPopup(loginUrl);
          } else {
            location.href = loginUrl;
          }

          if (isEasyLogin || settings.isPopup) {
            poller.start(function () {
              if (authTranId) {
                var params = {
                  client_id: _k.RUNTIME.appKey,
                  auth_tran_id: authTranId
                };

                ajax.checkAuthorize(_k.URL.authDomain + "/apiweb/code.json?" + _.buildQueryString(params), function (httpResp) {
                  var isValidResp = onResponse(settings, httpResp);
                  if (isValidResp) {
                    poller.stop();
                    popup && popup.close && popup.close();
                  }

                  if (!isEasyLogin && popup && popup.closed) {
                    poller.stop();
                  }
                });
              }
            }, function () {
              handleResponse(settings, {
                error: 'timeout',
                error_description: 'LOGIN_TIMEOUT'
              });
            });
          }

          _eventObserver.dispatch('LOGIN_START');
        }

        function isSupport() {
          return _k.UA.os.ios || _k.UA.os.android ? !/KAKAOTALK/i.test(_k.UA.ua) : false;
        }

        function getTranId() {
          var tranId = Math.random().toString(36).slice(2) + _k.RUNTIME.appKey + Date.now().toString(36);
          return tranId.slice(0, 60);
        }

        function onResponse(settings, httpResp) {
          if (httpResp.status === 200 && httpResp.response) {
            var resp = JSON.parse(httpResp.response);

            if (resp.status === 'ok' && resp.code) {
              handleResponse(settings, {
                code: resp.code
              });
              return true;
            } else if (resp.status === 'error' && (resp.error_code === '500' || resp.error_code === '600')) {
              handleResponse(settings, {
                error: resp.error,
                error_description: resp.error_description
              });
              return true;
            }
          }

          return false;
        }

        function handleResponse(settings, respObj) {
          if (settings.state) {
            respObj.state = settings.state;
          }

          if (settings.redirectUri) {
            location.href = settings.redirectUri + "?" + _.buildQueryString(respObj);
          } else {
            authCommon.runAuthCallback(settings, respObj);
          }
        }

        function makeEasyLoginUrl(settings, baseAuthParams, fallbackUrl) {
          var easyLoginAuthParams = _.extend({}, baseAuthParams, {
            is_popup: true
          });

          var getAndroidLoginIntent = function getAndroidLoginIntent() {
            var intent = ['intent:#Intent', 'action=com.kakao.talk.intent.action.CAPRI_LOGGED_IN_ACTIVITY', 'launchFlags=0x08880000', "S.com.kakao.sdk.talk.appKey=" + _k.RUNTIME.appKey, "S.com.kakao.sdk.talk.redirectUri=" + easyLoginAuthParams.redirect_uri, "S.com.kakao.sdk.talk.kaHeader=" + _k.KAKAO_AGENT, "S.com.kakao.sdk.talk.extraparams=" + encodeURIComponent(JSON.stringify(easyLoginAuthParams))];

            if (settings.state) {
              intent.push("S.com.kakao.sdk.talk.state=" + settings.state);
            }

            return intent.concat(["S.browser_fallback_url=" + encodeURIComponent(fallbackUrl), 'end;']).join(';');
          };

          var getIosLoginUniversalLink = function getIosLoginUniversalLink() {
            var iosLoginUrl = authCommon.makeAuthUrl(easyLoginAuthParams);
            var iosFallbackUrl = settings.isPopup ? iosLoginUrl : fallbackUrl;

            var iosEasyLoginUrl = iosLoginUrl + "&ka=" + encodeURIComponent(_k.KAKAO_AGENT);
            var talkWebviewUrl = _k.URL.talkInappScheme + "?url=" + encodeURIComponent(iosEasyLoginUrl);

            return "" + _k.URL.universalKakaoLink + encodeURIComponent(talkWebviewUrl) + "&web=" + encodeURIComponent(iosFallbackUrl);
          };

          return _k.UA.os.android ? getAndroidLoginIntent() : getIosLoginUniversalLink();
        }

        return {
          authorize: authorize
        };
      }();
    }, { "../common": 19, "../eventObserver": 20, "../util": 28, "./ajax": 7, "./common": 8, "./poller": 13, "./rules": 15 }], 13: [function (require, module, exports) {
      module.exports = function () {
        var timer;
        var pollingCounter = 0;
        var INTERVAL = 1000;
        var MAX_COUNT = 600;
        var failCallback = function failCallback() { };
        var pollingAction = function pollingAction() { };
        var stopConditionFunc = function stopConditionFunc() {
          return false;
        };

        function doPolling() {
          if (stopConditionFunc()) {
            _stop();
            return;
          }
          if (++pollingCounter > MAX_COUNT) {
            _stop();
            failCallback();
          } else {
            pollingAction();
          }
        };

        function _stop() {
          clearInterval(timer);
        }

        return {
          start: function start(action, failAction) {
            pollingCounter = 0;
            if (typeof action === 'function') {
              pollingAction = action;
            }
            if (typeof failAction === 'function') {
              failCallback = failAction;
            }

            if (timer) {
              _stop();
            }

            timer = setInterval(doPolling, INTERVAL);
          },
          stop: function stop() {
            _stop();
          },
          setStopCondition: function setStopCondition(funcCondition) {
            if (typeof funcCondition === 'function') {
              stopConditionFunc = funcCondition;
            }
          }
        };
      }();
    }, {}], 14: [function (require, module, exports) {
      module.exports = function () {
        var _ = require('../util');
        var _k = require('../common');
        var _easyXDM = require('../../vendor/easyXDM');

        function getProxy(config, onResponse) {
          _.extend(config, {
            remote: _k.URL.loginWidget,
            channel: _.getRandomString()
          });

          return _k.guardCreateEasyXDM(function () {
            var proxy = new _easyXDM.Rpc(config, {
              local: {
                postResponse: onResponse,
                getKakaoAgent: function getKakaoAgent() {
                  return _k.KAKAO_AGENT;
                }
              },
              remote: {
                getCode: {},
                getAccessToken: {},
                setClient: {},
                setStateToken: {},
                deleteAuthCookie: {}
              }
            });

            proxy.channel = config.channel;
            return proxy;
          });
        }

        return {
          getProxy: getProxy
        };
      }();
    }, { "../../vendor/easyXDM": 31, "../common": 19, "../util": 28 }], 15: [function (require, module, exports) {
      module.exports = function () {
        var _ = require('../util');

        var defaultCallbacks = {
          success: _.emptyFunc,
          fail: _.emptyFunc,
          always: _.emptyFunc
        };

        var loginDefaultSettings = _.extend({
          throughTalk: true,
          persistAccessToken: true,
          persistRefreshToken: false
        }, defaultCallbacks);

        var loginCommonSettings = {
          success: _.isFunction,
          fail: _.isFunction,
          always: _.isFunction,
          persistAccessToken: _.isBoolean,
          persistRefreshToken: _.isBoolean,
          approvalType: _.isOneOf(['project']),
          scope: _.isString,
          throughTalk: _.isBoolean,
          plusFriendPublicId: _.isString,
          channelPublicId: _.isString,
          serviceTerms: _.isString,
          redirectUri: _.isString,
          state: _.isString,
          deviceType: _.isOneOf(['watch', 'tv'])
        };

        return {
          createLoginButton: {
            required: {
              container: _.passesOneOf([_.isElement, _.isString])
            },
            optional: _.extend({
              lang: _.isOneOf(['en', 'kr']),
              size: _.isOneOf(['small', 'medium', 'large'])
            }, loginCommonSettings),
            defaults: _.extend({
              lang: 'kr',
              size: 'medium'
            }, loginDefaultSettings)
          },
          login: {
            optional: loginCommonSettings,
            defaults: loginDefaultSettings
          },
          authorize: {
            optional: {
              redirectUri: _.isString,
              approvalType: _.isOneOf(['project']),
              scope: _.isString,
              throughTalk: _.isBoolean,
              plusFriendPublicId: _.isString,
              channelPublicId: _.isString,
              serviceTerms: _.isString,
              isPopup: _.isBoolean,
              state: _.isString,
              autoLogin: _.isBoolean,
              deviceType: _.isOneOf(['watch', 'tv']),
              reauthenticate: _.isBoolean,
              success: _.isFunction,
              fail: _.isFunction,
              always: _.isFunction
            },
            defaults: {
              throughTalk: true,
              isPopup: false,
              reauthenticate: false,
              success: _.emptyFunc,
              fail: _.emptyFunc,
              always: _.emptyFunc
            }
          },
          autoLogin: {
            optional: {
              success: _.isFunction,
              fail: _.isFunction,
              always: _.isFunction
            },
            defaults: defaultCallbacks
          },
          issueAccessToken: {
            required: {
              code: _.isString,
              redirectUri: _.isString
            },
            optional: {
              success: _.isFunction,
              fail: _.isFunction,
              always: _.isFunction
            },
            defaults: defaultCallbacks
          },
          selectStoryChannel: {
            optional: {
              extendedToken: _.isString,
              success: _.isFunction,
              fail: _.isFunction,
              always: _.isFunction
            },
            defaults: defaultCallbacks
          }
        };
      }();
    }, { "../util": 28 }], 16: [function (require, module, exports) {
      module.exports = function () {
        var _ = require('../util');
        var _k = require('../common');
        var _crypto = require('../../vendor/CryptoJS');

        function getAppKey() {
          return _k.RUNTIME.appKey;
        }

        function getAccessToken() {
          if (!_k.RUNTIME.accessToken) {
            _k.RUNTIME.accessToken = retrieveItem(getAccessTokenKey());
          }

          return _k.RUNTIME.accessToken;
        }

        function setAccessToken(token, persist) {
          _k.RUNTIME.accessToken = token;
          if (token === null || persist === false) {
            removeItem(getAccessTokenKey());
          } else {
            storeItem(getAccessTokenKey(), token);
          }
        }

        function getRefreshToken() {
          console.log('unsupported operation: Auth.getRefreshToken()');
          return '';
        }

        function setRefreshToken(token) {
          console.log('unsupported operation: Auth.setRefreshToken()');
        }

        function getStatusInfo(callback) {
          _k.validate(callback, _.isFunction, 'Auth.getStatusInfo');

          if (!getAccessToken()) {
            callback({
              status: 'not_connected'
            });
          } else {
            Kakao.API.request({
              url: '/v2/user/me',
              success: function success(res) {
                callback({
                  status: 'connected',
                  user: res
                });
              },
              fail: function fail() {
                callback({
                  status: 'not_connected'
                });
              }
            });
          }
        }

        function storeItem(key, value) {
          var item = encrypt(value, getAppKey());
          _.localStorage.setItem(key, item);
        }

        function retrieveItem(key) {
          var item = _.localStorage.getItem(key);
          return item ? decrypt(item, getAppKey()) : null;
        }

        function removeItem(key) {
          _.localStorage.removeItem(key);
        }

        var tokenStorageKeys = {};
        function getAccessTokenKey() {
          if (!tokenStorageKeys.accessTokenKey) {
            tokenStorageKeys.accessTokenKey = 'kakao_' + hash('kat' + getAppKey());
          }

          return tokenStorageKeys.accessTokenKey;
        }

        function hash(msg) {
          return _crypto.MD5(msg).toString();
        }

        function encrypt(msg, passphrase) {
          return _crypto.AES.encrypt(msg, passphrase).toString();
        }

        function decrypt(encrypted, passphrase) {
          return _crypto.AES.decrypt(encrypted, passphrase).toString(_crypto.enc.Utf8);
        }

        return {
          getAppKey: getAppKey,
          getAccessToken: getAccessToken,
          setAccessToken: setAccessToken,
          getRefreshToken: getRefreshToken,
          setRefreshToken: setRefreshToken,
          getStatusInfo: getStatusInfo
        };
      }();
    }, { "../../vendor/CryptoJS": 30, "../common": 19, "../util": 28 }], 17: [function (require, module, exports) {
      module.exports = function () {
        var userAgent = require('../vendor/userAgent')();

        return {
          getOrigin: function getOrigin() {
            var _location = location,
              protocol = _location.protocol,
              hostname = _location.hostname,
              port = _location.port;

            return protocol + "//" + hostname + (port ? ':' + port : '');
          },
          getNavigator: function getNavigator() {
            return navigator;
          },
          getUA: function getUA() {
            return userAgent;
          }
        };
      }();
    }, { "../vendor/userAgent": 33 }], 18: [function (require, module, exports) {
      module.exports = function () {
        var Channel = {};

        var _ = require('./util.js');
        var _k = require('./common.js');
        var browserProxy = require('./browserProxy.js');

        var ADD_POPUP_NAME = 'channel_add_social_plugin';
        var CHAT_POPUP_NAME = 'channel_chat_social_plugin';
        var POPUP_FEATURES = 'width=350, height=510';

        var API_VER = '1.1';

        var cleanups = [];

        Channel.createAddChannelButton = function (settings) {
          settings = _k.processRules(settings, rules.createAddChannelButton, 'Channel.createAddChannelButton');

          var container = _.getElement(settings.container);
          if (!container) {
            throw new _k.KakaoError('container is required for creating Channel.addChannel button: pass in element or id');
          }

          var openUrl = getAddChannelUrl(settings);
          var addChannelIconUrl = getAddChannelIconUrl(settings);
          var anchor = createImageAnchor(openUrl, addChannelIconUrl, '카카오톡 채널 추가 버튼', settings);

          container.appendChild(anchor);

          var handler = function handler(e) {
            if (e.preventDefault) {
              e.preventDefault();
            } else {
              e.returnValue = false;
            }
            _k.windowOpen(openUrl, ADD_POPUP_NAME, POPUP_FEATURES);
          };
          _.addEvent(anchor, 'click', handler);

          var cleanup = function cleanup() {
            container.removeChild(anchor);
            _.removeEvent(anchor, 'click', handler);
          };
          cleanups.push(cleanup);
        };

        Channel.addChannel = function (settings) {
          settings = _k.processRules(settings, rules.addChannel, 'Channel.addChannel');
          var openUrl = getAddChannelUrl(settings);
          _k.windowOpen(openUrl, ADD_POPUP_NAME, POPUP_FEATURES);
        };

        Channel.createChatButton = function (settings) {
          settings = _k.processRules(settings, rules.createChatButton, 'Channel.createChatButton');

          var container = _.getElement(settings.container);
          if (!container) {
            throw new _k.KakaoError('container is required for creating Channel.chat button: pass in element or id');
          }

          var openUrl = getChatUrl(settings);
          var chatIconUrl = getChatIconUrl(settings);
          var anchor = createImageAnchor(openUrl, chatIconUrl, '카카오톡 채널 1:1 채팅 버튼', settings);

          container.appendChild(anchor);

          var handler = function handler(e) {
            if (e.preventDefault) {
              e.preventDefault();
            } else {
              e.returnValue = false;
            }
            _k.windowOpen(openUrl, CHAT_POPUP_NAME, POPUP_FEATURES);
          };
          _.addEvent(anchor, 'click', handler);

          var cleanup = function cleanup() {
            container.removeChild(anchor);
            _.removeEvent(anchor, 'click', handler);
          };
          cleanups.push(cleanup);
        };

        Channel.chat = function (settings) {
          settings = _k.processRules(settings, rules.chat, 'Channel.chat');
          var openUrl = getChatUrl(settings);
          _k.windowOpen(openUrl, CHAT_POPUP_NAME, POPUP_FEATURES);
        };

        function createImageAnchor(href, imageSrc, imageTitle, settings) {
          var anchor = document.createElement('a');
          var image = document.createElement('img');

          anchor.setAttribute('href', '#');

          image.setAttribute('src', imageSrc);
          image.setAttribute('alt', imageTitle);
          image.setAttribute('title', imageTitle);

          if (settings.supportMultipleDensities) image.setAttribute('srcset', [imageSrc.replace('.png', '_2X.png 2x'), imageSrc.replace('.png', '_3X.png 3x')].join(', '));

          anchor.appendChild(image);

          return anchor;
        }

        function getAddChannelIconUrl(settings) {
          var filename = 'friendadd_' + settings.size + '_yellow_rect';
          var url = _k.URL.resPrefix + '\/logos\/channel\/' + filename + '.png';
          return url;
        }

        function getChatIconUrl(settings) {
          var filename = settings.title + '_' + settings.size + '_' + settings.color + '_' + settings.shape;
          var url = _k.URL.resPrefix + '\/logos\/channel\/' + filename + '.png';
          return url;
        }

        function getAddChannelUrl(settings) {
          var url = _k.URL.plusFriend + '\/' + settings.channelPublicId + '\/friend';
          if (_k.RUNTIME.appKey) url += '?' + buildQueryString();
          return url;
        }

        function getChatUrl(settings) {
          var url = _k.URL.plusFriend + '\/' + settings.channelPublicId + '\/chat';
          if (_k.RUNTIME.appKey) url += '?' + buildQueryString();
          return url;
        }

        function buildQueryString() {
          if (!_k.RUNTIME.appKey) {
            throw _k.KakaoError('The app key does not exist. Please call Kakao.init function.');
          }
          var params = {
            api_ver: API_VER,
            kakao_agent: _k.KAKAO_AGENT,
            app_key: _k.RUNTIME.appKey,
            referer: browserProxy.getOrigin() + location.pathname + location.search
          };
          return _.buildQueryString(params);
        }

        var rules = {
          createAddChannelButton: {
            required: {
              container: _.passesOneOf([_.isElement, _.isString]),
              channelPublicId: _.isString
            },
            optional: {
              size: _.isOneOf(['small', 'large']),
              supportMultipleDensities: _.isBoolean
            },
            defaults: function defaults(settings) {
              var container = _.getElement(settings.container);

              return container ? {
                channelPublicId: container.getAttribute('data-channel-public-id'),
                size: container.getAttribute('data-size') || 'small',
                supportMultipleDensities: !!container.getAttribute('data-support-multiple-densities')
              } : null;
            }
          },
          addChannel: {
            required: {
              channelPublicId: _.isString
            }
          },
          createChatButton: {
            required: {
              container: _.passesOneOf([_.isElement, _.isString]),
              channelPublicId: _.isString
            },
            optional: {
              color: _.isOneOf(['yellow', 'mono']),
              shape: _.isOneOf(['pc', 'mobile']),
              size: _.isOneOf(['small', 'large']),
              title: _.isOneOf(['consult', 'question']),
              supportMultipleDensities: _.isBoolean
            },
            defaults: function defaults(settings) {
              var container = _.getElement(settings.container);

              return container ? {
                channelPublicId: container.getAttribute('data-channel-public-id'),
                color: container.getAttribute('data-color') || 'yellow',
                shape: container.getAttribute('data-shape') || 'pc',
                size: container.getAttribute('data-size') || 'small',
                title: container.getAttribute('data-title') || 'consult',
                supportMultipleDensities: !!container.getAttribute('data-support-multiple-densities')
              } : null;
            }
          },
          chat: {
            required: {
              channelPublicId: _.isString
            }
          }
        };

        Channel.cleanup = function () {
          _.each(cleanups, function (func) {
            func();
          });
          cleanups.length = 0;
        };

        return Channel;
      }();
    }, { "./browserProxy.js": 17, "./common.js": 19, "./util.js": 28 }], 19: [function (require, module, exports) {
      module.exports = function () {
        var _ = require('./util');
        var browserProxy = require('./browserProxy');

        var origin = browserProxy.getOrigin();
        var navigator = browserProxy.getNavigator();

        var _k = {};

        _k.VERSION = '1.39.8';

        _k.KAKAO_AGENT = ["sdk/" + _k.VERSION, 'os/javascript', 'sdk_type/javascript', "lang/" + (navigator.userLanguage || navigator.language), "device/" + navigator.platform.replace(/ /g, '_'), "origin/" + encodeURIComponent(origin)].join(' ');

        _k.UA = browserProxy.getUA();

        _k.URL = {
          authorize: 'https://kauth.kakao.com' + '/oauth/authorize',
          loginWidget: 'https://kauth.kakao.com' + '/public/widget/login/kakaoLoginWidget.html',
          apiRemote: 'https://kapi.kakao.com' + '/cors/',
          plusFriend: 'https://pf.kakao.com',
          storyChannel: 'https://kauth.kakao.com' + '/story/select_channel',
          storyShare: 'https://story.kakao.com' + '/s/share',
          channelFollow: 'https://story.kakao.com' + '/s/follow',
          storyIcon: 'https://developers.kakao.com/sdk/js/resources/story/icon_small.png',
          universalKakaoLink: 'https://talk-apps.kakao.com' + '/scheme/',
          talkLoginScheme: 'kakaokompassauth://authorize',
          talkLoginRedirectUri: 'https://kapi.kakao.com/cors/afterlogin.html',
          redirectUri: 'JS-SDK',
          authDomain: 'https://kauth.kakao.com',
          navi: 'kakaonavi-sdk://navigate',
          naviShare: 'kakaonavi-sdk://sharePoi',
          naviWeb: 'https://kakaonavi-wguide.kakao.com/openapi',
          sharerDomain: 'https://sharer.kakao.com',
          stat: 'https://apps.kakao.com/sdk/js',
          resPrefix: 'https://developers.kakao.com/assets/img/about',
          talkInappScheme: 'kakaotalk://inappbrowser'
        };

        _k.RUNTIME = {
          appKey: '',
          accessToken: ''
        };

        _k.DUMMY_KEY = 'YOUR APP KEY';

        function KakaoError(message) {
          Error.prototype.constructor.apply(this, arguments);
          this.name = 'KakaoError';
          this.message = message;
        };
        KakaoError.prototype = new Error();

        _k.KakaoError = KakaoError;

        _k.isDebug = function () {
          return false;
        };

        _k.logDebug = function (obj) {
          if (_k.isDebug() && window.console) {
            console.log(JSON.stringify(obj));
          }
        };

        _k.initSubModules = function (M, subModules) {
          _.each(subModules, function (subModule) {
            for (var key in subModule) {
              M[key] = M[key] || subModule[key];
            }
          });
        };

        _k.emptyCleanups = function (cleanups) {
          _.each(cleanups, function (fn) {
            fn();
          });
          cleanups.length = 0;
        };

        _k.validate = function (target, validator, callerMsg) {
          if (validator(target) !== true) {
            throw new KakaoError("Illegal argument for " + callerMsg);
          }
        };

        _k.processRules = function (params, rules, callerMsg) {
          params = params || {};

          if (rules.before) {
            rules.before(params);
          }

          if (_.isFunction(rules.defaults)) {
            _.defaults(params, rules.defaults(params));
          } else {
            _.defaults(params, rules.defaults);
          }

          var required = rules.required || {};

          var missingRequiredKeys = _.difference(_.keys(required), _.keys(params));
          if (missingRequiredKeys.length) {
            throw new KakaoError("Missing required keys: " + missingRequiredKeys.join(',') + " at " + callerMsg);
          }

          var optional = rules.optional || {};
          var allowed = _.extend({}, required, optional);

          var invalidKeys = _.difference(_.keys(params), _.keys(allowed));
          if (invalidKeys.length) {
            throw new KakaoError("Invalid parameter keys: " + invalidKeys.join(',') + " at " + callerMsg);
          }

          _.each(params, function (value, key) {
            var validator = allowed[key];
            _k.validate(value, validator, "\"" + key + "\" in " + callerMsg);
          });

          if (rules.after) {
            rules.after(params);
          }

          return params;
        };

        _k.getInstallUrl = function (androidAppId, iOSAppId) {
          if (_k.UA.os.android) {
            var referrer = {
              appkey: _k.RUNTIME.appKey,
              KA: _k.KAKAO_AGENT
            };

            return "market://details?id=" + androidAppId + "&referrer=" + JSON.stringify(referrer);
          } else if (_k.UA.os.ios) {
            return "https://itunes.apple.com/app/id" + iOSAppId;
          } else {
            return location.href;
          }
        };

        _k.guardCreateEasyXDM = function (createEasyXDM) {
          try {
            return createEasyXDM();
          } catch (ex) {
            if (ex instanceof TypeError) {
              throw new KakaoError('kakao.js should be loaded from a web server');
            } else {
              throw new KakaoError("EasyXDM - " + ex.message);
            }
          }
        };

        _k.serializeFile = function (file) {
          return new Promise(function (resolve, reject) {
            if (typeof FileReader === 'undefined') {
              reject(new KakaoError('File API is not supported for this browser.'));
            }

            var fileReader = new FileReader();

            fileReader.onload = function (e) {
              try {
                resolve(_.arrayBufferToString(e.target.result));
              } catch (e) {
                reject(e);
              }
            };

            fileReader.onerror = function (e) {
              reject(new KakaoError("Cannot read file: " + file.name));
            };

            fileReader.readAsArrayBuffer(file);
          });
        };

        _k.popupWindows = {};
        _k.windowOpen = function (url, name, feature) {
          var popupWindow = _k.popupWindows[name];
          if (popupWindow && popupWindow.close && !popupWindow.closed) {
            popupWindow.close();
          }

          _k.popupWindows[name] = window.open(url, name, feature);
          return _k.popupWindows[name];
        };

        return _k;
      }();
    }, { "./browserProxy": 17, "./util": 28 }], 20: [function (require, module, exports) {
      module.exports = function () {
        var _ = require('./util');
        var _eventObservers = {};

        return {
          subscribe: function subscribe(eventName, observer) {
            if (!_eventObservers[eventName]) {
              _eventObservers[eventName] = [];
            }

            _eventObservers[eventName].push(observer);
          },
          unsubscribe: function unsubscribe(eventName, observer) {
            var observers = _eventObservers[eventName];
            for (var i = 0; i < l.length; i++) {
              if (observers[m] === observer) {
                observers.splice(m, 1);
                break;
              }
            }
          },
          dispatch: function dispatch(eventName) {
            var observers = _eventObservers[eventName];
            if (observers && observers.length) {
              _.each(observers, function (observer) {
                observer();
              });
            }
          }
        };
      }();
    }, { "./util": 28 }], 21: [function (require, module, exports) {
      module.exports = function () {
        var KAKAOTALK_ANDROID_PACAKGE_NAME = "com.kakao.talk";
        var KAKAOTALK_IOS_APP_ID = "362057947";

        var Link = {};

        var _ = require('./util.js');
        var _api = require('./API');
        var _k = require('./common.js');
        var web2app = require('../vendor/web2app.js');
        var webViewChecker = require('./webviewchecker.js')();
        var linkObj = require('./link.obj.js');
        var UA = require('../vendor/userAgent.js')();
        var poller = require('./link.poller');

        var KakaoTalkLink = function KakaoTalkLink() {
          this.appkey = _k.RUNTIME.appKey;
          this.appver = '1.0';
          this.apiver = '3.0';
          this.linkver = '3.5';
          this.extras = {
            "KA": _k.KAKAO_AGENT
          };
          this.objs = [];
        };

        var KakaoLink = function KakaoLink() {
          this.appkey = _k.RUNTIME.appKey;
          this.appver = '1.0';
          this.linkver = '4.0';
          this.template_json = {};
          this.template_args = {};
          this.template_id = '';
          this.extras = {
            "KA": _k.KAKAO_AGENT
          };
        };

        var defaultObj = function defaultObj(settings) {
          var obj = {};
          obj.object_type = settings.objectType;
          obj.button_title = settings.buttonTitle || '';
          _.each(settings, function (setting, key) {
            var item = linkObj.create(setting, key, 'defaultObject');
            if (obj) {
              obj[key] = item;
            }
          });

          if (obj.object_type == 'list') {
            if (console && (settings.headerImageUrl || settings.headerImageWidth || settings.headerImageHeight)) {
              var params = ['headerImageUrl', 'headerImageWidth', 'headerImageHeight'];
              console.warn("KakaoWarning: The parameters (" + params.join(', ') + ") for header background image are deprecated.");
            }

            obj.header_title = settings.headerTitle || '';
            obj.header_link = obj.headerLink || {};
            delete obj.headerLink;
          } else if (obj.object_type == 'location') {
            obj.address = settings.address || '';
            obj.address_title = settings.addressTitle || '';
          } else if (obj.object_type == 'text') {
            obj.text = settings.text || '';
          }

          return {
            link_ver: '4.0',
            template_object: obj
          };
        };

        var customObj = function customObj(settings) {
          return {
            link_ver: '4.0',
            template_id: settings.templateId,
            template_args: settings.templateArgs
          };
        };

        var scrapObj = function scrapObj(settings) {
          var obj = {
            link_ver: '4.0',
            request_url: settings.requestUrl
          };
          settings.templateId && (obj.template_id = settings.templateId);
          settings.templateArgs && (obj.template_args = settings.templateArgs);
          return obj;
        };

        var linkType = {
          custom: 'custom',
          defaultType: 'default',
          scrap: 'scrap'
        };

        var cleanups = [];

        Link.createTalkLink = Link.createTalkLinkButton = function (settings) {
          settings = _k.processRules(settings, rules.createTalkLink, 'Link.createTalkLink');

          var container = _.getElement(settings.container);
          if (!container) {
            throw new _k.KakaoError('container is required for KakaoTalk Link: pass in element or id');
          }

          var handler = function handler() {
            var linkUrl = buildLinkUrl(settings, 'Link.createTalkLink');
            sendLink(linkUrl, settings.fail, settings.installTalk);
          };

          _.addEvent(container, 'click', handler);

          cleanups.push(function () {
            _.removeEvent(container, 'click', handler);
          });
        };

        Link.sendTalkLink = function (settings) {
          settings = _k.processRules(settings, rules.talkLink, 'Link.sendTalkLink');
          var linkUrl = buildLinkUrl(settings, 'Link.sendTalkLink');
          sendLink(linkUrl, settings.fail, settings.installTalk);
        };

        Link.createCustom = Link.createCustomButton = function (settings) {
          settings = _k.processRules(settings, rules.createCustom, 'Link.createCustom');
          commonAddEvent(validateRequest, settings, linkType.custom);
        };

        Link.createScrap = Link.createScrapButton = function (settings) {
          settings = _k.processRules(settings, rules.createScrap, 'Link.createScrap');
          commonAddEvent(scrapRequest, settings, linkType.scrap);
        };







        Link.createDefault = Link.createDefaultButton = function (settings) {
          if (settings.objectType == 'list') {
            settings = _k.processRules(settings, rules.createDefaultList, 'Link.createDefaultList');
          } else if (settings.objectType == 'location') {
            settings = _k.processRules(settings, rules.createDefaultLocation, 'Link.createDefaultLocation');
          } else if (settings.objectType == 'commerce') {
            settings = _k.processRules(settings, rules.createDefaultCommerce, 'Link.createDefaultCommerce');
          } else if (settings.objectType == 'text') {
            settings = _k.processRules(settings, rules.createDefaultText, 'Link.createDefaultText');
          } else {
            settings = _k.processRules(settings, rules.createDefaultFeed, 'Link.createDefaultFeed');
          }

          commonAddEvent(defaultRequest, settings, linkType.defaultType);
        };

        function commonAddEvent(requestFn, settings, type) {
          var container = _.getElement(settings.container);
          if (!container) {
            throw new _k.KakaoError('container is required for KakaoTalk Link: pass in element or id');
          }

          var handler = function handler(e) {
            e = e || window.e;
            e.preventDefault();
            e.stopPropagation();
            commonClickEvent(requestFn, settings, type);
            return false;
          };

          _.addEvent(container, 'click', handler);

          cleanups.push(function () {
            _.removeEvent(container, 'click', handler);
          });
        }

        function webLinkPopup(url, option, name, params) {
          var popup = _k.UA.browser.msie ? {} : _k.windowOpen('', name, option);
          var form = document.createElement('form');
          form.setAttribute('accept-charset', 'utf-8');
          form.setAttribute('method', 'post');
          form.setAttribute('action', url);
          form.setAttribute('target', name);
          form.setAttribute('style', 'display:none');
          for (var i in params) {
            if (params.hasOwnProperty(i)) {
              var input = document.createElement('input');
              input.type = 'hidden';
              input.name = i;
              input.value = _.isString(params[i]) ? params[i] : JSON.stringify(params[i]);
              form.appendChild(input);
            }
          }
          document.body.appendChild(form);
          form.submit();
          document.body.removeChild(form);
          if (popup.focus) popup.focus();
          return popup;
        }

        function webLink(settings, type) {
          var validationParams;
          switch (type) {
            case 'custom':
              validationParams = customObj(settings);
              break;
            case 'default':
              validationParams = defaultObj(settings);
              break;
            case 'scrap':
              validationParams = scrapObj(settings);
              break;
            default:
              throw new _k.KakaoError('type is required for KakaoTalk Link');
          }
          var webParam = {
            app_key: _k.RUNTIME.appKey,
            validation_action: type,
            validation_params: JSON.stringify(validationParams),
            ka: _k.KAKAO_AGENT
          };
          if (settings.serverCallbackArgs) webParam.lcba = stringifyLCBA(settings.serverCallbackArgs);
          var popupUrl = _k.URL.sharerDomain + '/talk/friends/picker/easylink?app_key=' + webParam.app_key + '&ka=' + encodeURIComponent(webParam.ka) + '&validation_action=' + webParam.validation_action + '&validation_params=' + encodeURIComponent(webParam.validation_params);
          if (webParam.lcba) popupUrl = popupUrl + '&lcba=' + encodeURIComponent(webParam.lcba);
          var popupName = 'kakao_link_web_sharer';
          var popupOption = 'location=no,resizable=no,status=no,scrollbars=no,width=460,height=608';

          var popup;
          var isIEBrowser = _k.UA.browser.msie || _k.UA.browser.spartan;
          if (isIEBrowser !== true && popupUrl.length < 2084) {
            popup = _k.windowOpen(popupUrl, popupName, popupOption);
            popup.focus();
          } else {
            popup = webLinkPopup(_k.URL.sharerDomain + '/talk/friends/picker/link', popupOption, popupName, webParam);
          }

          function linkCallback(e) {
            if (e.data === "sent" && e.origin === _k.URL.sharerDomain) {
              settings.callback();
            }
          }
          if (settings.callback && _k.UA.browser.msie) console.log("method 'callback' does not support the Internet Explorer environment.");
          var timer = setInterval(function () {
            if (popup.closed) {
              clearInterval(timer);
              _.removeEvent(window, "message", linkCallback);
            }
          }, 1000);
          _.addEvent(window, "message", linkCallback);
          cleanups.push(function () {
            _.removeEvent(window, "message", linkCallback);
          });
        }

        var isIpad = UA.platform == 'tablet' && UA.os.ios;
        function commonClickEvent(requestFn, settings, type) {
          if (!settings.throughTalk || UA.platform != 'mobile' && !isIpad) {
            return webLink(settings, type);
          }

          var responseHandler;
          if (UA.browser.iphone && /version/.test(UA.ua.toLowerCase())) {
            var response = null;
            responseHandler = function responseHandler(res) {
              response = res;
              return res;
            };
            poller.start(function () {
              return response != null;
            }, function () {
              createAndSendLink(response, settings);
            }, function () {
              settings.fail({ msg: 'The request wait time has expired.', at: 'link.poller' });
            });
          } else responseHandler = createAndSendLink;

          return requestFn(settings).then(function (res) {
            return responseHandler(res, settings);
          }, function (err) {
            settings.fail(err);
          });
        }

        function createAndSendLink(res, settings) {
          var kakaoLink = new KakaoLink();
          kakaoLink.extras = _.extend(kakaoLink.extras, settings.extras);
          if (settings.serverCallbackArgs) kakaoLink.extras.lcba = stringifyLCBA(settings.serverCallbackArgs);
          kakaoLink.template_json = res.template_msg;
          kakaoLink.template_args = res.template_args;
          kakaoLink.template_id = res.template_id;
          var url = linkScheme + '://send?' + _.buildQueryString(kakaoLink);
          var validation_talk = JSON.stringify(kakaoLink);

          if (validation_talk.length > 10000) {
            throw new _k.KakaoError('Failed to send message because it exceeds the message size limit. Please contact the app administrator.');
          }

          if (UA.platform == 'mobile' || isIpad) {
            sendLink(url, settings.fail, settings.installTalk);
          }

          var response = {
            template_msg: res.template_msg || {},
            warning_msg: res.warning_msg || {},
            argument_msg: res.argument_msg || {}
          };

          settings.success(response);
          return response;
        }

        function stringifyLCBA(lcba) {
          return _.isObject(lcba) ? JSON.stringify(lcba) : lcba;
        }

        Link.sendCustom = function (settings) {
          var settings = _k.processRules(settings, rules.custom, 'Link.sendCustomTemplate');
          return commonClickEvent(validateRequest, settings, linkType.custom);
        };

        Link.sendScrap = function (settings) {
          var settings = _k.processRules(settings, rules.scrap, 'Link.sendScrap');
          return commonClickEvent(scrapRequest, settings, linkType.scrap);
        };


        Link.sendDefault = function (settings) {
          if (!settings.objectType) {
            throw new _k.KakaoError('objectType is required for KakaoTalk Link');
          }
          var settings = _k.processRules(settings, rules[settings.objectType], 'Link.sendDefault');
          return commonClickEvent(defaultRequest, settings, linkType.defaultType);
        };


        Link.uploadImage = function (settings) {
          settings = _k.processRules(settings, rules.uploadImage, 'Link.uploadImage');
          return uploadImageRequest(settings);
        };

        function uploadImageRequest(settings) {
          return _api.request({
            url: '/v2/api/talk/message/image/upload',
            data: {
              file: settings.file
            }
          });
        }

        Link.deleteImage = function (settings) {
          settings = _k.processRules(settings, rules.deleteImage, 'Link.deleteImage');
          return deleteImageRequest(settings);
        };

        function deleteImageRequest(settings) {
          return _api.request({
            url: '/v2/api/talk/message/image/delete',
            data: {
              image_url: settings.imageUrl
            }
          });
        }

        Link.scrapImage = function (settings) {
          settings = _k.processRules(settings, rules.scrapImage, 'Link.scrapImage');
          return scrapImageRequest(settings);
        };

        function scrapImageRequest(settings) {
          return _api.request({
            url: '/v2/api/talk/message/image/scrap',
            data: {
              image_url: settings.imageUrl
            }
          });
        }

        var types = ['feed', 'list', 'location', 'commerce', 'text'];
        var rules = {
          talkLink: {
            optional: {
              label: _.passesOneOf([_.isString, _.isObject]),
              image: _.isObject,
              webImage: _.isObject,
              webButton: _.isObject,
              webLink: _.isObject,
              appButton: _.isObject,
              appLink: _.isObject,
              horizontalButton: _.isArray,
              fail: _.isFunction,
              installTalk: _.isBoolean,
              forwardable: _.isBoolean,
              extras: _.isObject
            },
            before: function before(settings) {
              if (_.isString(settings.label)) {
                settings.label = { text: settings.label };
              }
            },
            defaults: {
              installTalk: true,
              forwardable: false,
              fail: _.emptyFunc
            }
          },
          custom: {
            required: {
              templateId: _.isNumber
            },
            optional: {
              templateArgs: _.isObject,
              installTalk: _.isBoolean,
              fail: _.isFunction,
              always: _.isFunction,
              success: _.isFunction,
              extras: _.isObject,
              callback: _.isFunction,
              serverCallbackArgs: _.passesOneOf([_.isJSONString, _.isObject]),
              throughTalk: _.isBoolean
            },
            defaults: {
              templateArgs: {},
              installTalk: false,
              fail: _.emptyFunc,
              always: _.emptyFunc,
              success: _.emptyFunc,
              callback: _.emptyFunc,
              throughTalk: true
            }
          },
          scrap: {
            required: {
              requestUrl: _.isString
            },
            optional: {
              templateId: _.isNumber,
              templateArgs: _.isObject,
              installTalk: _.isBoolean,
              fail: _.isFunction,
              always: _.isFunction,
              success: _.isFunction,
              extras: _.isObject,
              callback: _.isFunction,
              serverCallbackArgs: _.passesOneOf([_.isJSONString, _.isObject]),
              throughTalk: _.isBoolean
            },
            defaults: {
              templateArgs: {},
              installTalk: false,
              fail: _.emptyFunc,
              always: _.emptyFunc,
              success: _.emptyFunc,
              callback: _.emptyFunc,
              throughTalk: true
            }
          },
          feed: {
            required: {
              objectType: _.isOneOf(types),
              content: _.isObject
            },
            optional: {
              social: _.isObject,
              buttonTitle: _.isString,
              buttons: _.isArray,
              installTalk: _.isBoolean,
              fail: _.isFunction,
              always: _.isFunction,
              success: _.isFunction,
              extras: _.isObject,
              callback: _.isFunction,
              serverCallbackArgs: _.passesOneOf([_.isJSONString, _.isObject]),
              throughTalk: _.isBoolean
            },
            defaults: {
              installTalk: false,
              fail: _.emptyFunc,
              always: _.emptyFunc,
              success: _.emptyFunc,
              callback: _.emptyFunc,
              throughTalk: true
            }
          },
          commerce: {
            required: {
              objectType: _.isOneOf(types),
              content: _.isObject,
              commerce: _.isObject
            },
            optional: {
              buttonTitle: _.isString,
              buttons: _.isArray,
              installTalk: _.isBoolean,
              fail: _.isFunction,
              always: _.isFunction,
              success: _.isFunction,
              extras: _.isObject,
              callback: _.isFunction,
              serverCallbackArgs: _.passesOneOf([_.isJSONString, _.isObject]),
              throughTalk: _.isBoolean
            },
            defaults: {
              installTalk: false,
              fail: _.emptyFunc,
              always: _.emptyFunc,
              success: _.emptyFunc,
              callback: _.emptyFunc,
              throughTalk: true
            }
          },
          list: {
            required: {
              objectType: _.isOneOf(types),
              headerTitle: _.isString,
              headerLink: _.isObject,
              contents: _.isArray
            },
            optional: {
              buttonTitle: _.isString,
              buttons: _.isArray,
              headerImageUrl: _.isString,
              headerImageWidth: _.isNumber,
              headerImageHeight: _.isNumber,
              installTalk: _.isBoolean,
              fail: _.isFunction,
              always: _.isFunction,
              success: _.isFunction,
              extras: _.isObject,
              callback: _.isFunction,
              serverCallbackArgs: _.passesOneOf([_.isJSONString, _.isObject]),
              throughTalk: _.isBoolean
            },
            defaults: {
              installTalk: false,
              fail: _.emptyFunc,
              always: _.emptyFunc,
              success: _.emptyFunc,
              callback: _.emptyFunc,
              throughTalk: true
            }
          },
          location: {
            required: {
              objectType: _.isOneOf(types),
              content: _.isObject,
              address: _.isString
            },
            optional: {
              addressTitle: _.isString,
              social: _.isObject,
              buttonTitle: _.isString,
              buttons: _.isArray,
              installTalk: _.isBoolean,
              fail: _.isFunction,
              always: _.isFunction,
              success: _.isFunction,
              extras: _.isObject,
              callback: _.isFunction,
              serverCallbackArgs: _.passesOneOf([_.isJSONString, _.isObject]),
              throughTalk: _.isBoolean
            },
            defaults: {
              installTalk: false,
              fail: _.emptyFunc,
              always: _.emptyFunc,
              success: _.emptyFunc,
              callback: _.emptyFunc,
              throughTalk: true
            }
          },
          text: {
            required: {
              objectType: _.isOneOf(types),
              text: _.isString,
              link: _.isObject
            },
            optional: {
              buttonTitle: _.isString,
              buttons: _.isArray,
              installTalk: _.isBoolean,
              fail: _.isFunction,
              always: _.isFunction,
              success: _.isFunction,
              extras: _.isObject,
              callback: _.isFunction,
              serverCallbackArgs: _.passesOneOf([_.isJSONString, _.isObject]),
              throughTalk: _.isBoolean
            },
            defaults: {
              installTalk: false,
              fail: _.emptyFunc,
              always: _.emptyFunc,
              success: _.emptyFunc,
              callback: _.emptyFunc,
              throughTalk: true
            }
          },
          uploadImage: {
            required: {
              file: _.isObject
            },
            optional: {
              always: _.isFunction,
              success: _.isFunction
            },
            defaults: {
              always: _.emptyFunc,
              success: _.emptyFunc
            }
          },
          deleteImage: {
            required: {
              imageUrl: _.isString
            },
            optional: {
              always: _.isFunction,
              success: _.isFunction
            },
            defaults: {
              always: _.emptyFunc,
              success: _.emptyFunc
            }
          },
          scrapImage: {
            required: {
              imageUrl: _.isString
            },
            optional: {
              always: _.isFunction,
              success: _.isFunction
            },
            defaults: {
              always: _.emptyFunc,
              success: _.emptyFunc
            }
          }
        };

        rules.createTalkLink = _.extend({
          required: { container: _.passesOneOf([_.isElement, _.isString]) }
        }, rules.talkLink);

        rules.createCustom = _.defaults({
          required: _.extend({ container: _.passesOneOf([_.isElement, _.isString]) }, rules.custom.required)
        }, rules.custom);

        rules.createScrap = _.defaults({
          required: _.extend({ container: _.passesOneOf([_.isElement, _.isString]) }, rules.scrap.required)
        }, rules.scrap);

        rules.createDefaultFeed = _.defaults({
          required: _.extend({ container: _.passesOneOf([_.isElement, _.isString]) }, rules.feed.required)
        }, rules.feed);

        rules.createDefaultList = _.defaults({
          required: _.extend({ container: _.passesOneOf([_.isElement, _.isString]) }, rules.list.required)
        }, rules.list);

        rules.createDefaultLocation = _.defaults({
          required: _.extend({ container: _.passesOneOf([_.isElement, _.isString]) }, rules.location.required)
        }, rules.location);

        rules.createDefaultCommerce = _.defaults({
          required: _.extend({ container: _.passesOneOf([_.isElement, _.isString]) }, rules.commerce.required)
        }, rules.commerce);

        rules.createDefaultText = _.defaults({
          required: _.extend({ container: _.passesOneOf([_.isElement, _.isString]) }, rules.text.required)
        }, rules.text);

        var linkScheme = function () {
          var phase = 'release';
          if (_k.UA.os.ios && (phase === "alpha" || phase === "sandbox")) {
            return "alphalink";
          } else {
            return "kakaolink";
          }
        }();

        function buildLinkUrl(settings, callerMsg) {
          var link = new KakaoTalkLink();
          link.forwardable = settings.forwardable;
          link.extras = _.extend(link.extras, settings.extras);

          _.each(settings, function (setting, key) {
            var obj = linkObj.create(setting, key, callerMsg);
            if (obj) {
              link.objs.push(obj);
            }
          });
          return linkScheme + '://send?' + _.buildQueryString(link);
        }

        function validateRequest(settings) {
          return _api.request({
            url: '/v2/api/kakaolink/talk/template/validate',
            data: customObj(settings)
          });
        }

        function scrapRequest(settings) {
          return _api.request({
            url: '/v2/api/kakaolink/talk/template/scrap',
            data: scrapObj(settings)
          });
        }

        function defaultRequest(settings) {
          return _api.request({
            url: '/v2/api/kakaolink/talk/template/default',
            data: defaultObj(settings)
          });
        }

        function sendLink(url, unsupportedCallback, shouldInstallTalk) {
          var androidIntent = "intent:" + url + "#Intent;launchFlags=0x14008000;" + (shouldInstallTalk === true ? 'package=com.kakao.talk;' : '') + "end;";
          var web2appOptions = {
            urlScheme: url,
            intentURI: androidIntent,
            appName: 'KakaoTalk',
            storeURL: _k.getInstallUrl(KAKAOTALK_ANDROID_PACAKGE_NAME, KAKAOTALK_IOS_APP_ID),
            onUnsupportedEnvironment: function onUnsupportedEnvironment() {
              unsupportedCallback(url);
            }
          };
          if (!shouldInstallTalk || webViewChecker.isIOSKakaoTalkWebView() || webViewChecker.isAndroidWebView()) {
            web2appOptions.onAppMissing = _.emptyFunc;
          }

          if (webViewChecker.isIOSKakaoTalkWebView()) {
            web2appOptions.universalLink = undefined;
          }

          try {
            web2app(web2appOptions);
          } catch (e) {
            console.log(e);
          }
        }

        Link.cleanup = function () {
          _.each(cleanups, function (func, i) {
            func();
          });
          cleanups.length = 0;
        };

        return Link;
      }();
    }, { "../vendor/userAgent.js": 33, "../vendor/web2app.js": 34, "./API": 4, "./common.js": 19, "./link.obj.js": 22, "./link.poller": 23, "./util.js": 28, "./webviewchecker.js": 29 }], 22: [function (require, module, exports) {
      module.exports = function () {
        var _ = require('./util.js');
        var _k = require('./common');

        var ACTION_TYPE = {
          WEB: 'web',
          INWEB: 'inweb',
          APP: 'app'
        };
        var commonOptional = {
          displayType: _.isOneOf(['both', 'sender', 'receiver'])
        };

        function imageSizeValidator(sizeValue) {
          var parsed = parseInt(sizeValue, 10);

          if (isNaN(parsed) || parsed < 80) {
            throw new _k.KakaoError('Illegal argument for image: width/height should be a number larger than 80');
          }

          return true;
        }

        function parseImageSize(image) {
          image.width = parseInt(image.width, 10);
          image.height = parseInt(image.height, 10);
        }

        function buttonObjValidator(buttonObj) {
          var buttonObjKey = _.keys(buttonObj)[0];
          if (buttonObjKey === 'webButton') {
            _k.processRules(buttonObj.webButton, rules[buttonObjKey], "parameter webButton in Link.createTalkLink");
          } else {
            _k.processRules(buttonObj.appButton, rules[buttonObjKey], "parameter appButton in Link.createTalkLink");
          }
          return true;
        }

        function getHorizontalButtonObj(setting) {
          var leftButtonKey = _.keys(setting[0]);
          var rightButtonKey = _.keys(setting[1]);
          var leftButton = setting[0][leftButtonKey];
          var rightButton = setting[1][rightButtonKey];
          return {
            "objtype": "horizontal",
            "subs": [{
              "objtype": "button",
              "text": leftButton.text,
              "action": getAction(leftButton.type, leftButton)
            }, {
              "objtype": "button",
              "text": rightButton.text,
              "action": getAction(rightButton.type, rightButton)
            }],
            "disptype": "both"
          };
        }

        function getLabelObj(setting) {
          return {
            "objtype": "label",
            "text": setting.text,
            "disptype": setting.displayType
          };
        }

        function getImageObj(actionType, setting) {
          return {
            "objtype": "image",
            "src": setting.src,
            "width": setting.width,
            "height": setting.height,
            "action": getAction(actionType, setting),
            "disptype": setting.displayType
          };
        }

        function getButtonObj(actionType, setting) {
          return {
            "objtype": "button",
            "text": setting.text,
            "action": getAction(actionType, setting),
            "disptype": setting.displayType
          };
        }

        function getLinkObj(actionType, setting) {
          return {
            "objtype": "link",
            "text": setting.text,
            "action": getAction(actionType, setting),
            "disptype": setting.displayType
          };
        }

        function getAction(actionType, setting) {
          switch (actionType) {
            case "web":
              return getWebAction();
            case "app":
              return getAppAction();
            default:
              return undefined;
          }

          function getWebAction() {
            return {
              "type": setting.type,
              "url": setting.url ? formatUrl(setting.url) : undefined,
              "auth": setting.auth
            };

            function formatUrl(maybeUrl) {
              if (maybeUrl.indexOf("://") > -1) {
                return maybeUrl;
              } else {
                return "http://" + maybeUrl;
              }
            }
          }

          function getAppAction() {
            return {
              "type": "app",
              "url": setting.webUrl,
              "actioninfo": getAppActionInfos(setting.execParams, setting.marketParams)
            };

            function getAppActionInfos(execParams, marketParams) {
              var baseInfos = {
                android: {
                  "os": "android"
                },
                iphone: {
                  "os": "ios",
                  "devicetype": "phone"
                },
                ipad: {
                  "os": "ios",
                  "devicetype": "pad"
                }
              };

              if (execParams) {
                execParams = _k.processRules(execParams, ruleAppParams, 'execParams in Kakao.Link');
              }

              if (marketParams) {
                marketParams = _k.processRules(marketParams, ruleAppParams, 'marketParams in Kakao.Link');
              }

              var actionInfos = [];
              _.each(baseInfos, function (baseInfo, platform) {
                var info = _.extend({}, baseInfo);

                if (execParams && execParams[platform]) {
                  info.execparam = _.buildQueryString(execParams[platform], false);
                }

                if (marketParams && marketParams[platform]) {
                  info.marketparam = _.buildQueryString(marketParams[platform], false);
                }

                if (info.execparam || info.marketparam) {
                  actionInfos.push(info);
                }
              });
              return actionInfos;
            }
          }
        }

        function getButton(setting) {
          return {
            "title": setting.title,
            "link": getLink(setting.link)
          };
        }

        function getButtons(settings) {
          return _.map(settings, function (setting) {
            return {
              "title": setting.title,
              "link": getLink(setting.link)
            };
          });
        }

        function getSocial(setting) {
          return {
            "like_count": setting.likeCount,
            "comment_count": setting.commentCount,
            "shared_count": setting.sharedCount,
            "view_count": setting.viewCount,
            "subscriber_count": setting.subscriberCount
          };
        }

        function getContent(setting) {
          return {
            "title": setting.title,
            "image_url": setting.imageUrl,
            "link": getLink(setting.link),
            "image_width": setting.imageWidth,
            "image_height": setting.imageHeight,
            "description": setting.description
          };
        }

        function getContents(settings) {
          if (settings.length < 2) {
            throw new _k.KakaoError('Illegal argument for contents: min count(2)');
          }
          return _.map(settings, function (setting) {
            return {
              "title": setting.title,
              "image_url": setting.imageUrl,
              "link": getLink(setting.link),
              "image_width": setting.imageWidth,
              "image_height": setting.imageHeight,
              "description": setting.description
            };
          });
        }

        function getLink(setting) {
          return {
            'web_url': setting.webUrl,
            'mobile_web_url': setting.mobileWebUrl,
            'android_execution_params': setting.androidExecParams,
            'ios_execution_params': setting.iosExecParams
          };
        }

        function getCommerce(setting) {
          return {
            "regular_price": setting.regularPrice,
            "discount_price": setting.discountPrice,
            "discount_rate": setting.discountRate,
            "fixed_discount_price": setting.fixedDiscountPrice,
            "product_name": setting.productName
          };
        }

        function contentValidator(obj) {
          _k.processRules(obj, rules['content'], "parameter content in Link.sendDefault");
          return true;
        }

        function linkValidator(linkObj) {
          _k.processRules(linkObj, rules['link'], "parameter link in Link.sendDefault");
          return true;
        }

        function buttonValidator(buttonObj) {
          _k.processRules(buttonObj, rules['button'], "parameter button in Link.sendDefault");
          return true;
        }

        var rules = {
          label: {
            required: {
              text: _.isString
            },
            optional: commonOptional,
            builder: getLabelObj
          },
          image: {
            required: {
              src: _.isString,
              width: imageSizeValidator,
              height: imageSizeValidator
            },
            optional: commonOptional,
            before: parseImageSize,
            builder: _.partial(getImageObj, null)
          },
          webImage: {
            required: {
              src: _.isString,
              width: imageSizeValidator,
              height: imageSizeValidator
            },
            optional: _.extend({
              url: _.isString,
              auth: _.isBoolean,
              type: _.isOneOf([ACTION_TYPE.WEB, ACTION_TYPE.INWEB])
            }, commonOptional),
            defaults: {
              type: ACTION_TYPE.WEB
            },
            before: parseImageSize,
            builder: _.partial(getImageObj, "web")
          },
          webButton: {
            optional: _.extend({
              text: _.isString,
              url: _.isString,
              auth: _.isBoolean,
              type: _.isOneOf(['web', 'inweb'])
            }, commonOptional),
            defaults: {
              type: 'web'
            },
            builder: _.partial(getButtonObj, "web")
          },
          appButton: {
            optional: _.extend({
              text: _.isString,
              webUrl: _.isString,
              execParams: _.isObject,
              marketParams: _.isObject,
              type: _.isString
            }, commonOptional),
            defaults: {
              type: 'app'
            },
            builder: _.partial(getButtonObj, "app")
          },
          webLink: {
            required: { text: _.isString },
            optional: _.extend({
              url: _.isString,
              auth: _.isBoolean,
              type: _.isOneOf(['web', 'inweb'])
            }, commonOptional),
            defaults: {
              type: 'web'
            },
            builder: _.partial(getLinkObj, "web")
          },
          appLink: {
            required: { text: _.isString },
            optional: _.extend({
              webUrl: _.isString,
              execParams: _.isObject,
              marketParams: _.isObject
            }, commonOptional),
            builder: _.partial(getLinkObj, "app")
          },
          horizontalButton: {
            required: {
              0: buttonObjValidator,
              1: buttonObjValidator
            },
            builder: getHorizontalButtonObj
          },
          content: {
            required: {
              title: _.isString,
              imageUrl: _.isString,
              link: linkValidator
            },
            optional: {
              imageWidth: _.isNumber,
              imageHeight: _.isNumber,
              description: _.isString
            },
            builder: getContent
          },
          contents: {
            optional: {
              0: contentValidator,
              1: contentValidator,
              2: contentValidator
            },
            builder: getContents
          },
          commerce: {
            required: {
              regularPrice: _.isNumber
            },
            optional: {
              discountPrice: _.isNumber,
              discountRate: _.isNumber,
              fixedDiscountPrice: _.isNumber,
              productName: _.isString
            },
            builder: getCommerce
          },
          social: {
            optional: {
              likeCount: _.isNumber,
              commentCount: _.isNumber,
              sharedCount: _.isNumber,
              viewCount: _.isNumber,
              subscriberCount: _.isNumber
            },
            builder: getSocial
          },
          button: {
            required: {
              title: _.isString,
              link: linkValidator
            },
            builder: getButton
          },
          buttons: {
            optional: {
              0: buttonValidator,
              1: buttonValidator
            },
            builder: getButtons
          },
          headerLink: {
            optional: {
              webUrl: _.isString,
              mobileWebUrl: _.isString,
              androidExecParams: _.isString,
              iosExecParams: _.isString
            },
            builder: getLink
          },
          link: {
            optional: {
              webUrl: _.isString,
              mobileWebUrl: _.isString,
              androidExecParams: _.isString,
              iosExecParams: _.isString
            },
            builder: getLink
          }
        };

        var ruleAppParams = {
          optional: { iphone: _.isObject, ipad: _.isObject, android: _.isObject }
        };

        return {
          create: function create(setting, key, callerMsg) {
            var linkObjectRule = rules[key];
            if (linkObjectRule) {
              setting = _k.processRules(setting, linkObjectRule, "parameter '" + key + "' in " + (callerMsg || "Link"));
              return linkObjectRule.builder(setting);
            }
          }
        };
      }();
    }, { "./common": 19, "./util.js": 28 }], 23: [function (require, module, exports) {
      module.exports = function () {
        var INTERVAL = 100;
        var TIMEOUT = 10001;

        var elapsed = 0;
        var timeoutIds = [];

        function _stop2() {
          for (var i = 0; i < timeoutIds.length; ++i) {
            clearTimeout(timeoutIds[i]);
          } timeoutIds = [];
        }
        function init() {
          elapsed = 0;
          _stop2();
        }
        return {
          start: function start(stopConditionFunc, success, fail) {
            init();
            for (var i = 1; i * INTERVAL < TIMEOUT; ++i) {
              var timeoutId = setTimeout(function () {
                elapsed += INTERVAL;
                if (stopConditionFunc()) {
                  _stop2();
                  success();
                } else if (elapsed + INTERVAL > TIMEOUT) {
                  _stop2();
                  fail();
                }
              }, i * INTERVAL);
              timeoutIds.push(timeoutId);
            }
          },
          stop: function stop() {
            _stop2();
          }
        };
      }();
    }, {}], 24: [function (require, module, exports) {
      module.exports = function (root) {
        root.Kakao = root.Kakao || {};
        var Kakao = root.Kakao;

        var _ = require('./util');
        var _k = require('./common');

        Kakao.VERSION = _k.VERSION;

        Kakao.Story = require('./story.js');

        Kakao.init = function (appKey) {
          if (_k.RUNTIME.appKey) {
            throw new _k.KakaoError('Kakao.init: Already initialized');
          }

          if (!_.isString(appKey) || appKey === _k.DUMMY_KEY) {
            throw new _k.KakaoError('Kakao.init: App key must be provided');
          }

          _k.RUNTIME.appKey = appKey;

          Kakao.Auth = require('./Auth');

          Kakao.API = require('./API');

          Kakao.Link = require('./link.js');

          Kakao.Navi = require('./navi.js');

          Kakao.PlusFriend = require('./plusFriend.js');
          Kakao.Channel = require('./channel.js');
        };

        Kakao.isInitialized = function () {
          return !!_k.RUNTIME.appKey;
        };

        Kakao.cleanup = function () {
          Kakao.Auth && Kakao.Auth.cleanup();
          Kakao.API && Kakao.API.cleanup();
          Kakao.Link && Kakao.Link.cleanup();
          Kakao.Story && Kakao.Story.cleanup();
          Kakao.PlusFriend && Kakao.PlusFriend.cleanup();
          Kakao.Channel && Kakao.Channel.cleanup();

          _.nullify(_k.RUNTIME);
        };

        if (window.kakaoAsyncInit) {
          window.kakaoAsyncInit();
        }

        return Kakao;
      }(window);
    }, { "./API": 4, "./Auth": 9, "./channel.js": 18, "./common": 19, "./link.js": 21, "./navi.js": 25, "./plusFriend.js": 26, "./story.js": 27, "./util": 28 }], 25: [function (require, module, exports) {
      module.exports = function () {
        var _ = require('./util.js');
        var _k = require('./common');
        var web2app = require('../vendor/web2app.js');

        var ANDROID_NAVI_PACKAGE_NAME = "com.locnall.KimGiSa";
        var IOS_NAVI_APP_ID = "417698849";

        var Navi = {};


        Navi.start = function (settings) {
          settings = _k.processRules(settings, rules.spot);
          var appScheme = buildNaviScheme(settings);
          var webUrl = encodeURIComponent(appScheme.replace(_k.URL.navi, _k.URL.naviWeb));
          web2app({
            urlScheme: appScheme,
            intentURI: "intent:" + appScheme + "#Intent;package=" + ANDROID_NAVI_PACKAGE_NAME + ";S.browser_fallback_url=" + webUrl + ";end;",
            storeURL: appScheme.replace(_k.URL.navi, _k.URL.naviWeb),
            universalLink: appScheme.replace(_k.URL.navi, _k.URL.naviWeb)
          });
        };

        Navi.share = function (settings) {
          settings = _k.processRules(settings, shareRules.spot);
          var appScheme = buildShareNaviScheme(settings);
          var webUrl = encodeURIComponent(appScheme.replace(_k.URL.naviShare, _k.URL.naviWeb));
          web2app({
            urlScheme: appScheme,
            intentURI: "intent:" + appScheme + "#Intent;package=" + ANDROID_NAVI_PACKAGE_NAME + ";S.browser_fallback_url=" + webUrl + ";end;",
            storeURL: appScheme.replace(_k.URL.naviShare, _k.URL.naviWeb),
            universalLink: appScheme.replace(_k.URL.naviShare, _k.URL.naviWeb)
          });
        };

        var NaviMeta = function NaviMeta() {
          this.appkey = _k.RUNTIME.appKey;
          this.apiver = '1.0';
          this.extras = {
            "KA": _k.KAKAO_AGENT
          };
        };

        var rules = {
          spot: {
            required: {
              name: _.isString,
              x: _.isNumber,
              y: _.isNumber
            },
            optional: {
              coordType: _.isOneOf(["wgs84", "katec"]),
              vehicleType: _.isOneOf([1, 2, 3, 4, 5, 6, 7]),
              rpOption: _.isOneOf([1, 2, 3, 4, 5, 6, 8, 100]),
              routeInfo: _.isBoolean,
              sX: _.isNumber,
              sY: _.isNumber,
              sAngle: _.isNumber,
              returnUri: _.isString,
              rpflag: _.isString,
              cid: _.isString,
              guideId: _.isNumber,
              viaPoints: function viaPoints(points) {
                if (!_.isArray(points)) {
                  return false;
                } else if (points.length > 3) {
                  throw new Error("via points should not be exceed 3");
                } else {
                  _.each(points, function (via) {
                    return _k.processRules(via, rules.viaPoint);
                  });
                }
                return true;
              }
            },
            destinationBuilder: function destinationBuilder(settings) {
              return {
                "name": settings.name,
                "x": settings.x,
                "y": settings.y,
                "rpflag": settings.rpflag,
                "cid": settings.cid,
                "guide_id": settings.guideId
              };
            },
            optionBuilder: function optionBuilder(settings) {
              return {
                coord_type: settings.coordType,
                vehicle_type: settings.vehicleType,
                rpoption: settings.rpOption,
                route_info: settings.routeInfo,
                s_x: settings.sX,
                s_y: settings.sY,
                s_angle: settings.sAngle,
                return_uri: settings.returnUri
              };
            }
          },
          viaPoint: {
            required: {
              name: _.isString,
              x: _.isNumber,
              y: _.isNumber
            },
            optional: {
              rpflag: _.isString,
              cid: _.isString
            }
          }
        };

        var shareRules = {
          spot: {
            required: {
              name: _.isString,
              x: _.isNumber,
              y: _.isNumber
            },
            optional: {
              coordType: _.isOneOf(["wgs84", "katec"]),
              rpflag: _.isString,
              cid: _.isString,
              guideId: _.isNumber
            },
            destinationBuilder: function destinationBuilder(settings) {
              return {
                "name": settings.name,
                "x": settings.x,
                "y": settings.y,
                "rpflag": settings.rpflag,
                "cid": settings.cid,
                "guide_id": settings.guideId
              };
            },
            optionBuilder: function optionBuilder(settings) {
              return {
                coord_type: settings.coordType
              };
            }
          }
        };

        function buildNaviScheme(settings) {
          var scheme = new NaviMeta();
          scheme.param = {
            destination: rules.spot.destinationBuilder(settings),
            option: JSON.stringify(rules.spot.optionBuilder(settings)) === '{}' ? undefined : rules.spot.optionBuilder(settings),
            via_list: settings.viaPoints
          };
          return _k.URL.navi + "?" + _.buildQueryString(scheme);
        };

        function buildShareNaviScheme(settings) {
          var scheme = new NaviMeta();
          scheme.param = {
            destination: shareRules.spot.destinationBuilder(settings),
            option: JSON.stringify(shareRules.spot.optionBuilder(settings)) === '{}' ? undefined : shareRules.spot.optionBuilder(settings)
          };
          scheme.scheme_type = 'sharePoi';

          return _k.URL.naviShare + "?" + _.buildQueryString(scheme);
        };

        return Navi;
      }();
    }, { "../vendor/web2app.js": 34, "./common": 19, "./util.js": 28 }], 26: [function (require, module, exports) {
      module.exports = function () {
        var PlusFriend = {};

        var _ = require('./util.js');
        var _k = require('./common.js');
        var browserProxy = require('./browserProxy.js');

        var ADD_POPUP_NAME = 'plus_friend_add_social_plugin';
        var CHAT_POPUP_NAME = 'plus_friend_chat_social_plugin';
        var POPUP_FEATURES = 'width=350, height=510';

        var API_VER = '1.0';

        var cleanups = [];

        PlusFriend.createAddFriendButton = function (settings) {
          settings = _k.processRules(settings, rules.createAddFriendButton, 'PlusFriend.createAddFriendButton');

          var container = _.getElement(settings.container);
          if (!container) {
            throw new _k.KakaoError('container is required for creating PlusFriend.addFriend button: pass in element or id');
          }

          var openUrl = getAddFriendUrl(settings);
          var addFriendIconUrl = getAddFriendIconUrl(settings);
          var anchor = createImageAnchor(openUrl, addFriendIconUrl, '플러스친구 친구 추가 버튼', settings);

          container.appendChild(anchor);

          var handler = function handler(e) {
            if (e.preventDefault) {
              e.preventDefault();
            } else {
              e.returnValue = false;
            }
            _k.windowOpen(openUrl, ADD_POPUP_NAME, POPUP_FEATURES);
          };
          _.addEvent(anchor, 'click', handler);

          var cleanup = function cleanup() {
            container.removeChild(anchor);
            _.removeEvent(anchor, 'click', handler);
          };
          cleanups.push(cleanup);
        };

        PlusFriend.addFriend = function (settings) {
          settings = _k.processRules(settings, rules.addFriend, 'PlusFriend.addFriend');
          var openUrl = getAddFriendUrl(settings);
          _k.windowOpen(openUrl, ADD_POPUP_NAME, POPUP_FEATURES);
        };

        PlusFriend.createChatButton = function (settings) {
          settings = _k.processRules(settings, rules.createChatButton, 'PlusFriend.createChatButton');

          var container = _.getElement(settings.container);
          if (!container) {
            throw new _k.KakaoError('container is required for creating PlusFriend.chat button: pass in element or id');
          }

          var openUrl = getChatUrl(settings);
          var chatIconUrl = getChatIconUrl(settings);
          var anchor = createImageAnchor(openUrl, chatIconUrl, '플러스친구 1:1 채팅 버튼', settings);

          container.appendChild(anchor);

          var handler = function handler(e) {
            if (e.preventDefault) {
              e.preventDefault();
            } else {
              e.returnValue = false;
            }
            _k.windowOpen(openUrl, CHAT_POPUP_NAME, POPUP_FEATURES);
          };
          _.addEvent(anchor, 'click', handler);

          var cleanup = function cleanup() {
            container.removeChild(anchor);
            _.removeEvent(anchor, 'click', handler);
          };
          cleanups.push(cleanup);
        };

        PlusFriend.chat = function (settings) {
          settings = _k.processRules(settings, rules.chat, 'PlusFriend.chat');
          var openUrl = getChatUrl(settings);
          _k.windowOpen(openUrl, CHAT_POPUP_NAME, POPUP_FEATURES);
        };

        function createImageAnchor(href, imageSrc, imageTitle, settings) {
          var anchor = document.createElement('a');
          var image = document.createElement('img');

          anchor.setAttribute('href', '#');

          image.setAttribute('src', imageSrc);
          image.setAttribute('alt', imageTitle);
          image.setAttribute('title', imageTitle);

          if (settings.supportMultipleDensities) image.setAttribute('srcset', [imageSrc.replace('.png', '_2X.png 2x'), imageSrc.replace('.png', '_3X.png 3x')].join(', '));

          anchor.appendChild(image);

          return anchor;
        }

        function getAddFriendIconUrl(settings) {
          var filename = 'friendadd_' + settings.size + '_' + settings.color + '_' + settings.shape;
          var url = _k.URL.resPrefix + '\/logos\/plusfriend\/' + filename + '.png';
          return url;
        }

        function getChatIconUrl(settings) {
          var filename = settings.title + '_' + settings.size + '_' + settings.color + '_' + settings.shape;
          var url = _k.URL.resPrefix + '\/logos\/plusfriend\/' + filename + '.png';
          return url;
        }

        function getAddFriendUrl(settings) {
          var url = _k.URL.plusFriend + '\/' + settings.plusFriendId + '\/friend';
          if (_k.RUNTIME.appKey) url += '?' + buildQueryString();
          return url;
        }

        function getChatUrl(settings) {
          var url = _k.URL.plusFriend + '\/' + settings.plusFriendId + '\/chat';
          if (_k.RUNTIME.appKey) url += '?' + buildQueryString();
          return url;
        }

        function buildQueryString() {
          if (!_k.RUNTIME.appKey) {
            throw _k.KakaoError('The app key does not exist. Please call Kakao.init function.');
          }
          var params = {
            api_ver: API_VER,
            kakao_agent: _k.KAKAO_AGENT,
            app_key: _k.RUNTIME.appKey,
            referer: browserProxy.getOrigin() + location.pathname + location.search
          };
          return _.buildQueryString(params);
        }

        var rules = {
          createAddFriendButton: {
            required: {
              container: _.passesOneOf([_.isElement, _.isString]),
              plusFriendId: _.isString
            },
            optional: {
              color: _.isOneOf(['yellow', 'black']),
              shape: _.isOneOf(['rect', 'round']),
              size: _.isOneOf(['small', 'large']),
              supportMultipleDensities: _.isBoolean
            },
            defaults: function defaults(settings) {
              var container = _.getElement(settings.container);

              return container ? {
                plusFriendId: container.getAttribute('data-plusfriend-id'),
                color: container.getAttribute('data-color') || 'yellow',
                shape: container.getAttribute('data-shape') || 'rect',
                size: container.getAttribute('data-size') || 'small',
                supportMultipleDensities: !!container.getAttribute('data-support-multiple-densities')
              } : null;
            }
          },
          addFriend: {
            required: {
              plusFriendId: _.isString
            }
          },
          createChatButton: {
            required: {
              container: _.passesOneOf([_.isElement, _.isString]),
              plusFriendId: _.isString
            },
            optional: {
              color: _.isOneOf(['yellow', 'mono']),
              shape: _.isOneOf(['pc', 'mobile']),
              size: _.isOneOf(['small', 'large']),
              title: _.isOneOf(['consult', 'question']),
              supportMultipleDensities: _.isBoolean
            },
            defaults: function defaults(settings) {
              var container = _.getElement(settings.container);

              return container ? {
                plusFriendId: container.getAttribute('data-plusfriend-id'),
                color: container.getAttribute('data-color') || 'yellow',
                shape: container.getAttribute('data-shape') || 'pc',
                size: container.getAttribute('data-size') || 'small',
                title: container.getAttribute('data-title') || 'consult',
                supportMultipleDensities: !!container.getAttribute('data-support-multiple-densities')
              } : null;
            }
          },
          chat: {
            required: {
              plusFriendId: _.isString
            }
          }
        };

        PlusFriend.cleanup = function () {
          _.each(cleanups, function (func) {
            func();
          });
          cleanups.length = 0;
        };

        return PlusFriend;
      }();
    }, { "./browserProxy.js": 17, "./common.js": 19, "./util.js": 28 }], 27: [function (require, module, exports) {
      module.exports = function () {
        var Story = {};

        var _ = require('./util.js');
        var _k = require('./common.js');
        var web2app = require('../vendor/web2app.js');

        var POPUP_NAME = 'kakaostory_social_plugin';
        var POPUP_FEATURES = 'width=670, height=471';

        var cleanups = [];

        Story.createShareButton = function (settings) {
          settings = _k.processRules(settings, rules.createShareButton, 'Story.createShareButton');

          var container = _.getElement(settings.container);
          if (!container) {
            throw new _k.KakaoError('container is required for KakaoStory share button: pass in element or id');
          }

          var anchor = document.createElement('a');
          var img = document.createElement('img');

          anchor.appendChild(img);

          var shareUrl = getShareURL(settings.url, settings.text);

          anchor.setAttribute('href', shareUrl);
          anchor.setAttribute('target', '_blank');

          var handler = function handler(e) {
            if (e.preventDefault) {
              e.preventDefault();
            } else {
              e.returnValue = false;
            }

            _k.windowOpen(shareUrl, POPUP_NAME, POPUP_FEATURES);
          };

          _.addEvent(anchor, 'click', handler);

          var cleanup = function cleanup() {
            _.removeEvent(anchor, 'click', handler);
            container.removeChild(anchor);
          };

          cleanups.push(cleanup);

          img.onload = function (e) {
            var width;
            var height;
            container.appendChild(anchor);

            if (_k.UA.browser.msie && parseInt(_k.UA.browser.version.major) <= 10) {
              width = img.width;
              height = img.height;
            } else {
              width = e.target.width;
              height = e.target.height;
            }

            img.width = width;
            img.height = height;
          };

          img.src = _k.URL.storyIcon;
        };

        Story.share = function (settings) {
          settings = _k.processRules(settings, rules.share, 'Story.share');

          var shareUrl = getShareURL(settings.url, settings.text);
          _k.windowOpen(shareUrl, POPUP_NAME, POPUP_FEATURES);
        };

        Story.open = function (settings) {
          settings = _k.processRules(settings, rules.open, 'Story.open');

          var postContent = (settings.text ? settings.text + '\n' : '') + (settings.url || '');
          var domain = location.hostname || '';

          var urlInfo;
          var appName;
          if (settings.urlInfo) {
            urlInfo = _k.processRules(settings.urlInfo, rules.openUrlInfo, 'Story.open');
            appName = urlInfo.name || '';
          }
          var shareUrl = getStoryOpenURL(postContent, domain, appName || domain, JSON.stringify(urlInfo));

          var androidIntent = "intent:" + shareUrl + "#Intent;" + (settings.install === true ? 'package=com.kakao.story;' : '') + "end;";

          var web2appOptions = {
            urlScheme: shareUrl,
            intentURI: androidIntent,
            appname: 'KakaoStory',
            storeURL: _k.getInstallUrl('com.kakao.story', '486244601'),
            onUnsupportedEnvironment: function onUnsupportedEnvironment() {
              settings.fail && settings.fail();
            }
          };

          web2app(web2appOptions);
        };

        var _followButtonFrameId = 0;

        Story.createFollowButton = function (settings) {
          settings = _k.processRules(settings, rules.createFollowButton, 'Story.createFollowButton');

          var container = _.getElement(settings.container);
          if (!container) {
            throw new _k.KakaoError('container is required for KakaoStory follow button: pass in element or id');
          }

          var frame = document.createElement('iframe');
          var frameId = _followButtonFrameId++;

          frame.src = getFollowURL(settings, frameId);
          frame.setAttribute('frameborder', '0');
          frame.setAttribute('marginwidth', '0');
          frame.setAttribute('marginheight', '0');
          frame.setAttribute('scrolling', 'no');

          var width = settings.showFollowerCount && settings.type === 'horizontal' ? 85 : 59;
          var height = settings.showFollowerCount && settings.type === 'vertical' ? 46 : 20;
          frame.style.width = width + 'px';
          frame.style.height = height + 'px';

          var onMessage = function onMessage(e) {
            if (e.data && /\.kakao\.com$/.test(e.origin) && typeof e.data === 'string') {
              var data = e.data.split(',');
              var originFrameId = parseInt(data[0], 10);
              var afterWidth = parseInt(data[1], 10);
              var afterHeight = parseInt(data[2], 10);

              if (originFrameId !== frameId) {
                return;
              }

              if (width !== afterWidth) {
                width = afterWidth;
                frame.style.width = afterWidth + 'px';
              }

              if (height !== afterHeight) {
                height = afterHeight;
                frame.style.height = afterHeight + 'px';
              }
            }
          };

          container.appendChild(frame);
          _.addEvent(window, 'message', onMessage);

          var cleanup = function cleanup() {
            _.removeEvent(window, 'message', onMessage);
            container.removeChild(frame);
          };

          cleanups.push(cleanup);
        };

        var rules = {
          createShareButton: {
            required: {
              container: _.passesOneOf([_.isElement, _.isString])
            },
            optional: {
              url: _.isString,
              text: _.isString
            },
            defaults: function defaults(settings) {
              var container = _.getElement(settings.container);

              return container ? {
                url: container.getAttribute('data-url') || location.href
              } : null;
            }
          },
          share: {
            optional: {
              url: _.isString,
              text: _.isString
            },
            defaults: {
              url: location.href
            }
          },
          open: {
            optional: {
              url: _.isString,
              text: _.isString,
              urlInfo: _.isObject,
              install: _.isBoolean
            },
            defaults: {
              url: location.href,
              install: false
            }
          },
          openUrlInfo: {
            required: {
              title: _.isString
            },
            optional: {
              desc: _.isString,
              name: _.isString,
              images: _.isArray,
              imageurl: _.isArray,
              type: _.isString
            },
            defaults: {
              type: 'website'
            },
            before: function before(params) {
              if (params.images) {
                params.imageurl = params.images;
                delete params.images;
              }
            }
          },
          createFollowButton: {
            required: {
              container: _.passesOneOf([_.isElement, _.isString]),
              id: _.isString
            },
            optional: {
              type: _.isOneOf(['horizontal', 'vertical']),
              showFollowerCount: _.isBoolean
            },
            defaults: function defaults(settings) {
              var container = _.getElement(settings.container);

              if (container) {
                var defaultValues = {
                  type: container.getAttribute('data-type') || 'horizontal',
                  showFollowerCount: container.getAttribute('data-show-follower-count') !== 'false'
                };

                var dataId = container.getAttribute('data-id');
                if (dataId) {
                  defaultValues.id = dataId;
                }

                return defaultValues;
              } else {
                return null;
              }
            },
            after: function after(settings) {
              if (settings.id.substr(0, 1) !== '@') {
                settings.id = '@' + settings.id;
              }
            }
          }
        };

        function getShareURL(url, text) {
          var params = {
            url: url
          };

          if (text) {
            params.text = text;
          }

          _.extend(params, getStatProperties());

          return _k.URL.storyShare + '?' + _.buildQueryString(params);
        }

        function getStoryOpenURL(postContent, serviceDomain, appName, urlInfo) {
          var params = {
            post: postContent,
            appver: _k.VERSION,
            appid: serviceDomain,
            apiver: '1.0',
            appname: appName
          };

          if (urlInfo) {
            params.urlinfo = urlInfo;
          }

          _.extend(params, getStatProperties());

          return 'storylink://posting?' + _.buildQueryString(params);
        }

        function getFollowURL(settings, frameId) {
          var params = {
            id: settings.id,
            type: settings.type,
            hideFollower: !settings.showFollowerCount,
            frameId: frameId
          };

          _.extend(params, getStatProperties());

          return _k.URL.channelFollow + '?' + _.buildQueryString(params);
        }

        function getStatProperties() {
          var props = {
            kakao_agent: _k.KAKAO_AGENT
          };

          if (_k.RUNTIME.appKey) {
            props.app_key = _k.RUNTIME.appKey;
          }

          return props;
        }

        Story.cleanup = function () {
          _.each(cleanups, function (func, i) {
            func();
          });
          cleanups.length = 0;
        };

        return Story;
      }();
    }, { "../vendor/web2app.js": 34, "./common.js": 19, "./util.js": 28 }], 28: [function (require, module, exports) {

      module.exports = function () {
        var _ = {};

        var breaker = {};
        var ArrayProto = Array.prototype;
        var ObjProto = Object.prototype;
        var slice = ArrayProto.slice;
        var concat = ArrayProto.concat;
        var toString = ObjProto.toString;
        var hasOwnProperty = ObjProto.hasOwnProperty;
        var nativeForEach = ArrayProto.forEach;
        var nativeMap = ArrayProto.map;
        var nativeFilter = ArrayProto.filter;
        var nativeEvery = ArrayProto.every;
        var nativeSome = ArrayProto.some;
        var nativeIndexOf = ArrayProto.indexOf;
        var nativeIsArray = Array.isArray;
        var nativeKeys = Object.keys;

        var each = _.each = function (obj, iterator, context) {
          if (obj == null) return obj;
          if (nativeForEach && obj.forEach === nativeForEach) {
            obj.forEach(iterator, context);
          } else if (obj.length === +obj.length) {
            for (var i = 0, length = obj.length; i < length; i++) {
              if (iterator.call(context, obj[i], i, obj) === breaker) return;
            }
          } else {
            var keys = _.keys(obj);
            for (var i = 0, length = keys.length; i < length; i++) {
              if (iterator.call(context, obj[keys[i]], keys[i], obj) === breaker) return;
            }
          }
          return obj;
        };

        _.map = function (obj, iterator, context) {
          var results = [];
          if (obj == null) return results;
          if (nativeMap && obj.map === nativeMap) return obj.map(iterator, context);
          each(obj, function (value, index, list) {
            results.push(iterator.call(context, value, index, list));
          });
          return results;
        };

        _.filter = function (obj, predicate, context) {
          var results = [];
          if (obj == null) return results;
          if (nativeFilter && obj.filter === nativeFilter) return obj.filter(predicate, context);
          each(obj, function (value, index, list) {
            if (predicate.call(context, value, index, list)) results.push(value);
          });
          return results;
        };

        _.every = function (obj, predicate, context) {
          predicate || (predicate = _.identity);
          var result = true;
          if (obj == null) return result;
          if (nativeEvery && obj.every === nativeEvery) return obj.every(predicate, context);
          each(obj, function (value, index, list) {
            if (!(result = result && predicate.call(context, value, index, list))) return breaker;
          });
          return !!result;
        };

        var any = _.any = function (obj, predicate, context) {
          predicate || (predicate = _.identity);
          var result = false;
          if (obj == null) return result;
          if (nativeSome && obj.some === nativeSome) return obj.some(predicate, context);
          each(obj, function (value, index, list) {
            if (result || (result = predicate.call(context, value, index, list))) return breaker;
          });
          return !!result;
        };

        _.contains = function (obj, target) {
          if (obj == null) return false;
          if (nativeIndexOf && obj.indexOf === nativeIndexOf) return obj.indexOf(target) != -1;
          return any(obj, function (value) {
            return value === target;
          });
        };

        _.difference = function (array) {
          var rest = concat.apply(ArrayProto, slice.call(arguments, 1));
          return _.filter(array, function (value) {
            return !_.contains(rest, value);
          });
        };

        _.partial = function (func) {
          var boundArgs = slice.call(arguments, 1);
          return function () {
            var position = 0;
            var args = boundArgs.slice();
            for (var i = 0, length = args.length; i < length; i++) {
              if (args[i] === _) args[i] = arguments[position++];
            }
            while (position < arguments.length) {
              args.push(arguments[position++]);
            } return func.apply(this, args);
          };
        };

        _.after = function (times, func) {
          return function () {
            if (--times < 1) {
              return func.apply(this, arguments);
            }
          };
        };

        _.keys = function (obj) {
          if (!_.isObject(obj)) return [];
          if (nativeKeys) return nativeKeys(obj);
          var keys = [];
          for (var key in obj) {
            if (_.has(obj, key)) keys.push(key);
          } return keys;
        };

        _.extend = function (obj) {
          each(slice.call(arguments, 1), function (source) {
            if (source) {
              for (var prop in source) {
                obj[prop] = source[prop];
              }
            }
          });
          return obj;
        };

        _.defaults = function (obj) {
          each(slice.call(arguments, 1), function (source) {
            if (source) {
              for (var prop in source) {
                if (obj[prop] === void 0) obj[prop] = source[prop];
              }
            }
          });
          return obj;
        };

        _.isElement = function (obj) {
          return !!(obj && obj.nodeType === 1);
        };

        _.isArray = nativeIsArray || function (obj) {
          return toString.call(obj) == '[object Array]';
        };

        _.isObject = function (obj) {
          return obj === Object(obj);
        };

        each(['Arguments', 'Function', 'String', 'Number', 'Date', 'RegExp', 'Blob', 'File', 'FileList'], function (name) {
          _['is' + name] = function (obj) {
            return toString.call(obj) == '[object ' + name + ']';
          };
        });

        _.isBoolean = function (obj) {
          return obj === true || obj === false || toString.call(obj) == '[object Boolean]';
        };

        _.has = function (obj, key) {
          return hasOwnProperty.call(obj, key);
        };

        _.identity = function (value) {
          return value;
        };


        _.isInteger = function (obj) {
          return _.isNumber(obj) && obj % 1 === 0;
        };

        _.emptyFunc = function () { };

        _.getElement = function (selector) {
          if (_.isElement(selector)) {
            return selector;
          } else if (_.isString(selector)) {
            return document.querySelector(selector);
          } else {
            return null;
          }
        };

        _.addEvent = function (element, event, func) {
          if (element.addEventListener) {
            element.addEventListener(event, func, false);
          } else if (element.attachEvent) {
            element.attachEvent("on" + event, func);
          }
        };

        _.removeEvent = function (element, event, func) {
          if (element.removeEventListener) {
            element.removeEventListener(event, func, false);
          } else if (element.detachEvent) {
            element.detachEvent('on' + event, func);
          }
        };

        _.buildQueryString = function (params, encode) {
          var ret = [];
          for (var key in params) {
            if (!params.hasOwnProperty(key)) continue;

            var value = params[key];
            if (_.isObject(value)) {
              value = JSON.stringify(value);
            }

            var queryKey = encode === false ? key : encodeURIComponent(key);
            var queryValue = encode === false ? value : encodeURIComponent(value);

            ret.push(queryKey + '=' + queryValue);
          }

          return ret.join('&');
        };

        _.getRandomString = function () {
          return Math.random().toString(36).slice(2);
        };

        _.nullify = function (obj) {
          _.each(obj, function (value, key) {
            obj[key] = null;
          });
        };

        _.isOneOf = function (elements) {
          return _.partial(_.contains, elements);
        };

        _.passesOneOf = function (validators) {
          if (!_.isArray(validators)) throw new Error('validators should be an Array');

          return function (obj) {
            return _.any(validators, function (validator) {
              return validator(obj);
            });
          };
        };

        _.isURL = function (obj) {
          var urlPattern = /(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/;

          return urlPattern.test(obj);
        };

        _.arrayBufferToString = function (buffer) {
          var stringResult = "";
          var arrayBufferView = new Uint8Array(buffer);
          var length = arrayBufferView.length;
          var CHUNK_SIZE = Math.pow(2, 16);

          var offset, readLength, sub;
          for (offset = 0; offset < length; offset += CHUNK_SIZE) {
            readLength = Math.min(CHUNK_SIZE, length - offset);
            sub = arrayBufferView.subarray(offset, offset + readLength);
            stringResult += String.fromCharCode.apply(null, sub);
          }
          return stringResult;
        };

        _.isJSONString = function (str) {
          try {
            JSON.parse(str);
          } catch (e) {
            return false;
          }
          return true;
        };

        _.localStorage = function () {
          var shim = {
            _data: {},
            setItem: function setItem(id, val) {
              return this._data[id] = String(val);
            },
            getItem: function getItem(id) {
              return this._data.hasOwnProperty(id) ? this._data[id] : null;
            },
            removeItem: function removeItem(id) {
              return delete this._data[id];
            },
            clear: function clear() {
              return this._data = {};
            }
          };

          try {
            if ("localStorage" in window) {
              window.localStorage.setItem("store", "");
              window.localStorage.removeItem("store");
              return window.localStorage;
            } else {
              return shim;
            }
          } catch (e) {
            return shim;
          }
        }();

        return _;
      }();
    }, {}], 29: [function (require, module, exports) {
      module.exports = function () {
        var UA = require('../vendor/userAgent.js')();

        return {
          isAndroidWebView: function isAndroidWebView() {
            return UA.os.android && (olderAndroidWebView() || oldAndroidWebView() || newerAndroidWebView());
          },
          isIOSKakaoTalkWebView: function isIOSKakaoTalkWebView() {
            return UA.os.ios && /KAKAOTALK/i.test(UA.ua);
          },
          isAndroidKakaoTalkWebView: function isAndroidKakaoTalkWebView() {
            return UA.os.android && /KAKAOTALK/i.test(UA.ua);
          },
          isNewerAndroidKakaoTalkWebView: function isNewerAndroidKakaoTalkWebView() {
            return UA.os.android && /KAKAOTALK/i.test(UA.ua) && UA.browser.chrome && UA.browser.version.major >= 71;
          }
        };

        function newerAndroidWebView() {
          return (/Version\/\d+\.\d+/i.test(UA.ua) && (/Chrome\/\d+\.\d+\.\d+\.\d+ Mobile/i.test(UA.ua) || /; wv\)/i.test(UA.ua))
          );
        }

        function oldAndroidWebView() {
          return UA.os.version.major == 4 && UA.os.version.minor < 4 && /Version\/\d+.\d+|/i.test(UA.ua);
        }

        function olderAndroidWebView() {
          return UA.os.version.major == 2 && /Version\/\d+.\d+|/i.test(UA.ua);
        }
      };
    }, { "../vendor/userAgent.js": 33 }], 30: [function (require, module, exports) {
      module.exports = function () {
        var CryptoJS = CryptoJS || function (u, p) {
          var d = {},
            l = d.lib = {},
            s = function s() { },
            t = l.Base = {
              extend: function extend(a) {
                s.prototype = this; var c = new s(); a && c.mixIn(a); c.hasOwnProperty("init") || (c.init = function () {
                  c.$super.init.apply(this, arguments);
                }); c.init.prototype = c; c.$super = this; return c;
              }, create: function create() {
                var a = this.extend(); a.init.apply(a, arguments); return a;
              }, init: function init() { }, mixIn: function mixIn(a) {
                for (var c in a) {
                  a.hasOwnProperty(c) && (this[c] = a[c]);
                } a.hasOwnProperty("toString") && (this.toString = a.toString);
              }, clone: function clone() {
                return this.init.prototype.extend(this);
              }
            },
            r = l.WordArray = t.extend({
              init: function init(a, c) {
                a = this.words = a || []; this.sigBytes = c != p ? c : 4 * a.length;
              }, toString: function toString(a) {
                return (a || v).stringify(this);
              }, concat: function concat(a) {
                var c = this.words,
                  e = a.words,
                  j = this.sigBytes; a = a.sigBytes; this.clamp(); if (j % 4) for (var k = 0; k < a; k++) {
                    c[j + k >>> 2] |= (e[k >>> 2] >>> 24 - 8 * (k % 4) & 255) << 24 - 8 * ((j + k) % 4);
                  } else if (65535 < e.length) for (k = 0; k < a; k += 4) {
                    c[j + k >>> 2] = e[k >>> 2];
                  } else c.push.apply(c, e); this.sigBytes += a; return this;
              }, clamp: function clamp() {
                var a = this.words,
                  c = this.sigBytes; a[c >>> 2] &= 4294967295 << 32 - 8 * (c % 4); a.length = u.ceil(c / 4);
              }, clone: function clone() {
                var a = t.clone.call(this); a.words = this.words.slice(0); return a;
              }, random: function random(a) {
                for (var c = [], e = 0; e < a; e += 4) {
                  c.push(4294967296 * u.random() | 0);
                } return new r.init(c, a);
              }
            }),
            w = d.enc = {},
            v = w.Hex = {
              stringify: function stringify(a) {
                var c = a.words; a = a.sigBytes; for (var e = [], j = 0; j < a; j++) {
                  var k = c[j >>> 2] >>> 24 - 8 * (j % 4) & 255; e.push((k >>> 4).toString(16)); e.push((k & 15).toString(16));
                } return e.join("");
              }, parse: function parse(a) {
                for (var c = a.length, e = [], j = 0; j < c; j += 2) {
                  e[j >>> 3] |= parseInt(a.substr(j, 2), 16) << 24 - 4 * (j % 8);
                } return new r.init(e, c / 2);
              }
            },
            b = w.Latin1 = {
              stringify: function stringify(a) {
                var c = a.words; a = a.sigBytes; for (var e = [], j = 0; j < a; j++) {
                  e.push(String.fromCharCode(c[j >>> 2] >>> 24 - 8 * (j % 4) & 255));
                } return e.join("");
              }, parse: function parse(a) {
                for (var c = a.length, e = [], j = 0; j < c; j++) {
                  e[j >>> 2] |= (a.charCodeAt(j) & 255) << 24 - 8 * (j % 4);
                } return new r.init(e, c);
              }
            },
            x = w.Utf8 = {
              stringify: function stringify(a) {
                try {
                  return decodeURIComponent(escape(b.stringify(a)));
                } catch (c) {
                  throw Error("Malformed UTF-8 data");
                }
              }, parse: function parse(a) {
                return b.parse(unescape(encodeURIComponent(a)));
              }
            },
            q = l.BufferedBlockAlgorithm = t.extend({
              reset: function reset() {
                this._data = new r.init(); this._nDataBytes = 0;
              }, _append: function _append(a) {
                "string" == typeof a && (a = x.parse(a)); this._data.concat(a); this._nDataBytes += a.sigBytes;
              }, _process: function _process(a) {
                var c = this._data,
                  e = c.words,
                  j = c.sigBytes,
                  k = this.blockSize,
                  b = j / (4 * k),
                  b = a ? u.ceil(b) : u.max((b | 0) - this._minBufferSize, 0); a = b * k; j = u.min(4 * a, j); if (a) {
                    for (var q = 0; q < a; q += k) {
                      this._doProcessBlock(e, q);
                    } q = e.splice(0, a); c.sigBytes -= j;
                  } return new r.init(q, j);
              }, clone: function clone() {
                var a = t.clone.call(this);
                a._data = this._data.clone(); return a;
              }, _minBufferSize: 0
            }); l.Hasher = q.extend({
              cfg: t.extend(), init: function init(a) {
                this.cfg = this.cfg.extend(a); this.reset();
              }, reset: function reset() {
                q.reset.call(this); this._doReset();
              }, update: function update(a) {
                this._append(a); this._process(); return this;
              }, finalize: function finalize(a) {
                a && this._append(a); return this._doFinalize();
              }, blockSize: 16, _createHelper: function _createHelper(a) {
                return function (b, e) {
                  return new a.init(e).finalize(b);
                };
              }, _createHmacHelper: function _createHmacHelper(a) {
                return function (b, e) {
                  return new n.HMAC.init(a, e).finalize(b);
                };
              }
            }); var n = d.algo = {}; return d;
        }(Math);
        (function () {
          var u = CryptoJS,
            p = u.lib.WordArray; u.enc.Base64 = {
              stringify: function stringify(d) {
                var l = d.words,
                  p = d.sigBytes,
                  t = this._map; d.clamp(); d = []; for (var r = 0; r < p; r += 3) {
                    for (var w = (l[r >>> 2] >>> 24 - 8 * (r % 4) & 255) << 16 | (l[r + 1 >>> 2] >>> 24 - 8 * ((r + 1) % 4) & 255) << 8 | l[r + 2 >>> 2] >>> 24 - 8 * ((r + 2) % 4) & 255, v = 0; 4 > v && r + 0.75 * v < p; v++) {
                      d.push(t.charAt(w >>> 6 * (3 - v) & 63));
                    }
                  } if (l = t.charAt(64)) for (; d.length % 4;) {
                    d.push(l);
                  } return d.join("");
              }, parse: function parse(d) {
                var l = d.length,
                  s = this._map,
                  t = s.charAt(64); t && (t = d.indexOf(t), -1 != t && (l = t)); for (var t = [], r = 0, w = 0; w < l; w++) {
                    if (w % 4) {
                      var v = s.indexOf(d.charAt(w - 1)) << 2 * (w % 4),
                        b = s.indexOf(d.charAt(w)) >>> 6 - 2 * (w % 4); t[r >>> 2] |= (v | b) << 24 - 8 * (r % 4); r++;
                    }
                  } return p.create(t, r);
              }, _map: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
            };
        })();
        (function (u) {
          function p(b, n, a, c, e, j, k) {
            b = b + (n & a | ~n & c) + e + k; return (b << j | b >>> 32 - j) + n;
          } function d(b, n, a, c, e, j, k) {
            b = b + (n & c | a & ~c) + e + k; return (b << j | b >>> 32 - j) + n;
          } function l(b, n, a, c, e, j, k) {
            b = b + (n ^ a ^ c) + e + k; return (b << j | b >>> 32 - j) + n;
          } function s(b, n, a, c, e, j, k) {
            b = b + (a ^ (n | ~c)) + e + k; return (b << j | b >>> 32 - j) + n;
          } for (var t = CryptoJS, r = t.lib, w = r.WordArray, v = r.Hasher, r = t.algo, b = [], x = 0; 64 > x; x++) {
            b[x] = 4294967296 * u.abs(u.sin(x + 1)) | 0;
          } r = r.MD5 = v.extend({
            _doReset: function _doReset() {
              this._hash = new w.init([1732584193, 4023233417, 2562383102, 271733878]);
            },
            _doProcessBlock: function _doProcessBlock(q, n) {
              for (var a = 0; 16 > a; a++) {
                var c = n + a,
                  e = q[c]; q[c] = (e << 8 | e >>> 24) & 16711935 | (e << 24 | e >>> 8) & 4278255360;
              } var a = this._hash.words,
                c = q[n + 0],
                e = q[n + 1],
                j = q[n + 2],
                k = q[n + 3],
                z = q[n + 4],
                r = q[n + 5],
                t = q[n + 6],
                w = q[n + 7],
                v = q[n + 8],
                A = q[n + 9],
                B = q[n + 10],
                C = q[n + 11],
                u = q[n + 12],
                D = q[n + 13],
                E = q[n + 14],
                x = q[n + 15],
                f = a[0],
                m = a[1],
                g = a[2],
                h = a[3],
                f = p(f, m, g, h, c, 7, b[0]),
                h = p(h, f, m, g, e, 12, b[1]),
                g = p(g, h, f, m, j, 17, b[2]),
                m = p(m, g, h, f, k, 22, b[3]),
                f = p(f, m, g, h, z, 7, b[4]),
                h = p(h, f, m, g, r, 12, b[5]),
                g = p(g, h, f, m, t, 17, b[6]),
                m = p(m, g, h, f, w, 22, b[7]),
                f = p(f, m, g, h, v, 7, b[8]),
                h = p(h, f, m, g, A, 12, b[9]),
                g = p(g, h, f, m, B, 17, b[10]),
                m = p(m, g, h, f, C, 22, b[11]),
                f = p(f, m, g, h, u, 7, b[12]),
                h = p(h, f, m, g, D, 12, b[13]),
                g = p(g, h, f, m, E, 17, b[14]),
                m = p(m, g, h, f, x, 22, b[15]),
                f = d(f, m, g, h, e, 5, b[16]),
                h = d(h, f, m, g, t, 9, b[17]),
                g = d(g, h, f, m, C, 14, b[18]),
                m = d(m, g, h, f, c, 20, b[19]),
                f = d(f, m, g, h, r, 5, b[20]),
                h = d(h, f, m, g, B, 9, b[21]),
                g = d(g, h, f, m, x, 14, b[22]),
                m = d(m, g, h, f, z, 20, b[23]),
                f = d(f, m, g, h, A, 5, b[24]),
                h = d(h, f, m, g, E, 9, b[25]),
                g = d(g, h, f, m, k, 14, b[26]),
                m = d(m, g, h, f, v, 20, b[27]),
                f = d(f, m, g, h, D, 5, b[28]),
                h = d(h, f, m, g, j, 9, b[29]),
                g = d(g, h, f, m, w, 14, b[30]),
                m = d(m, g, h, f, u, 20, b[31]),
                f = l(f, m, g, h, r, 4, b[32]),
                h = l(h, f, m, g, v, 11, b[33]),
                g = l(g, h, f, m, C, 16, b[34]),
                m = l(m, g, h, f, E, 23, b[35]),
                f = l(f, m, g, h, e, 4, b[36]),
                h = l(h, f, m, g, z, 11, b[37]),
                g = l(g, h, f, m, w, 16, b[38]),
                m = l(m, g, h, f, B, 23, b[39]),
                f = l(f, m, g, h, D, 4, b[40]),
                h = l(h, f, m, g, c, 11, b[41]),
                g = l(g, h, f, m, k, 16, b[42]),
                m = l(m, g, h, f, t, 23, b[43]),
                f = l(f, m, g, h, A, 4, b[44]),
                h = l(h, f, m, g, u, 11, b[45]),
                g = l(g, h, f, m, x, 16, b[46]),
                m = l(m, g, h, f, j, 23, b[47]),
                f = s(f, m, g, h, c, 6, b[48]),
                h = s(h, f, m, g, w, 10, b[49]),
                g = s(g, h, f, m, E, 15, b[50]),
                m = s(m, g, h, f, r, 21, b[51]),
                f = s(f, m, g, h, u, 6, b[52]),
                h = s(h, f, m, g, k, 10, b[53]),
                g = s(g, h, f, m, B, 15, b[54]),
                m = s(m, g, h, f, e, 21, b[55]),
                f = s(f, m, g, h, v, 6, b[56]),
                h = s(h, f, m, g, x, 10, b[57]),
                g = s(g, h, f, m, t, 15, b[58]),
                m = s(m, g, h, f, D, 21, b[59]),
                f = s(f, m, g, h, z, 6, b[60]),
                h = s(h, f, m, g, C, 10, b[61]),
                g = s(g, h, f, m, j, 15, b[62]),
                m = s(m, g, h, f, A, 21, b[63]); a[0] = a[0] + f | 0; a[1] = a[1] + m | 0; a[2] = a[2] + g | 0; a[3] = a[3] + h | 0;
            }, _doFinalize: function _doFinalize() {
              var b = this._data,
                n = b.words,
                a = 8 * this._nDataBytes,
                c = 8 * b.sigBytes; n[c >>> 5] |= 128 << 24 - c % 32; var e = u.floor(a / 4294967296); n[(c + 64 >>> 9 << 4) + 15] = (e << 8 | e >>> 24) & 16711935 | (e << 24 | e >>> 8) & 4278255360; n[(c + 64 >>> 9 << 4) + 14] = (a << 8 | a >>> 24) & 16711935 | (a << 24 | a >>> 8) & 4278255360; b.sigBytes = 4 * (n.length + 1); this._process(); b = this._hash; n = b.words; for (a = 0; 4 > a; a++) {
                  c = n[a], n[a] = (c << 8 | c >>> 24) & 16711935 | (c << 24 | c >>> 8) & 4278255360;
                } return b;
            }, clone: function clone() {
              var b = v.clone.call(this); b._hash = this._hash.clone(); return b;
            }
          }); t.MD5 = v._createHelper(r); t.HmacMD5 = v._createHmacHelper(r);
        })(Math);
        (function () {
          var u = CryptoJS,
            p = u.lib,
            d = p.Base,
            l = p.WordArray,
            p = u.algo,
            s = p.EvpKDF = d.extend({
              cfg: d.extend({ keySize: 4, hasher: p.MD5, iterations: 1 }), init: function init(d) {
                this.cfg = this.cfg.extend(d);
              }, compute: function compute(d, r) {
                for (var p = this.cfg, s = p.hasher.create(), b = l.create(), u = b.words, q = p.keySize, p = p.iterations; u.length < q;) {
                  n && s.update(n); var n = s.update(d).finalize(r); s.reset(); for (var a = 1; a < p; a++) {
                    n = s.finalize(n), s.reset();
                  } b.concat(n);
                } b.sigBytes = 4 * q; return b;
              }
            }); u.EvpKDF = function (d, l, p) {
              return s.create(p).compute(d, l);
            };
        })();
        CryptoJS.lib.Cipher || function (u) {
          var p = CryptoJS,
            d = p.lib,
            l = d.Base,
            s = d.WordArray,
            t = d.BufferedBlockAlgorithm,
            r = p.enc.Base64,
            w = p.algo.EvpKDF,
            v = d.Cipher = t.extend({
              cfg: l.extend(), createEncryptor: function createEncryptor(e, a) {
                return this.create(this._ENC_XFORM_MODE, e, a);
              }, createDecryptor: function createDecryptor(e, a) {
                return this.create(this._DEC_XFORM_MODE, e, a);
              }, init: function init(e, a, b) {
                this.cfg = this.cfg.extend(b); this._xformMode = e; this._key = a; this.reset();
              }, reset: function reset() {
                t.reset.call(this); this._doReset();
              }, process: function process(e) {
                this._append(e); return this._process();
              },
              finalize: function finalize(e) {
                e && this._append(e); return this._doFinalize();
              }, keySize: 4, ivSize: 4, _ENC_XFORM_MODE: 1, _DEC_XFORM_MODE: 2, _createHelper: function _createHelper(e) {
                return {
                  encrypt: function encrypt(b, k, d) {
                    return ("string" == typeof k ? c : a).encrypt(e, b, k, d);
                  }, decrypt: function decrypt(b, k, d) {
                    return ("string" == typeof k ? c : a).decrypt(e, b, k, d);
                  }
                };
              }
            }); d.StreamCipher = v.extend({
              _doFinalize: function _doFinalize() {
                return this._process(!0);
              }, blockSize: 1
            }); var b = p.mode = {},
              x = function x(e, a, b) {
                var c = this._iv; c ? this._iv = u : c = this._prevBlock; for (var d = 0; d < b; d++) {
                  e[a + d] ^= c[d];
                }
              },
              q = (d.BlockCipherMode = l.extend({
                createEncryptor: function createEncryptor(e, a) {
                  return this.Encryptor.create(e, a);
                }, createDecryptor: function createDecryptor(e, a) {
                  return this.Decryptor.create(e, a);
                }, init: function init(e, a) {
                  this._cipher = e; this._iv = a;
                }
              })).extend(); q.Encryptor = q.extend({
                processBlock: function processBlock(e, a) {
                  var b = this._cipher,
                    c = b.blockSize; x.call(this, e, a, c); b.encryptBlock(e, a); this._prevBlock = e.slice(a, a + c);
                }
              }); q.Decryptor = q.extend({
                processBlock: function processBlock(e, a) {
                  var b = this._cipher,
                    c = b.blockSize,
                    d = e.slice(a, a + c); b.decryptBlock(e, a); x.call(this, e, a, c); this._prevBlock = d;
                }
              }); b = b.CBC = q; q = (p.pad = {}).Pkcs7 = {
                pad: function pad(a, b) {
                  for (var c = 4 * b, c = c - a.sigBytes % c, d = c << 24 | c << 16 | c << 8 | c, l = [], n = 0; n < c; n += 4) {
                    l.push(d);
                  } c = s.create(l, c); a.concat(c);
                }, unpad: function unpad(a) {
                  a.sigBytes -= a.words[a.sigBytes - 1 >>> 2] & 255;
                }
              }; d.BlockCipher = v.extend({
                cfg: v.cfg.extend({ mode: b, padding: q }), reset: function reset() {
                  v.reset.call(this); var a = this.cfg,
                    b = a.iv,
                    a = a.mode; if (this._xformMode == this._ENC_XFORM_MODE) var c = a.createEncryptor; else c = a.createDecryptor, this._minBufferSize = 1; this._mode = c.call(a, this, b && b.words);
                }, _doProcessBlock: function _doProcessBlock(a, b) {
                  this._mode.processBlock(a, b);
                }, _doFinalize: function _doFinalize() {
                  var a = this.cfg.padding; if (this._xformMode == this._ENC_XFORM_MODE) {
                    a.pad(this._data, this.blockSize); var b = this._process(!0);
                  } else b = this._process(!0), a.unpad(b); return b;
                }, blockSize: 4
              }); var n = d.CipherParams = l.extend({
                init: function init(a) {
                  this.mixIn(a);
                }, toString: function toString(a) {
                  return (a || this.formatter).stringify(this);
                }
              }),
                b = (p.format = {}).OpenSSL = {
                  stringify: function stringify(a) {
                    var b = a.ciphertext; a = a.salt; return (a ? s.create([1398893684, 1701076831]).concat(a).concat(b) : b).toString(r);
                  }, parse: function parse(a) {
                    a = r.parse(a); var b = a.words; if (1398893684 == b[0] && 1701076831 == b[1]) {
                      var c = s.create(b.slice(2, 4)); b.splice(0, 4); a.sigBytes -= 16;
                    } return n.create({ ciphertext: a, salt: c });
                  }
                },
                a = d.SerializableCipher = l.extend({
                  cfg: l.extend({ format: b }), encrypt: function encrypt(a, b, c, d) {
                    d = this.cfg.extend(d); var l = a.createEncryptor(c, d); b = l.finalize(b); l = l.cfg; return n.create({ ciphertext: b, key: c, iv: l.iv, algorithm: a, mode: l.mode, padding: l.padding, blockSize: a.blockSize, formatter: d.format });
                  },
                  decrypt: function decrypt(a, b, c, d) {
                    d = this.cfg.extend(d); b = this._parse(b, d.format); return a.createDecryptor(c, d).finalize(b.ciphertext);
                  }, _parse: function _parse(a, b) {
                    return "string" == typeof a ? b.parse(a, this) : a;
                  }
                }),
                p = (p.kdf = {}).OpenSSL = {
                  execute: function execute(a, b, c, d) {
                    d || (d = s.random(8)); a = w.create({ keySize: b + c }).compute(a, d); c = s.create(a.words.slice(b), 4 * c); a.sigBytes = 4 * b; return n.create({ key: a, iv: c, salt: d });
                  }
                },
                c = d.PasswordBasedCipher = a.extend({
                  cfg: a.cfg.extend({ kdf: p }), encrypt: function encrypt(b, c, d, l) {
                    l = this.cfg.extend(l); d = l.kdf.execute(d, b.keySize, b.ivSize); l.iv = d.iv; b = a.encrypt.call(this, b, c, d.key, l); b.mixIn(d); return b;
                  }, decrypt: function decrypt(b, c, d, l) {
                    l = this.cfg.extend(l); c = this._parse(c, l.format); d = l.kdf.execute(d, b.keySize, b.ivSize, c.salt); l.iv = d.iv; return a.decrypt.call(this, b, c, d.key, l);
                  }
                });
        }();
        (function () {
          for (var u = CryptoJS, p = u.lib.BlockCipher, d = u.algo, l = [], s = [], t = [], r = [], w = [], v = [], b = [], x = [], q = [], n = [], a = [], c = 0; 256 > c; c++) {
            a[c] = 128 > c ? c << 1 : c << 1 ^ 283;
          } for (var e = 0, j = 0, c = 0; 256 > c; c++) {
            var k = j ^ j << 1 ^ j << 2 ^ j << 3 ^ j << 4,
              k = k >>> 8 ^ k & 255 ^ 99; l[e] = k; s[k] = e; var z = a[e],
                F = a[z],
                G = a[F],
                y = 257 * a[k] ^ 16843008 * k; t[e] = y << 24 | y >>> 8; r[e] = y << 16 | y >>> 16; w[e] = y << 8 | y >>> 24; v[e] = y; y = 16843009 * G ^ 65537 * F ^ 257 * z ^ 16843008 * e; b[k] = y << 24 | y >>> 8; x[k] = y << 16 | y >>> 16; q[k] = y << 8 | y >>> 24; n[k] = y; e ? (e = z ^ a[a[a[G ^ z]]], j ^= a[a[j]]) : e = j = 1;
          } var H = [0, 1, 2, 4, 8, 16, 32, 64, 128, 27, 54],
            d = d.AES = p.extend({
              _doReset: function _doReset() {
                for (var a = this._key, c = a.words, d = a.sigBytes / 4, a = 4 * ((this._nRounds = d + 6) + 1), e = this._keySchedule = [], j = 0; j < a; j++) {
                  if (j < d) e[j] = c[j]; else {
                    var k = e[j - 1]; j % d ? 6 < d && 4 == j % d && (k = l[k >>> 24] << 24 | l[k >>> 16 & 255] << 16 | l[k >>> 8 & 255] << 8 | l[k & 255]) : (k = k << 8 | k >>> 24, k = l[k >>> 24] << 24 | l[k >>> 16 & 255] << 16 | l[k >>> 8 & 255] << 8 | l[k & 255], k ^= H[j / d | 0] << 24); e[j] = e[j - d] ^ k;
                  }
                } c = this._invKeySchedule = []; for (d = 0; d < a; d++) {
                  j = a - d, k = d % 4 ? e[j] : e[j - 4], c[d] = 4 > d || 4 >= j ? k : b[l[k >>> 24]] ^ x[l[k >>> 16 & 255]] ^ q[l[k >>> 8 & 255]] ^ n[l[k & 255]];
                }
              }, encryptBlock: function encryptBlock(a, b) {
                this._doCryptBlock(a, b, this._keySchedule, t, r, w, v, l);
              }, decryptBlock: function decryptBlock(a, c) {
                var d = a[c + 1]; a[c + 1] = a[c + 3]; a[c + 3] = d; this._doCryptBlock(a, c, this._invKeySchedule, b, x, q, n, s); d = a[c + 1]; a[c + 1] = a[c + 3]; a[c + 3] = d;
              }, _doCryptBlock: function _doCryptBlock(a, b, c, d, e, j, l, f) {
                for (var m = this._nRounds, g = a[b] ^ c[0], h = a[b + 1] ^ c[1], k = a[b + 2] ^ c[2], n = a[b + 3] ^ c[3], p = 4, r = 1; r < m; r++) {
                  var q = d[g >>> 24] ^ e[h >>> 16 & 255] ^ j[k >>> 8 & 255] ^ l[n & 255] ^ c[p++],
                    s = d[h >>> 24] ^ e[k >>> 16 & 255] ^ j[n >>> 8 & 255] ^ l[g & 255] ^ c[p++],
                    t = d[k >>> 24] ^ e[n >>> 16 & 255] ^ j[g >>> 8 & 255] ^ l[h & 255] ^ c[p++],
                    n = d[n >>> 24] ^ e[g >>> 16 & 255] ^ j[h >>> 8 & 255] ^ l[k & 255] ^ c[p++],
                    g = q,
                    h = s,
                    k = t;
                } q = (f[g >>> 24] << 24 | f[h >>> 16 & 255] << 16 | f[k >>> 8 & 255] << 8 | f[n & 255]) ^ c[p++]; s = (f[h >>> 24] << 24 | f[k >>> 16 & 255] << 16 | f[n >>> 8 & 255] << 8 | f[g & 255]) ^ c[p++]; t = (f[k >>> 24] << 24 | f[n >>> 16 & 255] << 16 | f[g >>> 8 & 255] << 8 | f[h & 255]) ^ c[p++]; n = (f[n >>> 24] << 24 | f[g >>> 16 & 255] << 16 | f[h >>> 8 & 255] << 8 | f[k & 255]) ^ c[p++]; a[b] = q; a[b + 1] = s; a[b + 2] = t; a[b + 3] = n;
              }, keySize: 8
            }); u.AES = p._createHelper(d);
        })();

        return CryptoJS;
      }();
    }, {}], 31: [function (require, module, exports) {
      module.exports = function () {
        (function (O, d, q, L, l, I) {
          var b = this || O; var o = Math.floor(Math.random() * 10000); var r = Function.prototype; var R = /^((http.?:)\/\/([^:\/\s]+)(:\d+)*)/; var S = /[\-\w]+\/\.\.\//; var G = /([^:])\/\//g; var J = ""; var p = {}; var N = O.easyXDM; var V = "easyXDM_"; var F; var z = false; var j; var i; function D(Y, aa) {
            var Z = _typeof(Y[aa]); return Z == "function" || !!(Z == "object" && Y[aa]) || Z == "unknown";
          } function v(Y, Z) {
            return !!(_typeof(Y[Z]) == "object" && Y[Z]);
          } function s(Y) {
            return Object.prototype.toString.call(Y) === "[object Array]";
          } function c() {
            var aa = "Shockwave Flash",
              ae = "application/x-shockwave-flash"; if (!u(navigator.plugins) && _typeof(navigator.plugins[aa]) == "object") {
                var ac = navigator.plugins[aa].description; if (ac && !u(navigator.mimeTypes) && navigator.mimeTypes[ae] && navigator.mimeTypes[ae].enabledPlugin) {
                  j = ac.match(/\d+/g);
                }
              } if (!j) {
                var Z; try {
                  Z = new ActiveXObject("ShockwaveFlash.ShockwaveFlash"); j = Array.prototype.slice.call(Z.GetVariable("$version").match(/(\d+),(\d+),(\d+),(\d+)/), 1); Z = null;
                } catch (ad) { }
              } if (!j) {
                return false;
              } var Y = parseInt(j[0], 10),
                ab = parseInt(j[1], 10); i = Y > 9 && ab > 0; return true;
          } var w, y; if (D(O, "addEventListener")) {
            w = function w(aa, Y, Z) {
              aa.addEventListener(Y, Z, false);
            }; y = function y(aa, Y, Z) {
              aa.removeEventListener(Y, Z, false);
            };
          } else {
            if (D(O, "attachEvent")) {
              w = function w(Y, aa, Z) {
                Y.attachEvent("on" + aa, Z);
              }; y = function y(Y, aa, Z) {
                Y.detachEvent("on" + aa, Z);
              };
            } else {
              throw new Error("Browser not supported");
            }
          } var X = false,
            K = [],
            M; if ("readyState" in d) {
              M = d.readyState; X = M == "complete" || ~navigator.userAgent.indexOf("AppleWebKit/") && (M == "loaded" || M == "interactive");
            } else {
            X = !!d.body;
          } function t() {
            if (X) {
              return;
            } X = true; for (var Y = 0; Y < K.length; Y++) {
              K[Y]();
            } K.length = 0;
          } if (!X) {
            if (D(O, "addEventListener")) {
              w(d, "DOMContentLoaded", t);
            } else {
              w(d, "readystatechange", function () {
                if (d.readyState == "complete") {
                  t();
                }
              }); if (d.documentElement.doScroll && O === top) {
                var h = function h() {
                  if (X) {
                    return;
                  } try {
                    d.documentElement.doScroll("left");
                  } catch (Y) {
                    L(h, 1); return;
                  } t();
                }; h();
              }
            } w(O, "load", t);
          } function H(Z, Y) {
            if (X) {
              Z.call(Y); return;
            } K.push(function () {
              Z.call(Y);
            });
          } function n() {
            var aa = parent; if (J !== "") {
              for (var Y = 0, Z = J.split("."); Y < Z.length; Y++) {
                aa = aa[Z[Y]];
              }
            } return aa.easyXDM;
          } function f(Y) {
            O.easyXDM = N; J = Y; if (J) {
              V = "easyXDM_" + J.replace(".", "_") + "_";
            } return p;
          } function A(Y) {
            return Y.match(R)[3];
          } function g(Y) {
            return Y.match(R)[4] || "";
          } function k(aa) {
            if (aa.indexOf("file://") >= 0) {
              return "file://";
            } var Y = aa.toLowerCase().match(R); if (!Y) {
              return "";
            } var ab = Y[2],
              ac = Y[3],
              Z = Y[4] || ""; if (ab == "http:" && Z == ":80" || ab == "https:" && Z == ":443") {
                Z = "";
              } return ab + "//" + ac + Z;
          } function C(Y) {
            Y = Y.replace(G, "$1/"); if (!Y.match(/^(http||https):\/\//)) {
              var Z = Y.substring(0, 1) === "/" ? "" : q.pathname; if (Z.substring(Z.length - 1) !== "/") {
                Z = Z.substring(0, Z.lastIndexOf("/") + 1);
              } Y = q.protocol + "//" + q.host + Z + Y;
            } while (S.test(Y)) {
              Y = Y.replace(S, "");
            } return Y;
          } function Q(Y, ab) {
            var ad = "",
              aa = Y.indexOf("#"); if (aa !== -1) {
                ad = Y.substring(aa); Y = Y.substring(0, aa);
              } var ac = []; for (var Z in ab) {
                if (ab.hasOwnProperty(Z)) {
                  ac.push(Z + "=" + I(ab[Z]));
                }
              } return Y + (z ? "#" : Y.indexOf("?") == -1 ? "?" : "&") + ac.join("&") + ad;
          } var T = function (Y) {
            Y = Y.substring(1).split("&"); var aa = {},
              ab,
              Z = Y.length; while (Z--) {
                ab = Y[Z].split("="); aa[ab[0]] = l(ab[1]);
              } return aa;
          }(/xdm_e=/.test(q.search) ? q.search : q.hash); function u(Y) {
            return typeof Y === "undefined";
          } var _P = function P() {
            var Z = {}; var aa = { a: [1, 2, 3] },
              Y = '{"a":[1,2,3]}'; if (typeof JSON != "undefined" && typeof JSON.stringify === "function" && JSON.stringify(aa).replace(/\s/g, "") === Y) {
                return JSON;
              } if (Object.toJSON) {
                if (Object.toJSON(aa).replace(/\s/g, "") === Y) {
                  Z.stringify = Object.toJSON;
                }
              } if (typeof String.prototype.evalJSON === "function") {
                aa = Y.evalJSON(); if (aa.a && aa.a.length === 3 && aa.a[2] === 3) {
                  Z.parse = function (ab) {
                    return ab.evalJSON();
                  };
                }
              } if (Z.stringify && Z.parse) {
                _P = function P() {
                  return Z;
                }; return Z;
              } return null;
          }; function U(Y, Z, aa) {
            var ac; for (var ab in Z) {
              if (Z.hasOwnProperty(ab)) {
                if (ab in Y) {
                  ac = Z[ab]; if ((typeof ac === "undefined" ? "undefined" : _typeof(ac)) === "object") {
                    U(Y[ab], ac, aa);
                  } else {
                    if (!aa) {
                      Y[ab] = Z[ab];
                    }
                  }
                } else {
                  Y[ab] = Z[ab];
                }
              }
            } return Y;
          } function a() {
            var Z = d.body.appendChild(d.createElement("form")),
              Y = Z.appendChild(d.createElement("input")); Y.name = V + "TEST" + o; F = Y !== Z.elements[Y.name]; d.body.removeChild(Z);
          } function B(Z) {
            if (u(F)) {
              a();
            } var ad; if (F) {
              ad = d.createElement('<iframe name="' + Z.props.name + '"/>');
            } else {
              ad = d.createElement("IFRAME"); ad.name = Z.props.name;
            } ad.id = ad.name = Z.props.name; delete Z.props.name; if (typeof Z.container == "string") {
              Z.container = d.getElementById(Z.container);
            } if (!Z.container) {
              U(ad.style, { position: "absolute", top: "-2000px", left: "0px" }); Z.container = d.body;
            } var ac = Z.props.src; Z.props.src = "javascript:false"; U(ad, Z.props); ad.border = ad.frameBorder = 0; ad.allowTransparency = true; Z.container.appendChild(ad); if (Z.onLoad) {
              w(ad, "load", Z.onLoad);
            } if (Z.usePost) {
              var ab = Z.container.appendChild(d.createElement("form")),
                Y; ab.target = ad.name; ab.action = ac; ab.method = "POST"; if (_typeof(Z.usePost) === "object") {
                  for (var aa in Z.usePost) {
                    if (Z.usePost.hasOwnProperty(aa)) {
                      if (F) {
                        Y = d.createElement('<input name="' + aa + '"/>');
                      } else {
                        Y = d.createElement("INPUT"); Y.name = aa;
                      } Y.value = Z.usePost[aa]; ab.appendChild(Y);
                    }
                  }
                } ab.submit(); ab.parentNode.removeChild(ab);
            } else {
              ad.src = ac;
            } Z.props.src = ac; return ad;
          } function e(Y) {
            return Y.replace(/[-[\]/{}()+.\^$|]/g, "\\$&").replace(/(\*)/g, ".$1").replace(/\?/g, ".");
          } function W(ac, aa) {
            if (typeof ac == "string") {
              ac = [ac];
            } var Z,
              Y = ac.length; while (Y--) {
                var ab = ac[Y].substr(0, 1) === "^" && ac[Y].substr(ac[Y].length - 1, 1) === "$"; Z = ab ? ac[Y] : "^" + e(ac[Y]) + "$"; Z = new RegExp(Z); if (Z.test(aa)) {
                  return true;
                }
              } return false;
          } function m(aa) {
            var af = aa.protocol,
              Z; aa.isHost = aa.isHost || u(T.xdm_p); z = aa.hash || false; if (!aa.props) {
                aa.props = {};
              } if (!aa.isHost) {
                aa.channel = T.xdm_c.replace(/["'<>\\]/g, ""); aa.secret = T.xdm_s; aa.remote = T.xdm_e.replace(/["'<>\\]/g, ""); af = T.xdm_p; if (aa.acl && !W(aa.acl, aa.remote)) {
                  throw new Error("Access denied for " + aa.remote);
                }
              } else {
              aa.remote = C(aa.remote); aa.channel = aa.channel || "default" + o++; aa.secret = Math.random().toString(16).substring(2); if (u(af)) {
                if (k(q.href) == k(aa.remote)) {
                  af = "4";
                } else {
                  if (D(O, "postMessage") || D(d, "postMessage")) {
                    af = "1";
                  } else {
                    if (aa.swf && D(O, "ActiveXObject") && c()) {
                      af = "6";
                    } else {
                      if (navigator.product === "Gecko" && "frameElement" in O && navigator.userAgent.indexOf("WebKit") == -1) {
                        af = "5";
                      } else {
                        if (aa.remoteHelper) {
                          af = "2";
                        } else {
                          af = "0";
                        }
                      }
                    }
                  }
                }
              }
            } aa.protocol = af; switch (af) {
              case "0":
                U(aa, { interval: 100, delay: 2000, useResize: true, useParent: false, usePolling: false }, true); if (aa.isHost) {
                  if (!aa.local) {
                    var ad = q.protocol + "//" + q.host,
                      Y = d.body.getElementsByTagName("img"),
                      ae; var ab = Y.length; while (ab--) {
                        ae = Y[ab]; if (ae.src.substring(0, ad.length) === ad) {
                          aa.local = ae.src; break;
                        }
                      } if (!aa.local) {
                        aa.local = O;
                      }
                  } var ac = { xdm_c: aa.channel, xdm_p: 0 }; if (aa.local === O) {
                    aa.usePolling = true; aa.useParent = true; aa.local = q.protocol + "//" + q.host + q.pathname + q.search; ac.xdm_e = aa.local; ac.xdm_pa = 1;
                  } else {
                    ac.xdm_e = C(aa.local);
                  } if (aa.container) {
                    aa.useResize = false; ac.xdm_po = 1;
                  } aa.remote = Q(aa.remote, ac);
                } else {
                  U(aa, { useParent: !u(T.xdm_pa), usePolling: !u(T.xdm_po), useResize: aa.useParent ? false : aa.useResize });
                } Z = [new p.stack.HashTransport(aa), new p.stack.ReliableBehavior({}), new p.stack.QueueBehavior({ encode: true, maxLength: 4000 - aa.remote.length }), new p.stack.VerifyBehavior({ initiate: aa.isHost })]; break; case "1":
                Z = [new p.stack.PostMessageTransport(aa)]; break; case "2":
                if (aa.isHost) {
                  aa.remoteHelper = C(aa.remoteHelper);
                } Z = [new p.stack.NameTransport(aa), new p.stack.QueueBehavior(), new p.stack.VerifyBehavior({ initiate: aa.isHost })]; break; case "3":
                Z = [new p.stack.NixTransport(aa)]; break; case "4":
                Z = [new p.stack.SameOriginTransport(aa)]; break; case "5":
                Z = [new p.stack.FrameElementTransport(aa)]; break; case "6":
                if (!j) {
                  c();
                } Z = [new p.stack.FlashTransport(aa)]; break;
            }Z.push(new p.stack.QueueBehavior({ lazy: aa.lazy, remove: true })); return Z;
          } function E(ab) {
            var ac,
              aa = {
                incoming: function incoming(ae, ad) {
                  this.up.incoming(ae, ad);
                }, outgoing: function outgoing(ad, ae) {
                  this.down.outgoing(ad, ae);
                }, callback: function callback(ad) {
                  this.up.callback(ad);
                }, init: function init() {
                  this.down.init();
                }, destroy: function destroy() {
                  this.down.destroy();
                }
              }; for (var Z = 0, Y = ab.length; Z < Y; Z++) {
                ac = ab[Z]; U(ac, aa, true); if (Z !== 0) {
                  ac.down = ab[Z - 1];
                } if (Z !== Y - 1) {
                  ac.up = ab[Z + 1];
                }
              } return ac;
          } function x(Y) {
            Y.up.down = Y.down; Y.down.up = Y.up; Y.up = Y.down = null;
          } U(p, { version: "2.5.00.1", query: T, stack: {}, apply: U, getJSONObject: _P, whenReady: H, noConflict: f }); p.DomHelper = {
            on: w, un: y, requiresJSON: function requiresJSON(Y) {
              if (!v(O, "JSON")) {
                d.write('<script type="text/javascript" src="' + Y + '"><\/script>');
              }
            }
          }; (function () {
            var Y = {}; p.Fn = {
              set: function set(Z, aa) {
                Y[Z] = aa;
              }, get: function get(aa, Z) {
                if (!Y.hasOwnProperty(aa)) {
                  return;
                } var ab = Y[aa]; if (Z) {
                  delete Y[aa];
                } return ab;
              }
            };
          })(); p.Socket = function (Z) {
            var Y = E(m(Z).concat([{
              incoming: function incoming(ac, ab) {
                Z.onMessage(ac, ab);
              }, callback: function callback(ab) {
                if (Z.onReady) {
                  Z.onReady(ab);
                }
              }
            }])),
              aa = k(Z.remote); this.origin = k(Z.remote); this.destroy = function () {
                Y.destroy();
              }; this.postMessage = function (ab) {
                Y.outgoing(ab, aa);
              }; Y.init();
          }; p.Rpc = function (aa, Z) {
            if (Z.local) {
              for (var ac in Z.local) {
                if (Z.local.hasOwnProperty(ac)) {
                  var ab = Z.local[ac]; if (typeof ab === "function") {
                    Z.local[ac] = { method: ab };
                  }
                }
              }
            } var Y = E(m(aa).concat([new p.stack.RpcBehavior(this, Z), {
              callback: function callback(ad) {
                if (aa.onReady) {
                  aa.onReady(ad);
                }
              }
            }])); this.origin = k(aa.remote); this.context = aa.context || null; this.destroy = function () {
              Y.destroy();
            }; Y.init();
          }; p.stack.SameOriginTransport = function (Z) {
            var aa, ac, ab, Y; return aa = {
              outgoing: function outgoing(ae, af, ad) {
                ab(ae); if (ad) {
                  ad();
                }
              }, destroy: function destroy() {
                if (ac) {
                  ac.parentNode.removeChild(ac); ac = null;
                }
              }, onDOMReady: function onDOMReady() {
                Y = k(Z.remote); if (Z.isHost) {
                  U(Z.props, { src: Q(Z.remote, { xdm_e: q.protocol + "//" + q.host + q.pathname, xdm_c: Z.channel, xdm_p: 4 }), name: V + Z.channel + "_provider" }); ac = B(Z); p.Fn.set(Z.channel, function (ad) {
                    ab = ad; L(function () {
                      aa.up.callback(true);
                    }, 0); return function (ae) {
                      aa.up.incoming(ae, Y);
                    };
                  });
                } else {
                  ab = n().Fn.get(Z.channel, true)(function (ad) {
                    aa.up.incoming(ad, Y);
                  }); L(function () {
                    aa.up.callback(true);
                  }, 0);
                }
              }, init: function init() {
                H(aa.onDOMReady, aa);
              }
            };
          }; p.stack.FlashTransport = function (ab) {
            var ad, Y, ac, ae, Z, af; function ag(ai, ah) {
              L(function () {
                ad.up.incoming(ai, ae);
              }, 0);
            } function aa(ai) {
              var ah = ab.swf + "?host=" + ab.isHost; var ak = "easyXDM_swf_" + Math.floor(Math.random() * 10000); p.Fn.set("flash_loaded" + ai.replace(/[\-.]/g, "_"), function () {
                p.stack.FlashTransport[ai].swf = Z = af.firstChild; var al = p.stack.FlashTransport[ai].queue; for (var am = 0; am < al.length; am++) {
                  al[am]();
                } al.length = 0;
              }); if (ab.swfContainer) {
                af = typeof ab.swfContainer == "string" ? d.getElementById(ab.swfContainer) : ab.swfContainer;
              } else {
                af = d.createElement("div"); U(af.style, i && ab.swfNoThrottle ? { height: "20px", width: "20px", position: "fixed", right: 0, top: 0 } : { height: "1px", width: "1px", position: "absolute", overflow: "hidden", right: 0, top: 0 }); d.body.appendChild(af);
              } var aj = "callback=flash_loaded" + I(ai.replace(/[\-.]/g, "_")) + "&proto=" + b.location.protocol + "&domain=" + I(A(b.location.href)) + "&port=" + I(g(b.location.href)) + "&ns=" + I(J); af.innerHTML = "<object height='20' width='20' type='application/x-shockwave-flash' id='" + ak + "' data='" + ah + "'><param name='allowScriptAccess' value='always'></param><param name='wmode' value='transparent'><param name='movie' value='" + ah + "'></param><param name='flashvars' value='" + aj + "'></param><embed type='application/x-shockwave-flash' FlashVars='" + aj + "' allowScriptAccess='always' wmode='transparent' src='" + ah + "' height='1' width='1'></embed></object>";
            } return ad = {
              outgoing: function outgoing(ai, aj, ah) {
                Z.postMessage(ab.channel, ai.toString()); if (ah) {
                  ah();
                }
              }, destroy: function destroy() {
                try {
                  Z.destroyChannel(ab.channel);
                } catch (ah) { } Z = null; if (Y) {
                  Y.parentNode.removeChild(Y); Y = null;
                }
              }, onDOMReady: function onDOMReady() {
                ae = ab.remote; p.Fn.set("flash_" + ab.channel + "_init", function () {
                  L(function () {
                    ad.up.callback(true);
                  });
                }); p.Fn.set("flash_" + ab.channel + "_onMessage", ag); ab.swf = C(ab.swf); var ai = A(ab.swf); var ah = function ah() {
                  p.stack.FlashTransport[ai].init = true; Z = p.stack.FlashTransport[ai].swf; Z.createChannel(ab.channel, ab.secret, k(ab.remote), ab.isHost); if (ab.isHost) {
                    if (i && ab.swfNoThrottle) {
                      U(ab.props, { position: "fixed", right: 0, top: 0, height: "20px", width: "20px" });
                    } U(ab.props, { src: Q(ab.remote, { xdm_e: k(q.href), xdm_c: ab.channel, xdm_p: 6, xdm_s: ab.secret }), name: V + ab.channel + "_provider" }); Y = B(ab);
                  }
                }; if (p.stack.FlashTransport[ai] && p.stack.FlashTransport[ai].init) {
                  ah();
                } else {
                  if (!p.stack.FlashTransport[ai]) {
                    p.stack.FlashTransport[ai] = { queue: [ah] }; aa(ai);
                  } else {
                    p.stack.FlashTransport[ai].queue.push(ah);
                  }
                }
              }, init: function init() {
                H(ad.onDOMReady, ad);
              }
            };
          }; p.stack.PostMessageTransport = function (ac) {
            var ae, af, aa, ab; function Z(ag) {
              if (ag.origin) {
                return k(ag.origin);
              } if (ag.uri) {
                return k(ag.uri);
              } if (ag.domain) {
                return q.protocol + "//" + ag.domain;
              } throw "Unable to retrieve the origin of the event";
            } function ad(ah) {
              if (typeof ah.data !== "string") {
                return;
              } var ag = Z(ah); if (ag == ab && typeof ah.data === "string" && ah.data.substring(0, ac.channel.length + 1) == ac.channel + " ") {
                ae.up.incoming(ah.data.substring(ac.channel.length + 1), ag);
              }
            } function Y(ag) {
              if (ag.data == ac.channel + "-ready") {
                aa = "postMessage" in af.contentWindow ? af.contentWindow : af.contentWindow.document; y(O, "message", Y); w(O, "message", ad); L(function () {
                  ae.up.callback(true);
                }, 0);
              }
            } return ae = {
              outgoing: function outgoing(ah, ai, ag) {
                aa.postMessage(ac.channel + " " + ah, ai || ab); if (ag) {
                  ag();
                }
              }, destroy: function destroy() {
                y(O, "message", Y); y(O, "message", ad); if (af) {
                  aa = null; af.parentNode.removeChild(af); af = null;
                }
              }, onDOMReady: function onDOMReady() {
                ab = k(ac.remote); if (ab === "file://") {
                  ab = "*";
                } if (ac.isHost) {
                  w(O, "message", Y); U(ac.props, { src: Q(ac.remote, { xdm_e: k(q.href), xdm_c: ac.channel, xdm_p: 1 }), name: V + ac.channel + "_provider" }); af = B(ac);
                } else {
                  w(O, "message", ad); aa = "postMessage" in O.parent ? O.parent : O.parent.document; aa.postMessage(ac.channel + "-ready", ab); L(function () {
                    ae.up.callback(true);
                  }, 0);
                }
              }, init: function init() {
                H(ae.onDOMReady, ae);
              }
            };
          }; p.stack.FrameElementTransport = function (Z) {
            var aa, ac, ab, Y; return aa = {
              outgoing: function outgoing(ae, af, ad) {
                ab.call(this, ae); if (ad) {
                  ad();
                }
              }, destroy: function destroy() {
                if (ac) {
                  ac.parentNode.removeChild(ac); ac = null;
                }
              }, onDOMReady: function onDOMReady() {
                Y = k(Z.remote); if (Z.isHost) {
                  U(Z.props, { src: Q(Z.remote, { xdm_e: k(q.href), xdm_c: Z.channel, xdm_p: 5 }), name: V + Z.channel + "_provider" }); ac = B(Z); ac.fn = function (ad) {
                    delete ac.fn; ab = ad; L(function () {
                      aa.up.callback(true);
                    }, 0); return function (ae) {
                      aa.up.incoming(ae, Y);
                    };
                  };
                } else {
                  if (d.referrer && k(d.referrer) != T.xdm_e) {
                    O.top.location = T.xdm_e;
                  } ab = O.frameElement.fn(function (ad) {
                    aa.up.incoming(ad, Y);
                  }); aa.up.callback(true);
                }
              }, init: function init() {
                H(aa.onDOMReady, aa);
              }
            };
          }; p.stack.NameTransport = function (ac) {
            var ad; var af, aj, ab, ah, ai, Z, Y; function ag(am) {
              var al = ac.remoteHelper + (af ? "#_3" : "#_2") + ac.channel; aj.contentWindow.sendMessage(am, al);
            } function ae() {
              if (af) {
                if (++ah === 2 || !af) {
                  ad.up.callback(true);
                }
              } else {
                ag("ready"); ad.up.callback(true);
              }
            } function ak(al) {
              ad.up.incoming(al, Z);
            } function aa() {
              if (ai) {
                L(function () {
                  ai(true);
                }, 0);
              }
            } return ad = {
              outgoing: function outgoing(am, an, al) {
                ai = al; ag(am);
              }, destroy: function destroy() {
                aj.parentNode.removeChild(aj); aj = null; if (af) {
                  ab.parentNode.removeChild(ab); ab = null;
                }
              }, onDOMReady: function onDOMReady() {
                af = ac.isHost; ah = 0; Z = k(ac.remote); ac.local = C(ac.local); if (af) {
                  p.Fn.set(ac.channel, function (am) {
                    if (af && am === "ready") {
                      p.Fn.set(ac.channel, ak); ae();
                    }
                  }); Y = Q(ac.remote, { xdm_e: ac.local, xdm_c: ac.channel, xdm_p: 2 }); U(ac.props, { src: Y + "#" + ac.channel, name: V + ac.channel + "_provider" }); ab = B(ac);
                } else {
                  ac.remoteHelper = ac.remote; p.Fn.set(ac.channel, ak);
                } var al = function al() {
                  var am = aj || this; y(am, "load", al); p.Fn.set(ac.channel + "_load", aa); (function an() {
                    if (typeof am.contentWindow.sendMessage == "function") {
                      ae();
                    } else {
                      L(an, 50);
                    }
                  })();
                }; aj = B({ props: { src: ac.local + "#_4" + ac.channel }, onLoad: al });
              }, init: function init() {
                H(ad.onDOMReady, ad);
              }
            };
          }; p.stack.HashTransport = function (aa) {
            var ad; var ai = this,
              ag,
              ab,
              Y,
              ae,
              an,
              ac,
              am; var ah, Z; function al(ap) {
                if (!am) {
                  return;
                } var ao = aa.remote + "#" + an++ + "_" + ap; (ag || !ah ? am.contentWindow : am).location = ao;
              } function af(ao) {
                ae = ao; ad.up.incoming(ae.substring(ae.indexOf("_") + 1), Z);
              } function ak() {
                if (!ac) {
                  return;
                } var ao = ac.location.href,
                  aq = "",
                  ap = ao.indexOf("#"); if (ap != -1) {
                    aq = ao.substring(ap);
                  } if (aq && aq != ae) {
                    af(aq);
                  }
              } function aj() {
                ab = setInterval(ak, Y);
              } return ad = {
                outgoing: function outgoing(ao, ap) {
                  al(ao);
                }, destroy: function destroy() {
                  O.clearInterval(ab); if (ag || !ah) {
                    am.parentNode.removeChild(am);
                  } am = null;
                }, onDOMReady: function onDOMReady() {
                  ag = aa.isHost; Y = aa.interval; ae = "#" + aa.channel; an = 0; ah = aa.useParent; Z = k(aa.remote); if (ag) {
                    U(aa.props, { src: aa.remote, name: V + aa.channel + "_provider" }); if (ah) {
                      aa.onLoad = function () {
                        ac = O; aj(); ad.up.callback(true);
                      };
                    } else {
                      var aq = 0,
                        ao = aa.delay / 50; (function ap() {
                          if (++aq > ao) {
                            throw new Error("Unable to reference listenerwindow");
                          } try {
                            ac = am.contentWindow.frames[V + aa.channel + "_consumer"];
                          } catch (ar) { } if (ac) {
                            aj(); ad.up.callback(true);
                          } else {
                            L(ap, 50);
                          }
                        })();
                    } am = B(aa);
                  } else {
                    ac = O; aj(); if (ah) {
                      am = parent; ad.up.callback(true);
                    } else {
                      U(aa, {
                        props: { src: aa.remote + "#" + aa.channel + new Date(), name: V + aa.channel + "_consumer" }, onLoad: function onLoad() {
                          ad.up.callback(true);
                        }
                      }); am = B(aa);
                    }
                  }
                }, init: function init() {
                  H(ad.onDOMReady, ad);
                }
              };
          }; p.stack.ReliableBehavior = function (Z) {
            var ab, ad; var ac = 0,
              Y = 0,
              aa = ""; return ab = {
                incoming: function incoming(ag, ae) {
                  var af = ag.indexOf("_"),
                    ah = ag.substring(0, af).split(","); ag = ag.substring(af + 1); if (ah[0] == ac) {
                      aa = ""; if (ad) {
                        ad(true);
                      }
                    } if (ag.length > 0) {
                      ab.down.outgoing(ah[1] + "," + ac + "_" + aa, ae); if (Y != ah[1]) {
                        Y = ah[1]; ab.up.incoming(ag, ae);
                      }
                    }
                }, outgoing: function outgoing(ag, ae, af) {
                  aa = ag; ad = af; ab.down.outgoing(Y + "," + ++ac + "_" + ag, ae);
                }
              };
          }; p.stack.QueueBehavior = function (aa) {
            var ad,
              ae = [],
              ah = true,
              ab = "",
              ag,
              Y = 0,
              Z = false,
              ac = false; function af() {
                if (aa.remove && ae.length === 0) {
                  x(ad); return;
                } if (ah || ae.length === 0 || ag) {
                  return;
                } ah = true; var ai = ae.shift(); ad.down.outgoing(ai.data, ai.origin, function (aj) {
                  ah = false; if (ai.callback) {
                    L(function () {
                      ai.callback(aj);
                    }, 0);
                  } af();
                });
              } return ad = {
                init: function init() {
                  if (u(aa)) {
                    aa = {};
                  } if (aa.maxLength) {
                    Y = aa.maxLength; ac = true;
                  } if (aa.lazy) {
                    Z = true;
                  } else {
                    ad.down.init();
                  }
                }, callback: function callback(aj) {
                  ah = false; var ai = ad.up; af(); ai.callback(aj);
                }, incoming: function incoming(al, aj) {
                  if (ac) {
                    var ak = al.indexOf("_"),
                      ai = parseInt(al.substring(0, ak), 10); ab += al.substring(ak + 1); if (ai === 0) {
                        if (aa.encode) {
                          ab = l(ab);
                        } ad.up.incoming(ab, aj); ab = "";
                      }
                  } else {
                    ad.up.incoming(al, aj);
                  }
                }, outgoing: function outgoing(am, aj, al) {
                  if (aa.encode) {
                    am = I(am);
                  } var ai = [],
                    ak; if (ac) {
                      while (am.length !== 0) {
                        ak = am.substring(0, Y); am = am.substring(ak.length); ai.push(ak);
                      } while (ak = ai.shift()) {
                        ae.push({ data: ai.length + "_" + ak, origin: aj, callback: ai.length === 0 ? al : null });
                      }
                    } else {
                    ae.push({ data: am, origin: aj, callback: al });
                  } if (Z) {
                    ad.down.init();
                  } else {
                    af();
                  }
                }, destroy: function destroy() {
                  ag = true; ad.down.destroy();
                }
              };
          }; p.stack.VerifyBehavior = function (ac) {
            var ad,
              ab,
              Z,
              aa = false; function Y() {
                ab = Math.random().toString(16).substring(2); ad.down.outgoing(ab);
              } return ad = {
                incoming: function incoming(ag, ae) {
                  var af = ag.indexOf("_"); if (af === -1) {
                    if (ag === ab) {
                      ad.up.callback(true);
                    } else {
                      if (!Z) {
                        Z = ag; if (!ac.initiate) {
                          Y();
                        } ad.down.outgoing(ag);
                      }
                    }
                  } else {
                    if (ag.substring(0, af) === Z) {
                      ad.up.incoming(ag.substring(af + 1), ae);
                    }
                  }
                }, outgoing: function outgoing(ag, ae, af) {
                  ad.down.outgoing(ab + "_" + ag, ae, af);
                }, callback: function callback(ae) {
                  if (ac.initiate) {
                    Y();
                  }
                }
              };
          }; p.stack.RpcBehavior = function (ae, Z) {
            var ab,
              ag = Z.serializer || _P(); var af = 0,
                ad = {}; function Y(ah) {
                  ah.jsonrpc = "2.0"; ab.down.outgoing(ag.stringify(ah));
                } function ac(ah, aj) {
                  var ai = Array.prototype.slice; return function () {
                    var ak = arguments.length,
                      am,
                      al = { method: aj }; if (ak > 0 && typeof arguments[ak - 1] === "function") {
                        if (ak > 1 && typeof arguments[ak - 2] === "function") {
                          am = { success: arguments[ak - 2], error: arguments[ak - 1] }; al.params = ai.call(arguments, 0, ak - 2);
                        } else {
                          am = { success: arguments[ak - 1] }; al.params = ai.call(arguments, 0, ak - 1);
                        } ad["" + ++af] = am; al.id = af;
                      } else {
                      al.params = ai.call(arguments, 0);
                    } if (ah.namedParams && al.params.length === 1) {
                      al.params = al.params[0];
                    } Y(al);
                  };
                } function aa(ah, aj, an, al) {
                  if (!an) {
                    if (aj) {
                      Y({ id: aj, error: { code: -32601, message: "Procedure not found." } });
                    } return;
                  } var _ao, _am; if (aj) {
                    _ao = function ao(aq) {
                      _ao = r; Y({ id: aj, result: aq });
                    }; _am = function am(aq, ar) {
                      _am = r; var at = { id: aj, error: { code: -32099, message: aq } }; if (ar) {
                        at.error.data = ar;
                      } Y(at);
                    };
                  } else {
                    _ao = _am = r;
                  } if (!s(al)) {
                    al = [al];
                  } try {
                    var ak = ae.context || an.scope; var ap = an.method.apply(ak, al.concat([_ao, _am])); if (!u(ap)) {
                      _ao(ap);
                    }
                  } catch (ai) {
                    _am(ai.message);
                  }
                } return ab = {
                  incoming: function incoming(ai, ah) {
                    var aj = ag.parse(ai); if (aj.method) {
                      if (Z.handle) {
                        Z.handle(aj, Y);
                      } else {
                        aa(aj.method, aj.id, Z.local[aj.method], aj.params);
                      }
                    } else {
                      var ak = ad[aj.id]; if (aj.error) {
                        if (ak.error) {
                          ak.error(aj.error);
                        }
                      } else {
                        if (ak.success) {
                          ak.success(aj.result);
                        }
                      } delete ad[aj.id];
                    }
                  }, init: function init() {
                    if (Z.remote) {
                      for (var ah in Z.remote) {
                        if (Z.remote.hasOwnProperty(ah)) {
                          ae[ah] = ac(Z.remote[ah], ah);
                        }
                      }
                    } ab.down.init();
                  }, destroy: function destroy() {
                    for (var ah in Z.remote) {
                      if (Z.remote.hasOwnProperty(ah) && ae.hasOwnProperty(ah)) {
                        delete ae[ah];
                      }
                    } ab.down.destroy();
                  }
                };
          }; b.easyXDM = p;
        })(window, document, location, window.setTimeout, decodeURIComponent, encodeURIComponent);

        return easyXDM.noConflict('Kakao');
      }();
    }, {}], 32: [function (require, module, exports) {
      (function (process, global, setImmediate) {
        (function () {
          "use strict";
          function lib$es6$promise$utils$$objectOrFunction(x) {
            return typeof x === "function" || (typeof x === "undefined" ? "undefined" : _typeof(x)) === "object" && x !== null;
          } function lib$es6$promise$utils$$isFunction(x) {
            return typeof x === "function";
          } function lib$es6$promise$utils$$isMaybeThenable(x) {
            return (typeof x === "undefined" ? "undefined" : _typeof(x)) === "object" && x !== null;
          } var lib$es6$promise$utils$$_isArray; if (!Array.isArray) {
            lib$es6$promise$utils$$_isArray = function lib$es6$promise$utils$$_isArray(x) {
              return Object.prototype.toString.call(x) === "[object Array]";
            };
          } else {
            lib$es6$promise$utils$$_isArray = Array.isArray;
          } var lib$es6$promise$utils$$isArray = lib$es6$promise$utils$$_isArray; var lib$es6$promise$asap$$len = 0; var lib$es6$promise$asap$$toString = {}.toString; var lib$es6$promise$asap$$vertxNext; function lib$es6$promise$asap$$asap(callback, arg) {
            lib$es6$promise$asap$$queue[lib$es6$promise$asap$$len] = callback; lib$es6$promise$asap$$queue[lib$es6$promise$asap$$len + 1] = arg; lib$es6$promise$asap$$len += 2; if (lib$es6$promise$asap$$len === 2) {
              lib$es6$promise$asap$$scheduleFlush();
            }
          } var lib$es6$promise$asap$$default = lib$es6$promise$asap$$asap; var lib$es6$promise$asap$$browserWindow = typeof window !== "undefined" ? window : undefined; var lib$es6$promise$asap$$browserGlobal = lib$es6$promise$asap$$browserWindow || {}; var lib$es6$promise$asap$$BrowserMutationObserver = lib$es6$promise$asap$$browserGlobal.MutationObserver || lib$es6$promise$asap$$browserGlobal.WebKitMutationObserver; var lib$es6$promise$asap$$isNode = typeof process !== "undefined" && {}.toString.call(process) === "[object process]"; var lib$es6$promise$asap$$isWorker = typeof Uint8ClampedArray !== "undefined" && typeof importScripts !== "undefined" && typeof MessageChannel !== "undefined"; function lib$es6$promise$asap$$useNextTick() {
            var nextTick = process.nextTick; var version = process.versions.node.match(/^(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+)$/); if (Array.isArray(version) && version[1] === "0" && version[2] === "10") {
              nextTick = setImmediate;
            } return function () {
              nextTick(lib$es6$promise$asap$$flush);
            };
          } function lib$es6$promise$asap$$useVertxTimer() {
            return function () {
              lib$es6$promise$asap$$vertxNext(lib$es6$promise$asap$$flush);
            };
          } function lib$es6$promise$asap$$useMutationObserver() {
            var iterations = 0; var observer = new lib$es6$promise$asap$$BrowserMutationObserver(lib$es6$promise$asap$$flush); var node = document.createTextNode(""); observer.observe(node, { characterData: true }); return function () {
              node.data = iterations = ++iterations % 2;
            };
          } function lib$es6$promise$asap$$useMessageChannel() {
            var channel = new MessageChannel(); channel.port1.onmessage = lib$es6$promise$asap$$flush; return function () {
              channel.port2.postMessage(0);
            };
          } function lib$es6$promise$asap$$useSetTimeout() {
            return function () {
              setTimeout(lib$es6$promise$asap$$flush, 1);
            };
          } var lib$es6$promise$asap$$queue = new Array(1e3); function lib$es6$promise$asap$$flush() {
            for (var i = 0; i < lib$es6$promise$asap$$len; i += 2) {
              var callback = lib$es6$promise$asap$$queue[i]; var arg = lib$es6$promise$asap$$queue[i + 1]; callback(arg); lib$es6$promise$asap$$queue[i] = undefined; lib$es6$promise$asap$$queue[i + 1] = undefined;
            } lib$es6$promise$asap$$len = 0;
          } function lib$es6$promise$asap$$attemptVertex() {
            try {
              var r = require; var vertx = r("vertx"); lib$es6$promise$asap$$vertxNext = vertx.runOnLoop || vertx.runOnContext; return lib$es6$promise$asap$$useVertxTimer();
            } catch (e) {
              return lib$es6$promise$asap$$useSetTimeout();
            }
          } var lib$es6$promise$asap$$scheduleFlush; if (lib$es6$promise$asap$$isNode) {
            lib$es6$promise$asap$$scheduleFlush = lib$es6$promise$asap$$useNextTick();
          } else if (lib$es6$promise$asap$$BrowserMutationObserver) {
            lib$es6$promise$asap$$scheduleFlush = lib$es6$promise$asap$$useMutationObserver();
          } else if (lib$es6$promise$asap$$isWorker) {
            lib$es6$promise$asap$$scheduleFlush = lib$es6$promise$asap$$useMessageChannel();
          } else if (lib$es6$promise$asap$$browserWindow === undefined && typeof require === "function") {
            lib$es6$promise$asap$$scheduleFlush = lib$es6$promise$asap$$attemptVertex();
          } else {
            lib$es6$promise$asap$$scheduleFlush = lib$es6$promise$asap$$useSetTimeout();
          } function lib$es6$promise$$internal$$noop() { } var lib$es6$promise$$internal$$PENDING = void 0; var lib$es6$promise$$internal$$FULFILLED = 1; var lib$es6$promise$$internal$$REJECTED = 2; var lib$es6$promise$$internal$$GET_THEN_ERROR = new lib$es6$promise$$internal$$ErrorObject(); function lib$es6$promise$$internal$$selfFullfillment() {
            return new TypeError("You cannot resolve a promise with itself");
          } function lib$es6$promise$$internal$$cannotReturnOwn() {
            return new TypeError("A promises callback cannot return that same promise.");
          } function lib$es6$promise$$internal$$getThen(promise) {
            try {
              return promise.then;
            } catch (error) {
              lib$es6$promise$$internal$$GET_THEN_ERROR.error = error; return lib$es6$promise$$internal$$GET_THEN_ERROR;
            }
          } function lib$es6$promise$$internal$$tryThen(then, value, fulfillmentHandler, rejectionHandler) {
            try {
              then.call(value, fulfillmentHandler, rejectionHandler);
            } catch (e) {
              return e;
            }
          } function lib$es6$promise$$internal$$handleForeignThenable(promise, thenable, then) {
            lib$es6$promise$asap$$default(function (promise) {
              var sealed = false; var error = lib$es6$promise$$internal$$tryThen(then, thenable, function (value) {
                if (sealed) {
                  return;
                } sealed = true; if (thenable !== value) {
                  lib$es6$promise$$internal$$resolve(promise, value);
                } else {
                  lib$es6$promise$$internal$$fulfill(promise, value);
                }
              }, function (reason) {
                if (sealed) {
                  return;
                } sealed = true; lib$es6$promise$$internal$$reject(promise, reason);
              }, "Settle: " + (promise._label || " unknown promise")); if (!sealed && error) {
                sealed = true; lib$es6$promise$$internal$$reject(promise, error);
              }
            }, promise);
          } function lib$es6$promise$$internal$$handleOwnThenable(promise, thenable) {
            if (thenable._state === lib$es6$promise$$internal$$FULFILLED) {
              lib$es6$promise$$internal$$fulfill(promise, thenable._result);
            } else if (thenable._state === lib$es6$promise$$internal$$REJECTED) {
              lib$es6$promise$$internal$$reject(promise, thenable._result);
            } else {
              lib$es6$promise$$internal$$subscribe(thenable, undefined, function (value) {
                lib$es6$promise$$internal$$resolve(promise, value);
              }, function (reason) {
                lib$es6$promise$$internal$$reject(promise, reason);
              });
            }
          } function lib$es6$promise$$internal$$handleMaybeThenable(promise, maybeThenable) {
            if (maybeThenable.constructor === promise.constructor) {
              lib$es6$promise$$internal$$handleOwnThenable(promise, maybeThenable);
            } else {
              var then = lib$es6$promise$$internal$$getThen(maybeThenable); if (then === lib$es6$promise$$internal$$GET_THEN_ERROR) {
                lib$es6$promise$$internal$$reject(promise, lib$es6$promise$$internal$$GET_THEN_ERROR.error);
              } else if (then === undefined) {
                lib$es6$promise$$internal$$fulfill(promise, maybeThenable);
              } else if (lib$es6$promise$utils$$isFunction(then)) {
                lib$es6$promise$$internal$$handleForeignThenable(promise, maybeThenable, then);
              } else {
                lib$es6$promise$$internal$$fulfill(promise, maybeThenable);
              }
            }
          } function lib$es6$promise$$internal$$resolve(promise, value) {
            if (promise === value) {
              lib$es6$promise$$internal$$reject(promise, lib$es6$promise$$internal$$selfFullfillment());
            } else if (lib$es6$promise$utils$$objectOrFunction(value)) {
              lib$es6$promise$$internal$$handleMaybeThenable(promise, value);
            } else {
              lib$es6$promise$$internal$$fulfill(promise, value);
            }
          } function lib$es6$promise$$internal$$publishRejection(promise) {
            if (promise._onerror) {
              promise._onerror(promise._result);
            } lib$es6$promise$$internal$$publish(promise);
          } function lib$es6$promise$$internal$$fulfill(promise, value) {
            if (promise._state !== lib$es6$promise$$internal$$PENDING) {
              return;
            } promise._result = value; promise._state = lib$es6$promise$$internal$$FULFILLED; if (promise._subscribers.length !== 0) {
              lib$es6$promise$asap$$default(lib$es6$promise$$internal$$publish, promise);
            }
          } function lib$es6$promise$$internal$$reject(promise, reason) {
            if (promise._state !== lib$es6$promise$$internal$$PENDING) {
              return;
            } promise._state = lib$es6$promise$$internal$$REJECTED; promise._result = reason; lib$es6$promise$asap$$default(lib$es6$promise$$internal$$publishRejection, promise);
          } function lib$es6$promise$$internal$$subscribe(parent, child, onFulfillment, onRejection) {
            var subscribers = parent._subscribers; var length = subscribers.length; parent._onerror = null; subscribers[length] = child; subscribers[length + lib$es6$promise$$internal$$FULFILLED] = onFulfillment; subscribers[length + lib$es6$promise$$internal$$REJECTED] = onRejection; if (length === 0 && parent._state) {
              lib$es6$promise$asap$$default(lib$es6$promise$$internal$$publish, parent);
            }
          } function lib$es6$promise$$internal$$publish(promise) {
            var subscribers = promise._subscribers; var settled = promise._state; if (subscribers.length === 0) {
              return;
            } var child,
              callback,
              detail = promise._result; for (var i = 0; i < subscribers.length; i += 3) {
                child = subscribers[i]; callback = subscribers[i + settled]; if (child) {
                  lib$es6$promise$$internal$$invokeCallback(settled, child, callback, detail);
                } else {
                  callback(detail);
                }
              } promise._subscribers.length = 0;
          } function lib$es6$promise$$internal$$ErrorObject() {
            this.error = null;
          } var lib$es6$promise$$internal$$TRY_CATCH_ERROR = new lib$es6$promise$$internal$$ErrorObject(); function lib$es6$promise$$internal$$tryCatch(callback, detail) {
            try {
              return callback(detail);
            } catch (e) {
              lib$es6$promise$$internal$$TRY_CATCH_ERROR.error = e; return lib$es6$promise$$internal$$TRY_CATCH_ERROR;
            }
          } function lib$es6$promise$$internal$$invokeCallback(settled, promise, callback, detail) {
            var hasCallback = lib$es6$promise$utils$$isFunction(callback),
              value,
              error,
              succeeded,
              failed; if (hasCallback) {
                value = lib$es6$promise$$internal$$tryCatch(callback, detail); if (value === lib$es6$promise$$internal$$TRY_CATCH_ERROR) {
                  failed = true; error = value.error; value = null;
                } else {
                  succeeded = true;
                } if (promise === value) {
                  lib$es6$promise$$internal$$reject(promise, lib$es6$promise$$internal$$cannotReturnOwn()); return;
                }
              } else {
              value = detail; succeeded = true;
            } if (promise._state !== lib$es6$promise$$internal$$PENDING) { } else if (hasCallback && succeeded) {
              lib$es6$promise$$internal$$resolve(promise, value);
            } else if (failed) {
              lib$es6$promise$$internal$$reject(promise, error);
            } else if (settled === lib$es6$promise$$internal$$FULFILLED) {
              lib$es6$promise$$internal$$fulfill(promise, value);
            } else if (settled === lib$es6$promise$$internal$$REJECTED) {
              lib$es6$promise$$internal$$reject(promise, value);
            }
          } function lib$es6$promise$$internal$$initializePromise(promise, resolver) {
            try {
              resolver(function resolvePromise(value) {
                lib$es6$promise$$internal$$resolve(promise, value);
              }, function rejectPromise(reason) {
                lib$es6$promise$$internal$$reject(promise, reason);
              });
            } catch (e) {
              lib$es6$promise$$internal$$reject(promise, e);
            }
          } function lib$es6$promise$enumerator$$Enumerator(Constructor, input) {
            var enumerator = this; enumerator._instanceConstructor = Constructor; enumerator.promise = new Constructor(lib$es6$promise$$internal$$noop); if (enumerator._validateInput(input)) {
              enumerator._input = input; enumerator.length = input.length; enumerator._remaining = input.length; enumerator._init(); if (enumerator.length === 0) {
                lib$es6$promise$$internal$$fulfill(enumerator.promise, enumerator._result);
              } else {
                enumerator.length = enumerator.length || 0; enumerator._enumerate(); if (enumerator._remaining === 0) {
                  lib$es6$promise$$internal$$fulfill(enumerator.promise, enumerator._result);
                }
              }
            } else {
              lib$es6$promise$$internal$$reject(enumerator.promise, enumerator._validationError());
            }
          } lib$es6$promise$enumerator$$Enumerator.prototype._validateInput = function (input) {
            return lib$es6$promise$utils$$isArray(input);
          }; lib$es6$promise$enumerator$$Enumerator.prototype._validationError = function () {
            return new Error("Array Methods must be provided an Array");
          }; lib$es6$promise$enumerator$$Enumerator.prototype._init = function () {
            this._result = new Array(this.length);
          }; var lib$es6$promise$enumerator$$default = lib$es6$promise$enumerator$$Enumerator; lib$es6$promise$enumerator$$Enumerator.prototype._enumerate = function () {
            var enumerator = this; var length = enumerator.length; var promise = enumerator.promise; var input = enumerator._input; for (var i = 0; promise._state === lib$es6$promise$$internal$$PENDING && i < length; i++) {
              enumerator._eachEntry(input[i], i);
            }
          }; lib$es6$promise$enumerator$$Enumerator.prototype._eachEntry = function (entry, i) {
            var enumerator = this; var c = enumerator._instanceConstructor; if (lib$es6$promise$utils$$isMaybeThenable(entry)) {
              if (entry.constructor === c && entry._state !== lib$es6$promise$$internal$$PENDING) {
                entry._onerror = null; enumerator._settledAt(entry._state, i, entry._result);
              } else {
                enumerator._willSettleAt(c.resolve(entry), i);
              }
            } else {
              enumerator._remaining--; enumerator._result[i] = entry;
            }
          }; lib$es6$promise$enumerator$$Enumerator.prototype._settledAt = function (state, i, value) {
            var enumerator = this; var promise = enumerator.promise; if (promise._state === lib$es6$promise$$internal$$PENDING) {
              enumerator._remaining--; if (state === lib$es6$promise$$internal$$REJECTED) {
                lib$es6$promise$$internal$$reject(promise, value);
              } else {
                enumerator._result[i] = value;
              }
            } if (enumerator._remaining === 0) {
              lib$es6$promise$$internal$$fulfill(promise, enumerator._result);
            }
          }; lib$es6$promise$enumerator$$Enumerator.prototype._willSettleAt = function (promise, i) {
            var enumerator = this; lib$es6$promise$$internal$$subscribe(promise, undefined, function (value) {
              enumerator._settledAt(lib$es6$promise$$internal$$FULFILLED, i, value);
            }, function (reason) {
              enumerator._settledAt(lib$es6$promise$$internal$$REJECTED, i, reason);
            });
          }; function lib$es6$promise$promise$all$$all(entries) {
            return new lib$es6$promise$enumerator$$default(this, entries).promise;
          } var lib$es6$promise$promise$all$$default = lib$es6$promise$promise$all$$all; function lib$es6$promise$promise$race$$race(entries) {
            var Constructor = this; var promise = new Constructor(lib$es6$promise$$internal$$noop); if (!lib$es6$promise$utils$$isArray(entries)) {
              lib$es6$promise$$internal$$reject(promise, new TypeError("You must pass an array to race.")); return promise;
            } var length = entries.length; function onFulfillment(value) {
              lib$es6$promise$$internal$$resolve(promise, value);
            } function onRejection(reason) {
              lib$es6$promise$$internal$$reject(promise, reason);
            } for (var i = 0; promise._state === lib$es6$promise$$internal$$PENDING && i < length; i++) {
              lib$es6$promise$$internal$$subscribe(Constructor.resolve(entries[i]), undefined, onFulfillment, onRejection);
            } return promise;
          } var lib$es6$promise$promise$race$$default = lib$es6$promise$promise$race$$race; function lib$es6$promise$promise$resolve$$resolve(object) {
            var Constructor = this; if (object && (typeof object === "undefined" ? "undefined" : _typeof(object)) === "object" && object.constructor === Constructor) {
              return object;
            } var promise = new Constructor(lib$es6$promise$$internal$$noop); lib$es6$promise$$internal$$resolve(promise, object); return promise;
          } var lib$es6$promise$promise$resolve$$default = lib$es6$promise$promise$resolve$$resolve; function lib$es6$promise$promise$reject$$reject(reason) {
            var Constructor = this; var promise = new Constructor(lib$es6$promise$$internal$$noop); lib$es6$promise$$internal$$reject(promise, reason); return promise;
          } var lib$es6$promise$promise$reject$$default = lib$es6$promise$promise$reject$$reject; var lib$es6$promise$promise$$counter = 0; function lib$es6$promise$promise$$needsResolver() {
            throw new TypeError("You must pass a resolver function as the first argument to the promise constructor");
          } function lib$es6$promise$promise$$needsNew() {
            throw new TypeError("Failed to construct 'Promise': Please use the 'new' operator, this object constructor cannot be called as a function.");
          } var lib$es6$promise$promise$$default = lib$es6$promise$promise$$Promise; function lib$es6$promise$promise$$Promise(resolver) {
            this._id = lib$es6$promise$promise$$counter++; this._state = undefined; this._result = undefined; this._subscribers = []; if (lib$es6$promise$$internal$$noop !== resolver) {
              if (!lib$es6$promise$utils$$isFunction(resolver)) {
                lib$es6$promise$promise$$needsResolver();
              } if (!(this instanceof lib$es6$promise$promise$$Promise)) {
                lib$es6$promise$promise$$needsNew();
              } lib$es6$promise$$internal$$initializePromise(this, resolver);
            }
          } lib$es6$promise$promise$$Promise.all = lib$es6$promise$promise$all$$default; lib$es6$promise$promise$$Promise.race = lib$es6$promise$promise$race$$default; lib$es6$promise$promise$$Promise.resolve = lib$es6$promise$promise$resolve$$default; lib$es6$promise$promise$$Promise.reject = lib$es6$promise$promise$reject$$default; lib$es6$promise$promise$$Promise.prototype = {
            constructor: lib$es6$promise$promise$$Promise, then: function then(onFulfillment, onRejection) {
              var parent = this; var state = parent._state; if (state === lib$es6$promise$$internal$$FULFILLED && !onFulfillment || state === lib$es6$promise$$internal$$REJECTED && !onRejection) {
                return this;
              } var child = new this.constructor(lib$es6$promise$$internal$$noop); var result = parent._result; if (state) {
                var callback = arguments[state - 1]; lib$es6$promise$asap$$default(function () {
                  lib$es6$promise$$internal$$invokeCallback(state, child, callback, result);
                });
              } else {
                lib$es6$promise$$internal$$subscribe(parent, child, onFulfillment, onRejection);
              } return child;
            }, "catch": function _catch(onRejection) {
              return this.then(null, onRejection);
            }
          }; function lib$es6$promise$polyfill$$polyfill() {
            var local; if (typeof global !== "undefined") {
              local = global;
            } else if (typeof self !== "undefined") {
              local = self;
            } else {
              try {
                local = Function("return this")();
              } catch (e) {
                throw new Error("polyfill failed because global object is unavailable in this environment");
              }
            } var P = local.Promise; if (P && Object.prototype.toString.call(P.resolve()) === "[object Promise]" && !P.cast) {
              return;
            } local.Promise = lib$es6$promise$promise$$default;
          } var lib$es6$promise$polyfill$$default = lib$es6$promise$polyfill$$polyfill; var lib$es6$promise$umd$$ES6Promise = { Promise: lib$es6$promise$promise$$default, polyfill: lib$es6$promise$polyfill$$default }; if (typeof define === "function" && define["amd"]) {
            define(function () {
              return lib$es6$promise$umd$$ES6Promise;
            });
          } else if (typeof module !== "undefined" && module["exports"]) {
            module["exports"] = lib$es6$promise$umd$$ES6Promise;
          } else if (typeof this !== "undefined") {
            this["ES6Promise"] = lib$es6$promise$umd$$ES6Promise;
          } lib$es6$promise$polyfill$$default();
        }).call(this);
      }).call(this, require('_process'), typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {}, require("timers").setImmediate);
    }, { "_process": 1, "timers": 2 }], 33: [function (require, module, exports) {
      module.exports = function () {
        var userAgent = function userAgent(ua) {
          ua = (ua || window.navigator.userAgent).toString().toLowerCase();
          function checkUserAgent(ua) {
            var browser = {};
            var match = /(dolfin)[ \/]([\w.]+)/.exec(ua) || /(edge)[ \/]([\w.]+)/.exec(ua) || /(chrome)[ \/]([\w.]+)/.exec(ua) || /(opera)(?:.*version)?[ \/]([\w.]+)/.exec(ua) || /(webkit)(?:.*version)?[ \/]([\w.]+)/.exec(ua) || /(msie) ([\w.]+)/.exec(ua) || ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+))?/.exec(ua) || ["", "unknown"];
            if (match[1] === "webkit") {
              match = /(iphone|ipad|ipod)[\S\s]*os ([\w._\-]+) like/.exec(ua) || /(android)[ \/]([\w._\-]+);/.exec(ua) || [match[0], "safari", match[2]];
            } else if (match[1] === "mozilla") {
              if (/trident/.test(ua)) {
                match[1] = "msie";
              } else {
                match[1] = "firefox";
              }
            } else if (match[1] === "edge") {
              match[1] = "spartan";
            } else if (/polaris|natebrowser|([010|011|016|017|018|019]{3}\d{3,4}\d{4}$)/.test(ua)) {
              match[1] = "polaris";
            }

            browser[match[1]] = true;
            browser.name = match[1];
            browser.version = setVersion(match[2]);

            return browser;
          }

          function setVersion(versionString) {
            var version = {};

            var versions = versionString ? versionString.split(/\.|-|_/) : ["0", "0", "0"];
            version.info = versions.join(".");
            version.major = versions[0] || "0";
            version.minor = versions[1] || "0";
            version.patch = versions[2] || "0";

            return version;
          }

          function checkPlatform(ua) {
            if (isPc(ua)) {
              return "pc";
            } else if (isTablet(ua)) {
              return "tablet";
            } else if (isMobile(ua)) {
              return "mobile";
            } else {
              return "";
            }
          }

          function isPc(ua) {
            if (ua.match(/linux|windows (nt|98)|macintosh/) && !ua.match(/android|mobile|polaris|lgtelecom|uzard|natebrowser|ktf;|skt;/)) {
              return true;
            }
            return false;
          }

          function isTablet(ua) {
            if (ua.match(/ipad/) || ua.match(/android/) && !ua.match(/mobi|mini|fennec/)) {
              return true;
            }
            return false;
          }

          function isMobile(ua) {
            if (!!ua.match(/ip(hone|od)|android.+mobile|windows (ce|phone)|blackberry|bb10|symbian|webos|firefox.+fennec|opera m(ob|in)i|polaris|iemobile|lgtelecom|nokia|sonyericsson|dolfin|uzard|natebrowser|ktf;|skt;/)) {
              return true;
            } else {
              return false;
            }
          }

          function checkOs(ua) {
            var os = {},
              match = /(iphone|ipad|ipod)[\S\s]*os ([\w._\-]+) like/.exec(ua) || /(android)[ \/]([\w._\-]+);/.exec(ua) || (/android/.test(ua) ? ["", "android", "0.0.0"] : false) || (/polaris|natebrowser|([010|011|016|017|018|019]{3}\d{3,4}\d{4}$)/.test(ua) ? ["", "polaris", "0.0.0"] : false) || /(windows)(?: nt | phone(?: os){0,1} | )([\w._\-]+)/.exec(ua) || (/(windows)/.test(ua) ? ["", "windows", "0.0.0"] : false) || /(mac) os x ([\w._\-]+)/.exec(ua) || (/(linux)/.test(ua) ? ["", "linux", "0.0.0"] : false) || (/webos/.test(ua) ? ["", "webos", "0.0.0"] : false) || /(bada)[ \/]([\w._\-]+)/.exec(ua) || (/bada/.test(ua) ? ["", "bada", "0.0.0"] : false) || (/(rim|blackberry|bb10)/.test(ua) ? ["", "blackberry", "0.0.0"] : false) || ["", "unknown", "0.0.0"];

            if (match[1] === "iphone" || match[1] === "ipad" || match[1] === "ipod") {
              match[1] = "ios";
            } else if (match[1] === "windows" && match[2] === "98") {
              match[2] = "0.98.0";
            }
            os[match[1]] = true;
            os.name = match[1];
            os.version = setVersion(match[2]);
            return os;
          }

          function checkApp(ua) {
            var app = {},
              match = /(crios)[ \/]([\w.]+)/.exec(ua) || /(daumapps)[ \/]([\w.]+)/.exec(ua) || ["", ""];

            if (match[1]) {
              app.isApp = true;
              app.name = match[1];
              app.version = setVersion(match[2]);
            } else {
              app.isApp = false;
            }

            return app;
          }

          return {
            ua: ua,
            browser: checkUserAgent(ua),
            platform: checkPlatform(ua),
            os: checkOs(ua),
            app: checkApp(ua)
          };
        };

        return userAgent;
      }();
    }, {}], 34: [function (require, module, exports) {
      module.exports = function () {

        var parseUA = require('./userAgent.js');

        var TIMEOUT_IOS = 5 * 1000,
          TIMEOUT_ANDROID = 3 * 100,
          INTERVAL = 100,
          ua = parseUA(),
          os = ua.os,
          intentNotSupportedBrowserList = ['firefox', 'opr/'],
          intentSupportCustomBrowserList = ['KAKAOTALK'
          ];

        function moveToStore(storeURL) {
          window.top.location.replace(storeURL);
        }

        function web2app(context) {
          var willInvokeApp = typeof context.willInvokeApp === 'function' ? context.willInvokeApp : function () { },
            onAppMissing = typeof context.onAppMissing === 'function' ? context.onAppMissing : moveToStore,
            onUnsupportedEnvironment = typeof context.onUnsupportedEnvironment === 'function' ? context.onUnsupportedEnvironment : function () { };

          willInvokeApp();

          if (os.android) {
            if (isIntentSupportedBrowser() && context.intentURI && !context.useUrlScheme) {
              web2appViaIntentURI(context.intentURI);
            } else if (context.storeURL) {
              web2appViaCustomUrlSchemeForAndroid(context.urlScheme, context.storeURL, onAppMissing);
            }
          } else if (os.ios && context.storeURL) {
            web2appViaCustomUrlSchemeForIOS(context.urlScheme, context.storeURL, onAppMissing, context.universalLink);
          } else {
            setTimeout(function () {
              onUnsupportedEnvironment();
            }, 100);
          }
        }

        function isIntentSupportedBrowser() {
          var supportsIntent = ua.browser.chrome && +ua.browser.version.major >= 25;
          var blackListRegexp = new RegExp(intentNotSupportedBrowserList.join('|'), "i");
          var whiteListRegexp = new RegExp(intentSupportCustomBrowserList.join('|'), "i");
          return supportsIntent && !blackListRegexp.test(ua.ua) || whiteListRegexp.test(ua.ua);
        }

        function web2appViaCustomUrlSchemeForAndroid(urlScheme, storeURL, fallback) {
          deferFallback(TIMEOUT_ANDROID, storeURL, fallback);
          launchAppViaHiddenIframe(urlScheme);
        }

        function deferFallback(timeout, storeURL, fallback) {
          var clickedAt = new Date().getTime();
          return setTimeout(function () {
            var now = new Date().getTime();
            if (isPageVisible() && now - clickedAt < timeout + INTERVAL) {
              fallback(storeURL);
            }
          }, timeout);
        }

        function web2appViaIntentURI(launchURI) {
          if (ua.browser.chrome) {
            move();
          } else {
            setTimeout(move, 100);
          }

          function move() {
            top.location.href = launchURI;
          }
        }

        function web2appViaCustomUrlSchemeForIOS(urlScheme, storeURL, fallback, universalLink) {
          var tid = deferFallback(TIMEOUT_IOS, storeURL, fallback);
          if (parseInt(ua.os.version.major, 10) < 8) {
            bindPagehideEvent(tid);
          } else {
            bindVisibilityChangeEvent(tid);
          }

          if (isSupportUniversalLinks()) {
            if (universalLink === undefined) {
              universalLink = urlScheme;
            } else {
              clearTimeout(tid);
            }
            launchAppViaChangingLocation(universalLink);
          } else {
            launchAppViaHiddenIframe(urlScheme);
          }
        }

        function bindPagehideEvent(tid) {
          window.addEventListener('pagehide', function clear() {
            if (isPageVisible()) {
              clearTimeout(tid);
              window.removeEventListener('pagehide', clear);
            }
          });
        }

        function bindVisibilityChangeEvent(tid) {
          document.addEventListener('visibilitychange', function clear() {
            if (isPageVisible()) {
              clearTimeout(tid);
              document.removeEventListener('visibilitychange', clear);
            }
          });
        }

        function isPageVisible() {
          var attrNames = ['hidden', 'webkitHidden'];
          for (var i = 0, len = attrNames.length; i < len; i++) {
            if (typeof document[attrNames[i]] !== 'undefined') {
              return !document[attrNames[i]];
            }
          }
          return true;
        }

        function launchAppViaChangingLocation(urlScheme) {
          window.top.location.replace(urlScheme);
        }

        function launchAppViaHiddenIframe(urlScheme) {
          setTimeout(function () {
            var iframe = createHiddenIframe('appLauncher');
            iframe.src = urlScheme;
          }, 100);
        }

        function createHiddenIframe(id) {
          var iframe = document.createElement('iframe');
          iframe.id = id;
          iframe.style.border = 'none';
          iframe.style.width = '0';
          iframe.style.height = '0';
          iframe.style.display = 'none';
          iframe.style.overflow = 'hidden';
          document.body.appendChild(iframe);
          return iframe;
        }

        function isSupportUniversalLinks() {
          return parseInt(ua.os.version.major, 10) > 8 && ua.os.ios;
        }

        return web2app;
      }();
    }, { "./userAgent.js": 33 }]
  }, {}, [24])(24);
});
