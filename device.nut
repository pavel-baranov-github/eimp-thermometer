#require "HTS221.device.lib.nut:2.0.2"

// Initialize an object to get temperature data
function thermometerInit(thermometerObj) {
    if (thermometerObj == null) {
        hardware.i2c89.configure(CLOCK_SPEED_400_KHZ);
        thermometerObj = HTS221(hardware.i2c89);
        thermometerObj.setMode(HTS221_MODE.ONE_SHOT);
        return thermometerObj;
    }
}

// Callback per temperature massage from agent
function sendTemperature(messageHandler) {
    local thermometer = null;
    local temperature = null;

    thermometer = thermometerInit(thermometer);
    
    if (thermometer != null) {
        temperature = thermometer.read();

        if ("error" in temperature) {
            agent.send("temperature", "An Error Occurred: " + temperature.error);
        } else {
            agent.send("temperature", temperature.temperature);
            server.log("Temperature sent from device: " + temperature.temperature);
        }
    } else {
        server.log("An Error Occurred: thermometer object not created");
    }
}

agent.on("temperature", sendTemperature);
