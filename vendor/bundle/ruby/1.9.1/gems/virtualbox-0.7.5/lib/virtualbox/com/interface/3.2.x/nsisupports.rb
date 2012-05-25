module VirtualBox
  module COM
    module Interface
      module Version_3_2_X
        # This interface is actually only used with the FFI implementer but
        # is created here to allow easier usage with the FFI abstractions.
        class NSISupports < AbstractInterface
          function :QueryInterface, :pointer, [:pointer]
          function :AddRef, nil, []
          function :Release, nil, []
        end
      end
    end
  end
end
