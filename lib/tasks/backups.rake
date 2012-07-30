  namespace :backup do

    def backup_params
      {
        "db"     => {
                :target => "db/production.sqlite3",
                :copies => 25 }
      }
    end

    def backup(dataset)
      app        = "borg"
      host       = `hostname`.chomp
      user       = `whoami`.chomp
      params     = backup_params[dataset]
      base_dir   = File.expand_path("~/.backup")
      time_stamp = Time.now.strftime("%y%m%d_%H%M%S")
      lbl_dir    = [base_dir, app, host, dataset].join('/')
      tgt_dir    = [base_dir, app, host, dataset, time_stamp].join('/')
      system "mkdir -p #{tgt_dir}"

      # ----- copy command -----
      cp_cmd  = Proc.new {|data_path| "cp #{data_path} #{tgt_dir}"}

      # ----- build a list of targets to copy -----
      target  = params[:target]
      targets = target.class == Array ? target : [target]

      # ----- copy each target -----
      puts "Backing up #{dataset}"
      targets.each do |path|
        cmd = cp_cmd.call(path)
        puts cmd
        system cmd
      end

      # ----- delete old backups if they exceed the copy limit -----
      list = Dir.glob(lbl_dir + '/*').sort.reverse
      list.each_with_index do |path, index|
        if index >= params[:copies]
          puts   "Removing old backup: #{path}"
          system "rm -r #{path}"
        end
      end
    end

    desc "Backup Database"
    task :db do
      backup("db")
    end

  end
