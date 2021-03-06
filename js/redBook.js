/**
 * Created by bjwsl-001 on 2017/4/13.
 */

var app = angular.module('rb', ['ionic']);

app.factory('$debounce', ['$rootScope', '$browser', '$q', '$exceptionHandler',
    function($rootScope, $browser, $q, $exceptionHandler) {
        var deferreds = {},
            methods = {},
            uuid = 0;

        function debounce(fn, delay, invokeApply) {
            var deferred = $q.defer(),
                promise = deferred.promise,
                skipApply = (angular.isDefined(invokeApply) && !invokeApply),
                timeoutId, cleanup,
                methodId, bouncing = false;

            // check we dont have this method already registered
            angular.forEach(methods, function(value, key) {
                if (angular.equals(methods[key].fn, fn)) {
                    bouncing = true;
                    methodId = key;
                }
            });
            // not bouncing, then register new instance
            if (!bouncing) {
                methodId = uuid++;
                methods[methodId] = { fn: fn };
            } else {
                // clear the old timeout
                deferreds[methods[methodId].timeoutId].reject('bounced');
                $browser.defer.cancel(methods[methodId].timeoutId);
            }

            var debounced = function() {
                // actually executing? clean method bank
                delete methods[methodId];

                try {
                    deferred.resolve(fn());
                } catch (e) {
                    deferred.reject(e);
                    $exceptionHandler(e);
                }

                if (!skipApply) $rootScope.$apply();
            };

            timeoutId = $browser.defer(debounced, delay);

            // track id with method
            methods[methodId].timeoutId = timeoutId;

            cleanup = function(reason) {
                delete deferreds[promise.$$timeoutId];
            };

            promise.$$timeoutId = timeoutId;
            deferreds[timeoutId] = deferred;
            promise.then(cleanup, cleanup);

            return promise;
        }


        // similar to angular's $timeout cancel
        debounce.cancel = function(promise) {
            if (promise && promise.$$timeoutId in deferreds) {
                deferreds[promise.$$timeoutId].reject('canceled');
                return $browser.defer.cancel(promise.$$timeoutId);
            }
            return false;
        };

        return debounce;
    }
]);

//自定义服务
app.service('$customHttp', ['$http', '$ionicLoading',
    function($http, $ionicLoading) {
        this.get = function(url, handleSucc) {

            $ionicLoading.show({
                template: 'loading...'
            })

            $http
                .get(url)
                .success(function(data) {
                    $ionicLoading.hide();
                    handleSucc(data);
                })
        }
    }
])


//配置状态
app.config(function($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('start', {
            url: '/rbStart',
            templateUrl: 'tpl/start.html'
        })
        .state('main', {
            url: '/rbMain',
            templateUrl: 'tpl/main.html',
            controller: 'mainCtrl'
        })
        .state('detail', {
            url: '/rbDetail/:id',
            templateUrl: 'tpl/detail.html',
            controller: 'detailCtrl'
        })
        .state('order', {
            url: '/rbOrder/:cartDetail',
            templateUrl: 'tpl/order.html',
            controller: 'orderCtrl'
        })
        .state('myOrder', {
            url: '/rbMyOrder',
            templateUrl: 'tpl/myOrder.html',
            controller: 'myOrderCtrl'
        })
        .state('setting', {
            url: '/rbSetting',
            templateUrl: 'tpl/settings.html',
            controller: 'settingCtrl'
        })
        .state('cart', {
            url: '/rbCart',
            templateUrl: 'tpl/cart.html',
            controller: 'cartCtrl'
        })

    $urlRouterProvider.otherwise('/rbStart');
})


app.controller('parentCtrl', ['$scope', '$state',
    function($scope, $state) {
        $scope.jump = function(desState, argument) {
            $state.go(desState, argument);
        }
    }
])


app.controller('mainCtrl', ['$scope', '$customHttp', '$debounce',
    function($scope, $customHttp, $debounce) {

        $scope.hasMore = true;
        $scope.inputTxt = { kw: '' };

        $customHttp.get(
            'data/dish_getbypage.php',
            function(data) {
                console.log(data);
                $scope.dishList = data;
            }
        )

        $scope.loadMore = function() {
            $customHttp.get(
                'data/dish_getbypage.php?start=' + $scope.dishList.length,
                function(data) {
                    if (data.length < 5) {
                        $scope.hasMore = false;
                    }
                    $scope.dishList = $scope.dishList.concat(data);
                    $scope.$broadcast('scroll.infiniteScrollComplete')
                }
            )
        }

        $scope.$watch('inputTxt.kw', function() {

            $debounce(handleSearch, 300);

            //console.log($scope.inputTxt.kw);


        })
        handleSearch = function() {
            if ($scope.inputTxt.kw) {
                $customHttp.get(
                    'data/dish_getbykw.php?kw=' + $scope.inputTxt.kw,
                    function(data) {
                        $scope.dishList = data;
                    }
                )
            }
        }
    }

])

