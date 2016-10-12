/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

var status;


var domain = '118.69.135.152';
var stunDomain = '118.69.135.152';

var SIP;

var staticUser;
var staticPassword;
var staticDeviceToken;

var app = {
    // Application Constructor
initialize: function() {
    this.bindEvents();
},
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    
bindEvents: function() {
    document.addEventListener('deviceready', this.onDeviceReady, false);
},
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    
onDeviceReady: function() {
    app.receivedEvent('deviceready');
},
    // Update DOM on a Received Event
receivedEvent: function(id) {
    
    var parentElement = document.getElementById(id);
    var listeningElement = parentElement.querySelector('.listening');
    var receivedElement = parentElement.querySelector('.received');
    
    listeningElement.setAttribute('style', 'display:none;');
    receivedElement.setAttribute('style', 'display:block;');
    
    console.log('Received Event: ' + id);
    
    callNative('other', 'Ready', '');
    
    if (localStorage.getItem('userID')) {
        register(localStorage.getItem('userID'), localStorage.getItem('password'), localStorage.getItem('deviceToken'));
    }
    
    cordova.plugins.backgroundMode.setDefaults({
                                               title:  String,
                                               ticker: String,
                                               text:   String
                                               });
    
    cordova.plugins.backgroundMode.onactivate = function () {
        setTimeout(function () {
                   // Modify the currently displayed notification
                   console.log('background --------------- start');
                   cordova.plugins.backgroundMode.configure({
                                                            silent: false
                                                            });
                   }, 5000);
    }
}
};

app.initialize();

/*----- function handler of cordova.exec ------*/

function sayHelloSuccess() {
    //console.log('success');
}

function sayHelloFailure() {
    //console.log('failed');
}

/*----- function Register ------*/

function register(userName, password, deviceToken) {
    
    SIP = cordova.require('com.onsip.cordova.Sipjs');
    var PhoneRTCMediaHandler = cordova.require('com.onsip.cordova.SipjsMediaHandler')(SIP);
    
    var configuration = {
    traceSip: true,
    registerExpires: 110,
    mediaHandlerFactory: PhoneRTCMediaHandler,
    uri: userName +'@' + domain,
    wsServers: ['ws://' + domain +':5066'],
    authorizationUser:userName,
    password:password,
    register: true,
    displayName:userName,
    noAnswerTimeout: 28,
    stunServers:'stun:'+ stunDomain + ':3478'
    };
    
    window.userAgent = new SIP.UA(configuration);
    //window.userAgent.start();
    getUserAgentStatus();
    
    staticUser = userName;
    staticPassword = password;
    staticDeviceToken = deviceToken;
    
    callNative('user', 'registering', '');
}

/*----- function make Call ------*/

function makeCall(phoneNumber) {
    
    if (window.userAgent) {
        console.log ('is calling......'+phoneNumber);
        
        var options = {
        media: {
        constraints: {
        audio: true,
        video: false
        }
            // ,
            // render: {
            // remote: document.querySelector('video#remote'),
            // local: document.querySelector('video#local')
            // }
        }
        };
        
        window.session = window.userAgent.invite('sip:'+phoneNumber +'@' + domain, options);
        getSessionStatus();
        
        callNative('session', 'calling', '');
        
        cordova.plugins.backgroundMode.enable();
        console.log('=============' +cordova.plugins.backgroundMode.isEnabled());
        
    } else {
        callNative('session', 'dissmiss', '');
    }
}

/*----- function Hang Up ------*/

function hangUp() {
    
    if (window.session) {
        
        if (status == 'accepted') { // inviter is accepted
            window.session.bye();
            
        } else if(status == 'ringing') { // caller is receive ringing
            window.session.cancel();
            
        } else { // caller not receive ringing
            window.session.terminate();
            
        }
        
        window.session = null;
        callNative('session', 'hangup', '');
        
    } else {
        callNative('session', 'dissmiss', '');
    }
    
}

/*----- function UnRegister ------*/

function unRegister() {
    window.userAgent.stop();
    callNative('user', 'unregistering', '');
}

