module Necrohost
  class Server
    module Views
      class Sleep < Layout
        def sleep_time
          @sleep_time || 0
        end
      end
    end
  end
end
