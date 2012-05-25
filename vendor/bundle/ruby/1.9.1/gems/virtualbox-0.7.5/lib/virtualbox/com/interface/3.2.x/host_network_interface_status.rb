module VirtualBox
  module COM
    module Interface
      module Version_3_2_X
        class HostNetworkInterfaceStatus < AbstractEnum
          map [:unknown, :up, :down]
        end
      end
    end
  end
end