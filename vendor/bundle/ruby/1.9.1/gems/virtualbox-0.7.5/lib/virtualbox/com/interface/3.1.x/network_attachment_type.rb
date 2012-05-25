module VirtualBox
  module COM
    module Interface
      module Version_3_1_X
        class NetworkAttachmentType < AbstractEnum
          map [:null, :nat, :bridged, :internal, :host_only]
        end
      end
    end
  end
end