function clearLocalData() {
    localStorage.clear();
}

/*----- function Acept ------*/

function acept() {
    
    var options = {
    media: {
    constraints: {
    audio: true,
    video: false
    }
        //                ,
        //            render: {
        //            remote: document.querySelector('video#remote'),
        //            local: document.querySelector('video#local')
        //            }
    }
    };
    window.session.accept(options);
    getSessionStatus();
    
    callNative('session', 'waiting', '');
    
    cordova.plugins.backgroundMode.enable();
    //console.log('=============' +cordova.plugins.backgroundMode.isEnabled());
}

/*----- function User Status ------*/

function getUserAgentStatus() {
    
    window.userAgent.on('invite', function (new_session) {
                        console.log ('ahihi' + new_session);
                        
                        window.session = new_session;
                        getSessionStatus();
                        
                        var number = new_session.remoteIdentity.uri.toString();
                        number = number.split(":")[1].split("@")[0];
                        
                        callNative('user', 'invite', number);
                        });
    
    window.userAgent.on('connected', function () {
                        callNative('user', 'connected', '');
                        });
    
    window.userAgent.on('ack', function () {
                        callNative('user', 'ack', '');
                        });
    
    window.userAgent.on('disconnected', function () {
                        callNative('user', 'disconnected', '');
                        });
    
    window.userAgent.on('registrationFailed', function (cause) {
                        callNative('user', 'registrationFailed', cause.status_code);
                        //console.log('cause********'  + cause.status_code);
                        });
    
    window.userAgent.on('unregistered', function (cause) {
                        callNative('user', 'unregistered', '');
                        console.log(cause);
                        });
    
    window.userAgent.on('registered', function (object) {
                        
                        callNative('user', 'registered', object.call_id + '*' + object.getHeader('Department') + '*' + object.getHeader('Current-Time'));
                        
                        localStorage.setItem('userID', staticUser);
                        localStorage.setItem('password', staticPassword);
                        localStorage.setItem('deviceToken', staticDeviceToken);
                        
                        });
}

/*----- function Session Status ------*/

function getSessionStatus() {
    
    window.session.on('accepted', function (response) {
                      callNative('session', 'accepted', '');
                      });
    
    window.session.on('progress', function (response) {
                      
                      if((response.status_code >= 180) && (response.status_code <= 199)) {
                      callNative('session', 'ringing', '');
                      
                      } else {
                      //callNative('session', 'in progress', response.status_code);
                      }
                      });
    
    window.session.on('refer', function () {
                      callNative('session', 'refer', '');
                      });
    
    window.session.on('replaced', function () {
                      callNative('session', 'replaced', '');
                      });
    
    window.session.on('dtmf', function () {
                      callNative('session', 'dtmf', '');
                      });
    
    window.session.on('failed', function (reponse, cause) {
                      callNative('session', 'failed', cause);
                      });
    
    window.session.on('bye', function () {
                      callNative('session', 'bye', '');
                      window.session = null;
                      });
    
    window.session.on('cancel', function () {
                      callNative('session', 'cancel', '');
                      });
    
    window.session.on('rejected', function (response, cause) {
                      callNative('session', 'rejected', cause);
                      });
    
    window.session.on('terminated', function (message, cause) {
                      callNative('session', 'terminated', '');
                      window.session = null;
                      });
    
    //session.on('ended', function () {
    //           console.log('session: ended');
    //           //onTerminated();
    //           });
}

/*----- function Call Native IOS ------*/

function callNative(type, status, param) {
    changeStatus(status+ ' - ' +param);
    
    //setTimeout(function() {
    cordova.exec(sayHelloSuccess, sayHelloFailure, "CallNative", "echo", [type, status, param]);
    //});
}

/*----- function Change status ------*/

function changeStatus(st) {
    status = st;
    console.log(st);
}

function disableBackground() {
    cordova.plugins.backgroundMode.disable();
    console.log('Background --------- ' +cordova.plugins.backgroundMode.isEnabled());
}

function sendDTMF(key) {
    window.session.dtmf(key);
}
