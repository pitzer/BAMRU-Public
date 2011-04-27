require 'spec_helper'


describe PeriodicRunnerBlock do
  it "doesn't run for a public site"
end

describe PeriodicRunner do
  it "has a status (on/off)"
  it "doesn't run if peer isn't reachable"
  it "runs every 15 minutes"
  it "has a start method"
  it "has a stop method"
  it "has a configurable timer"
  it "has a configurable executable"
  it "overwrites data"
  it "doesn't run if data is identical"
  it "generates version history"
  it "only allows one background process at a time"
  it "has a PID attribute"
  it "tells if the background process is running or not"
  it "tells how much time is left until the next execution"
  it "tells how much time has elapsed since the last execution"
  it "is called from the settings object"
  it "remembers its state if the server restarts"
  it "restarts the task after it times out"
  it "sends alert message if process term status is not nil"
  it "doesn't leave zombie processes if the parent dies"
  it "does not run if the parent dies"
end