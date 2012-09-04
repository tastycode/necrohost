module Necrohost
  class Server
    module Views
      class Layout < Mustache
        HAML_INDENT_SIZE = 2

        def page_title
          @page_title || "Necrohost! Dare ye tread upon the server of death" 
        end

        def render template, options = {}
          options[:yield] = indented_yield(template, options[:yield])
          super template, options
        end

        def indented_yield haml_template, to_yield
          return to_yield unless to_yield
          # this is a patch to allow us to use haml with mustache :{/
          # we want the level of indent when the yield was referenced
          # but account for the yield having its own indent
          # that number 2 is a magic constant at the moment
          indentation_level = haml_template.to_s[/(\s+)v = ctx/,1].length - HAML_INDENT_SIZE
          unindented_tail = to_yield.lines.to_a[1..-1]
          indented_tail = unindented_tail.collect do |line|
            "#{" " * indentation_level}#{line}"
          end.join
          to_yield.lines.first + indented_tail
        end
      end
    end
  end
end
