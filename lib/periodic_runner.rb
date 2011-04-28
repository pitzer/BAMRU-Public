require 'yaml'

class PeriodicRunner

  attr_accessor :delay_seconds, :pid, :name, :code

  def initialize(params = {}, &code)
    set_params(params, code)
  end

  def self.reset_new(params = {}, &code)
    PeriodicRunner.new(params, code).remove_state_file
    PeriodicRunner.new(params, code)
  end

  def start(params = {}, &code)
    set_params(params, code)
    puts "Starting Background Process"
    @pid = fork do
      loop do
        @code.call
        sleep @delay_seconds
      end
    end
    Process.detach(pid)
    save
    pid
  end

  def restart(params = {}, &code)
    set_params(params, code)
    stop
    start
  end

  def stop
    Process.kill("SIGKILL", @pid)
  end

  def running?
    `ps #{@pid} | grep #{@pid}`.empty?
  end

  def seconds_from_last_execution
  end

  def seconds_till_next_execution
  end

  def state_file
    return "" if @name.blank?
    name = "#{state_dir}/#{@name}.yaml"
  end

  def remove_state_file
    system "rm -f #{state_file}" unless state_file.empty?
  end

  private

  def set_params(params, code)
    new_params     = read_params_from_yaml_file.merge(params)
    @code          = code || new_params[:code]  || nil
    @delay_seconds = new_params[:delay_seconds] || 0
    @name          = new_params[:name]          || ""
    save
  end

  def params_hash
    {
      :pid           => @pid || nil,
      :code          => @code,
      :name          => @name,
      :delay_seconds => @delay_seconds
    }
  end

  def state_dir
    "/tmp/periodic_runner"
  end

  def read_params_from_yaml_file
    return {} unless File.exist?(state_file)
    YAML.load(File.read(state_file))
  end

  def save
    return "" if @name.empty?
    system "mkdir -p #{state_dir}"
    File.open(state_file, 'w') {|f| f.puts YAML.dump(params_hash)} unless state_file.empty?
  end

end
