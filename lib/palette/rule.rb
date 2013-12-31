module Palette
  class Rule
    @@max_length = 0
    attr_reader :name, :fg, :bg, :gui, :guisp

    def initialize(name, *args)
      options = args.last.is_a?(Hash) ? args.pop : {}

      @name = name.to_s

      @@max_length = @name.length if @name.length > @@max_length

      @fg    = options[:fg]  || args.first
      @bg    = options[:bg]  || (args.length > 1 ? args.last : nil)
      @gui   = options[:gui]
      @guisp = options[:guisp]
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

      output << %{gui=#{gui.upcase}}
      if gui =~ /italic/
        output << %{cterm=NONE}
      else
        output << %{cterm=#{gui.upcase}}
      end

      if @guisp
          color = Palette::Color.new(guisp)
          output << %{guisp=#{sprintf("%-7s", color.to_hex)}}
      end

      output.join(" ").strip
    end
  end
end
