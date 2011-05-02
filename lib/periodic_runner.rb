require 'yaml'

class PeriodicRunner

  attr_accessor :delay_seconds, :pid, :name, :code

  def initialize(params = {}, &code)
    set_params(params, code)
  end

  def self.reset_new(params = {}, &code)
    PeriodicRunner.new(params).remove_state_file
    PeriodicRunner.new(params)
  end

  def start
    raise "process is already running" if running?
    raise "no code" if @code.nil? || @code.blank?
    raise "needs delay_seconds param" unless valid_delay?
    @pid = fork do
      loop do
        sleep @delay_seconds
        @code.call
      end
    end
    Process.detach(pid)
    save
    pid
  end

  def stop
    return if @pid.nil? || @pid.class != Fixnum
    Process.kill("SIGKILL", @pid) if running?
  end

  def running?
    return false if @pid.blank?
    ! `ps #{@pid} | grep #{@pid}`.empty?
  end

  def seconds_from_last_execution
  end

  def seconds_till_next_execution
  end

  def state_file
    return "" if @name.blank?
    "#{state_dir}/#{@name}.yaml"
  end

  def remove_state_file
    system "rm -f #{state_file}" unless state_file.empty?
  end
  
  def save
    return "" if @name.empty?
    system "mkdir -p #{state_dir}"
    File.open(state_file, 'w') {|f| f.puts YAML.dump(params_hash)} unless state_file.empty?
  end

  def read_params_from_yaml_file
    return {} unless File.exist?(state_file)
    x = YAML.load(File.read(state_file))
    if x.nil?
      {}
    else
      x
    end
  end

  def valid_delay?
    @delay_seconds.is_a?(Fixnum) && @delay_seconds > 0
  end

  private

  def set_params(params, code)
    @name = params[:name] || ""
    yam_params     = read_params_from_yaml_file
    new_params     = yam_params.merge(params)
    @code          = code || new_params[:code]  || nil
    @pid           = new_params[:pid]           || nil
    @delay_seconds = new_params[:delay_seconds] || 0
    @name          = new_params[:name]          || ""
    save
  end

  def params_hash
    {
      :pid           => @pid || nil,
      :name          => @name,
      :delay_seconds => @delay_seconds
    }
  end

  def state_dir
    "/tmp/periodic_runner"
  end

end
