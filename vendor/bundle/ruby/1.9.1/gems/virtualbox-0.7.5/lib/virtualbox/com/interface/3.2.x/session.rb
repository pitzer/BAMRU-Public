module VirtualBox
  module COM
    module Interface
      module Version_3_2_X
        class Session < AbstractInterface
          IID_STR = "12F4DCDB-12B2-4EC1-B7CD-DDD9F6C5BF4D"

          property :state, :SessionState, :readonly => true
          property :type, :SessionType, :readonly => true
          property :machine, :Machine, :readonly => true
          property :console, :Console, :readonly => true

          function :close, nil, []
        end
      end
    end
  end
end
