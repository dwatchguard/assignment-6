ruleset wovyn_base {
  meta {
        use module sensor_profile
        use module lesson_keys
        use module twilio alias twilio
        with account_sid = keys:twilio{"account_sid"}
        auth_token =  keys:twilio{"auth_token"}
        provides default_threshold
  }
 rule process_heartbeat {
    select when wovyn heartbeat where event:attr("genericThing") != null
    send_directive("wovyn", {"body" : "Heartbeat Received"});
    fired {
        raise wovyn event "new_temperature_reading" attributes { "temperature": event:attr("genericThing").get(["data", "temperature", 0, "temperatureF"]), "timestamp": time:now()};
    }
  }
// add_temp was added to make it easier for my script to add 'fake' readings to the sensor for testing purposes
  rule add_temp {
    select when temp add_temp
        fired {
            raise wovyn event "new_temperature_reading" 
                attributes {"temperature" : event:attr("temperature"), "timestamp": time:now()};
        }
  }
 rule find_high_temps {
    select when wovyn new_temperature_reading
    pre {
    temp = event:attr("temperature");
    violation = event:attr("temperature") > sensor_profile:get_threshold();
    
    }
    send_directive("violation", {"vio": violation, "temp" : temp});
    fired {
        raise wovyn event "threshold_violation" attributes {"temperature" : event:attr("temperature"), "timestamp" : event:attr("timestamp")} if violation;
    }
  }
 rule threshold_notification {
    select when wovyn threshold_violation
    twilio:send_sms(sensor_profile:get_SMS().as("String"), "16677712304", "There was a violation");
 } 
}
