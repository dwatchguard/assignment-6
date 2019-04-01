
var base_url = "http://ec2-18-223-119-253.us-east-2.compute.amazonaws.com:8080";
var base_eci = "D9w88Wac7V6Fg8cEdnUv6h";
var current_children = {};
var current_temperatures = [];
addTemp = function(eci, temperature) {
    var url = base_url + "/sky/event/" + eci + "/1337/temp/add_temp?temperature=" + temperature;
    var httpReq = new XMLHttpRequest();
    httpReq.open("GET",url, false);
    httpReq.send();
};

addTemps = function(eci, numTemps) {
    min = 60;
    max = 80;
    for (i = 0; i < numTemps; i++) {
        addTemp(eci, Math.random() * (max - min) + min);
    }
};

getSensorProfile = function(eci) {
    var url = base_url + "/sky/cloud/" + eci + "/sensor_profile/get_all"  
    var httpReq = new XMLHttpRequest();
    httpReq.open("GET",url, false);
    httpReq.send();
    return JSON.parse(httpReq.responseText);
};

addSensor = function(eci, name) {
    var url = base_url + "/sky/event/" + eci + "/1337/sensor/new_sensor?name=" + name;
    var httpReq = new XMLHttpRequest();
    httpReq.onreadystatechange = function() {
        if(this.readyState == 4) {
            console.log("Created Sensor: " + name );
        }
    };
    httpReq.open("GET",url, false);
    httpReq.send();
};

deleteSensor = function(eci, name) {
    var url = base_url + "/sky/event/" + eci + "/1337/sensor/unneeded_sensor?name=" + name;
    var httpReq = new XMLHttpRequest();
        httpReq.onreadystatechange = function() {
        if(this.readyState == 4) {
            console.log("Deleted Sensor: " + name );
        }
    };
    httpReq.open("GET",url, false);
    httpReq.send();
};

runSensorTemperatures = function(eci) {
    var url = base_url + "/sky/cloud/" + eci + "/manage_sensors/sensor_temperatures";
    var httpReq = new XMLHttpRequest();
    httpReq.onreadystatechange = function() {
        if(this.readyState == 4) {
            current_temperatures = JSON.parse(this.responseText);
        }
    }
    httpReq.open("GET",url, false);
    httpReq.send();
};

getChildrenData = function(eci) {
    var url = base_url + "/sky/cloud/" + eci + "/manage_sensors/sensors";
    var httpReq = new XMLHttpRequest();
    httpReq.onreadystatechange = function() {
        if(this.readyState == 4) {
            current_children = JSON.parse(this.responseText);          
        }
    }
    httpReq.open("GET",url, false);
    httpReq.send();
    
};

addSensor(base_eci, "Sensor1");
addSensor(base_eci, "Sensor2");
addSensor(base_eci, "Sensor3");
addSensor(base_eci, "Sensor4");
addSensor(base_eci, "Sensor5");

getChildrenData(base_eci); 
var temp = current_children;
console.log("Current Children:");
console.log(temp);

console.log("Adding 5 temperature readings to all sensors: ")
for (var key in current_children) {
    addTemps(current_children[key], 5);  
}
runSensorTemperatures(base_eci);
var temp2 = current_temperatures;
console.log("Current Temperatures:")
console.log(temp2);

deleteSensor(base_eci, "Sensor1");
deleteSensor(base_eci, "Sensor2");
deleteSensor(base_eci, "Sensor3");

getChildrenData(base_eci); 
var temp3 = current_children;
console.log("Current Children:");
console.log(temp3);

console.log("Adding 5 temperature readings to all sensors: ")
for (var key in current_children) {
    addTemps(current_children[key], 5);  
}
runSensorTemperatures(base_eci);  
console.log("Current Temperatures:")  
var temp4 = current_temperatures;
console.log(temp4);

deleteSensor(base_eci, "Sensor4");
console.log("Sensor5 profile: ");
console.log(getSensorProfile(current_children["Sensor5"]));
deleteSensor(base_eci, "Sensor5");





