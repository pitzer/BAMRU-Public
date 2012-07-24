class Nq

  # ----- Batch Sync Functions -----
  # - called by command-line tool to completely resync the calendars

  def self.sync
    invoke_rake_task("gcal:sync")
  end

  # ----- Event-Driven Sync Functions -----
  # - called by WebApp during CRUD operations

  def self.create_event(id)
    invoke_rake_task("gcal:create EVENT_ID=#{id}")
  end

  def self.update_event(id)
    invoke_rake_task("gcal:update EVENT_ID=#{id}")
  end

  def self.delete_event(id)
    invoke_rake_task("gcal:delete EVENT_ID=#{id}")
  end

  private

  # ----- Rake Wrappers -----

  def self.invoke_rake_task(command)
    background do
      system "mkdir -p log"
      cmd = "script/nq rake #{command} >> log/nq.log &"
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

