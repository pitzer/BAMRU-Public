module VirtualBox
  module COM
    module Interface
      module Version_3_1_X
        class BIOSBootMenuMode < AbstractEnum
          map [:disabled, :menu_only, :message_and_menu]
        end
      end
    end
  end
end