module Necrohost
  class Server
    module Views
      class Layout < Mustache
        HAML_INDENT_SIZE = 2

        def page_title
          @page_title || "Necrohost! Dare ye tread upon the server of death" 
        end

        def render template, options = {}
          if options[:yield]
            # this is a patch to allow us to use haml with mustache :{/
            # we want the level of indent when the yield was referenced
            # but account for the yield having its own indent
            # that number 2 is a magic constant at the moment
            indentation_level = template.to_s[/(\s+)v = ctx/,1].length - HAML_INDENT_SIZE
            unindented_tail = options[:yield].lines.to_a[1..-1]
            indented_tail = unindented_tail.collect do |line|
              "#{" " * indentation_level}#{line}"
            end.join
            indented_yield = options[:yield].lines.first + indented_tail
            options[:yield] = indented_yield
          end
          super template, options
        end
      end
    end
  end
end
