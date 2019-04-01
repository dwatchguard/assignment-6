ruleset temperature_store {
  meta {
    provides temperatures, threshold_violations, inrange_temperatures
    shares __testing, temperatures, threshold_violations, inrange_temperatures
  }
  global {
    temperatures = function() {
      ent:temp_data
    };
    threshold_violations = function() {
      ent:vio_data
    };
    inrange_temperatures = function() {
      ent:temp_data.difference(ent:vio_data)
    }
  }
  rule collect_temperatures {
    select when wovyn new_temperature_reading
      fired {
        ent:temp_data := ent:temp_data.append({"temperature" : event:attr("temperature"), "timestamp" : event:attr("timestamp")});
        ent:temp_data := ent:temp_data.tail() if ent:temp_data[0] == null;
      }
  }
  rule collect_threshold_violations {
    select when wovyn threshold_violation
      fired {
         ent:vio_data := ent:vio_data.append({"temperature" : event:attr("temperature"), "timestamp": event:attr("timestamp")});
         ent:vio_data := ent:vio_data.tail() if ent:vio_data[0] == null;
      }
  }
  rule clear_temperatures {
    select when sensor reading_reset
      fired {
        clear ent:temp_data;
        clear ent:vio_data;
      }
  }
}
