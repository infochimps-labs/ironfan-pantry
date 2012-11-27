class Chef
  class Recipe

    def logrotate_option name, value=nil
      return unless value

      case value
      when true
        name.to_s
      when String
        lines = value.strip.split("\n")
        if lines.size == 1
          "#{name} #{lines.first}"
        else
          lines.map! do |line|
            line.insert(0, "\t\t")
            line.insert(-1, '\\')
          end
          "#{name}\n" + lines.join("\n")
        end
      else
        "#{name} #{value.to_s.strip}"
      end
    end
  end
  
end

