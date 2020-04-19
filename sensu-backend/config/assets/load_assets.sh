#!/bin/bash
sensuctl asset add asachs01/sensu-go-cpu-check
sensuctl asset add nixwiz/sensu-go-fatigue-check-filter
sensuctl asset add sensu/sensu-slack-handler
sensuctl asset add sensu/monitoring-plugins
