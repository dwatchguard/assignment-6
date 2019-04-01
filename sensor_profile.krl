ruleset sensor_profile {
    meta {
        provides get_threshold, get_SMS, get_name, get_location, get_all
        shares get_threshold, get_SMS, get_name, get_location, get_all
    }
    global {
        get_threshold = function() {
            ent:threshold;
        }
        get_SMS = function() {
            ent:SMS;
        }
        get_name = function() {
            ent:name;
        }
        get_location = function() {
            ent:location;
        }
        get_all = function() {
            {"name" : ent:name, "threshold" : ent:threshold, "SMS" : ent:SMS, "location" : ent:location};
        }
        
    }
rule intialization {
  select when wrangler ruleset_added where event:attr("rids") >< meta:rid
  if ent:threshold.isnull() then noop();
  fired {
    ent:threshold := 75;
  }
}
  rule sensor_update {
    select when sensor profile_updated where event:attr("location") != null && event:attr("name") != null
    fired{
        ent:name := event:attr("name") if event:attr("name") != null;
        ent:location := event:attr("location") if event:attr("location") != null;
        ent:SMS := event:attr("SMS") if event:attr("SMS") != null;
        ent:threshold := event:attr("threshold").as("Number") if event:attr("threshold") != null;
    }
  }
}