app.controller('detailCtrl', ['$scope', '$stateParams', '$customHttp', '$ionicPopup',
    function($scope, $stateParams, $customHttp, $ionicPopup) {
        //console.log($stateParams);
        $customHttp.get(
            'data/dish_getbyid.php?id=' + $stateParams.id,
            function(data) {
                //console.log(data)
                $scope.dish = data[0];
            }
        )

        $scope.addToCart = function() {
            $customHttp.get(
                'data/cart_update.php?uid=1&did=' +
                $scope.dish.did + "&count=-1",
                function(data) {
                    console.log(data);
                    if (data.msg == 'succ') {
                        $ionicPopup.alert({
                            template: '下单成功！'
                        })
                    }
                }
            )
        }

    }
])


app.controller('orderCtrl', ['$scope', '$stateParams', '$httpParamSerializerJQLike', '$customHttp', function($scope, $stateParams, $httpParamSerializerJQLike, $customHttp) {

    console.log($stateParams.cartDetail);

    /*
    *   userid-用户ID，必需
     phone-手机号，必需
     user_name-联系人名称，必需
     addr-送餐地址，必需
     totalprice-总价，必需
     cartDetail*/
    var totalPrice = 0;
    angular.forEach(
        angular.fromJson($stateParams.cartDetail),
        function(value, key) {
            totalPrice += (value.price * value.dishCount);
        }
    )
    $scope.order = {
        userid: 1,
        cartDetail: $stateParams.cartDetail,
        totalprice: totalPrice
    };

    $scope.submitOrder = function() {

        var result = $httpParamSerializerJQLike($scope.order)
        $customHttp.get(
            'data/order_add.php?' + result,
            function(data) {
                console.log(data);
                if (data[0].msg = 'succ') {
                    $scope.result = "下单成功，订单编号为" + data[0].oid;
                    sessionStorage.
                    setItem(
                        'phone',
                        $scope.order.phone);
                } else {
                    $scope.result = "下单失败！";
                }
            }
        )
    }
}])

app.controller('myOrderCtrl', ['$scope', '$customHttp',
    function($scope, $customHttp) {
        var phone = sessionStorage.getItem('phone')
        $customHttp.get(
            'data/order_getbyuserid.php?userid=1',
            function(dataFromServer) {
                console.log(dataFromServer);
                $scope.orderList = dataFromServer.data;
            }
        )
    }
])

app.controller('settingCtrl', ['$scope', '$ionicModal',
    function($scope, $ionicModal) {

        $ionicModal
            .fromTemplateUrl(
                'tpl/about.html', {
                    scope: $scope
                }
            ).then(function(modal) {
                $scope.modal = modal;
            })


        $scope.open = function() {
            $scope.modal.show();
        }

        $scope.close = function() {
            $scope.modal.hide();
        }
    }
])

app.controller('cartCtrl', ['$scope', '$customHttp',
    function($scope, $customHttp) {

        $scope.editEnable = false;
        $scope.editShowMsg = "编辑";
        $scope.funcEdit = function() {
            $scope.editEnable = !$scope.editEnable;
            if ($scope.editEnable) {
                $scope.editShowMsg = "完成";
            } else {
                $scope.editShowMsg = "编辑";
            }
        }

        $customHttp.get(
            'data/cart_select.php?uid=1',
            function(dataFromServer) {
                $scope.dishList = dataFromServer.data
            }
        )
        $scope.sumAll = function() {
            var totalPrice = 0;
            angular.forEach($scope.dishList,
                function(value, key) {
                    totalPrice += (value.price * value.dishCount);
                })
            return totalPrice;
        }

        $scope.add = function(index) {

            $scope.dishList[index].dishCount++;

            $customHttp.get(
                'data/cart_update.php?uid=1&did=' +
                $scope.dishList[index].did + '&count=' +
                $scope.dishList[index].dishCount,
                function(dataFromServer) {
                    console.log(dataFromServer);
                }
            )
        }

        $scope.minus = function(index) {
            $scope.dishList[index].dishCount--;
            if ($scope.dishList[index].dishCount == 0) {
                $scope.dishList[index].dishCount = 1;
            } else {
                $customHttp.get(
                    'data/cart_update.php?uid=1&did=' +
                    $scope.dishList[index].did + '&count=' +
                    $scope.dishList[index].dishCount,
                    function(dataFromServer) {
                        console.log(dataFromServer);
                    }
                )
            }


        }

        $scope.jumpToOrder = function() {
            var result = angular.toJson($scope.dishList);
            $scope.jump('order', { cartDetail: result });
        }
    }
])