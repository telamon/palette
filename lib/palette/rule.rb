module Palette
  class Rule
    @@max_length = 0
    attr_reader :name, :fg, :bg, :gui

    def initialize(name, *args)
      options = args.last.is_a?(Hash) ? args.pop : {}

      @name = name.to_s

      @@max_length = @name.length if @name.length > @@max_length

      @fg   = options[:fg]  || args.first
      @bg   = options[:bg]  || (args.length > 1 ? args.last : nil)
      @gui  = options[:gui]
    end

    def to_s
      return "" if fg.nil? && bg.nil? && gui.nil?
      output = ["hi #{sprintf("%-#{@@max_length}s", name)}"]

      if fg
        color = Palette::Color.new(fg)
        output << %{guifg=#{sprintf("%-7s", color.to_hex)}}
        output << %{ctermfg=#{sprintf("%-4s", color.to_cterm)}}
      end

      if bg
        color = Palette::Color.new(bg)
        output << %{guibg=#{sprintf("%-7s", color.to_hex)}}
        output << %{ctermbg=#{sprintf("%-4s", color.to_cterm)}}
      end

      @gui ||= "none"

      output << %{gui=#{gui.to_s.upcase}}
      if gui =~ /italic/
        output << %{cterm=NONE}
      else
        output << %{cterm=#{gui.to_s.upcase}}
      end

      output.join(" ").strip
    end
  end
end
