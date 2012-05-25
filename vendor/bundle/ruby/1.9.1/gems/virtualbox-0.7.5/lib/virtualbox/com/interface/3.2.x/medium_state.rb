module VirtualBox
  module COM
    module Interface
      module Version_3_2_X
        class MediumState < AbstractEnum
          map [:not_created, :created, :locked_read, :locked_write, :inaccessible, :creating, :deleting]
        end
      end
    end
  end
end