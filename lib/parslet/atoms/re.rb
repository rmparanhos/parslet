# Matches a special kind of regular expression that only ever matches one
# character at a time. Useful members of this family are: <code>character
# ranges, \\w, \\d, \\r, \\n, ...</code>
#
# Example: 
#
#   match('[a-z]')  # matches a-z
#   match('\s')     # like regexps: matches space characters
#
class Parslet::Atoms::Re < Parslet::Atoms::Base
  attr_reader :match, :re
  def initialize(match) # :nodoc:
    super()

    @match = match.to_s
    @re    = Regexp.new(self.match, Regexp::MULTILINE)
    @error_msgs = {
      :premature  => "Premature end of input", 
      :failed     => "Failed to match #{match.inspect[1..-2]}"
    }
  end

  def try(source, context) # :nodoc:
    return succ(source.consume(1)) if source.matches?(re)
    
    # No string could be read
    return context.err(self, source, @error_msgs[:premature]) \
      if source.eof?
        
    # No match
    return context.err(self, source, @error_msgs[:failed]) \
  end

  def to_s_inner(prec) # :nodoc:
    match.inspect[1..-2]
  end
end

