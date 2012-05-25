module VirtualBox
  module COM
    module Interface
      module Version_3_1_X
        class ClipboardMode < AbstractEnum
          map [:disabled, :host_to_guest, :guest_to_host, :bidirectional]
        end
      end
    end
  end
end