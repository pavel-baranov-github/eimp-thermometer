// HTML code for generating a HTTP response
const HTML_HEAD     = "@{include("http-response-head.html")   | escape}";
const HTML_BOTTOM   = "@{include("http-response-bottom.html") | escape}";

// Class for storing temperature value
class Temperature {
    temperature = null;

    constructor() {
        Temperature = "An Error Occurred: device did not provide data";
    }

    function set(temperatureValue) {
        server.log("Temperature value: " + temperatureValue);
        temperature = temperatureValue;
    }

    function get() {
        if (temperature == null) {
            temperature = "An Error Occurred: device did not provide data";
        }
        return temperature;
    }
}

// Callback per temperature massage from device
function getTemperature(messageHandler) {
    temperature.set(messageHandler);
}

// Callback per HTTP GET request to agent
function getHTTPResponse(request, response) {
    if (request.method == "GET") {
        device.send("temperature", null);
        response.send(200, HTML_HEAD + temperature.get() + HTML_BOTTOM);
    }
}

temperature <- Temperature();
device.on("temperature", getTemperature);
http.onrequest(getHTTPResponse);
device.send("temperature", null);
