class Nq

  # ----- Calendar Sync -----
  # - called by command-line tool to completely resync the calendars

  def self.sync
    invoke_rake_task("gcal:sync")
  end

  def self.create_event(id)
    invoke_rake_task("gcal:create EVENT_ID=#{id}")
  end

  def self.update_event(id)
    invoke_rake_task("gcal:update EVENT_ID=#{id}")
  end

  def self.delete_event(id)
    invoke_rake_task("gcal:delete EVENT_ID=#{id}")
  end
  
  def self.alert_mail(message = nil)
    alert_env = message.nil? ? "" : " ALERT_MSG=#{message}"
    invoke_rake_task("alert_mail#{alert_env}")
  end

  private

  # ----- Rake Wrappers -----

  def self.invoke_rake_task(command)
    background do
      system "mkdir -p log"
      cmd = "script/nq rake #{command} >> log/nq.log 2>> log/nq.log &"
      system cmd
    end
  end

  def self.background(&block)
    Process.fork do
      Process.fork do
        block.call
      end
      exit
    end
  end

end

