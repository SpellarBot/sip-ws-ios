cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/com.onsip.cordova/www/phonertc.js",
        "id": "com.onsip.cordova.PhoneRTC",
        "pluginId": "com.onsip.cordova",
        "clobbers": [
            "cordova.plugins.phonertc"
        ]
    },
    {
        "file": "plugins/com.onsip.cordova/www/index.js",
        "id": "com.onsip.cordova.SipjsMediaHandler",
        "pluginId": "com.onsip.cordova",
        "clobbers": [
            "cordova.plugins.phonertc.mediahandler"
        ]
    },
    {
        "file": "plugins/com.onsip.cordova/www/sip.js",
        "id": "com.onsip.cordova.Sipjs",
        "pluginId": "com.onsip.cordova",
        "clobbers": [
            "cordova.plugins.sipjs"
        ]
    },
    {
        "file": "plugins/cordova-plugin-device/www/device.js",
        "id": "cordova-plugin-device.device",
        "pluginId": "cordova-plugin-device",
        "clobbers": [
            "device"
        ]
    },
    {
        "file": "plugins/cordova-plugin-background-mode/www/background-mode.js",
        "id": "cordova-plugin-background-mode.BackgroundMode",
        "pluginId": "cordova-plugin-background-mode",
        "clobbers": [
            "cordova.plugins.backgroundMode",
            "plugin.backgroundMode"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.2.2",
    "com.onsip.cordova": "1.0.0",
    "cordova-plugin-device": "1.1.2",
    "cordova-plugin-background-mode": "0.6.5"
}
// BOTTOM OF METADATA
});