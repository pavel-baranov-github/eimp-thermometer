// HTML code for generating a HTTP response
const HTML_HEAD     = "@{include("http-response-head.html")   | escape}";
const HTML_BOTTOM   = "@{include("http-response-bottom.html") | escape}";

// Class for storing temperature value
class Temperature {
    temperature = null;

    constructor() {
        temperature = {
            "value" : 0.0,
            "error" : "An Error Occurred: device did not provide data"
        };
    }

    function set(temperatureValue) {
        server.log("Temperature value: " + temperatureValue);
        temperature.value = temperatureValue;
        temperature.error = "";
    }

    function get() {
        return temperature;
    }
}

// Callback per temperature massage from device
function getTemperature(temperatureValue) {
    temperature.set(temperatureValue);
}

// Callback per HTTP GET request to agent
function getHTTPResponse(request, response) {
    local result = {};

    if (request.method == "GET") {
        device.send("temperature", null);
        
        result = temperature.get();
        if (result.error == "") {
            response.send(200, HTML_HEAD + result.value + HTML_BOTTOM);
        } else {
            response.send(200, HTML_HEAD + result.error + HTML_BOTTOM);
        }
    }
}

temperature <- Temperature();
device.on("temperature", getTemperature);
http.onrequest(getHTTPResponse);
device.send("temperature", null);
