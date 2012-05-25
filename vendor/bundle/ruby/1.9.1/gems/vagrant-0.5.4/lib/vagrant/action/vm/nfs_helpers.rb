module Vagrant
  class Action
    module VM
      module NFSHelpers
        def clear_nfs_exports(env)
          env["host"].nfs_cleanup if env["host"]
        end
      end
    end
  end
end
