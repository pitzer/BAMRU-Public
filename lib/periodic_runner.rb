class PeriodicRunner
  def initialize(delay_in_seconds, &block)
    @block = block
    @delay_in_seconds = delay_in_seconds
  end

  def start(&block)
    puts "Starting Background Process"
    pid = fork do
      loop do
        value = yield
        wait @delay_in_seconds
      end
    end
    Process.detach(pid)
    pid
  end



end