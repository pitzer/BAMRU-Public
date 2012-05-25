module VirtualBox
  module COM
    module Interface
      module Version_3_1_X
        class HostUSBDevice < AbstractInterface
          IID = "173b4b44-d268-4334-a00d-b6521c9a740a"

          property :state, :USBDeviceState, :readonly => true
        end
      end
    end
  end
end