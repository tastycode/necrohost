module Necrohost
  class Server
    module Views
      class Index < Layout
        def header_main
          "Be prepared!"
        end
        def content
          "Welcome! Mustache lives."
        end
      end
    end
  end
end
