require_relative "a3"
include GCLe
puts GCLe::wellScoped(GCProgram.new([:x,:y], GCAssign.new(:x, GCVar.new(:x))))

puts GCLe::wellScoped(GCProgram.new([:x,:y], GCAssign.new(:x, GCVar.new(:y))))

puts GCLe::wellScoped(GCProgram.new([], GCLocal.new(:x, GCAssign.new(:x, GCVar.new(:x)))))
puts GCLe::wellScoped(GCProgram.new([:y], GCAssign.new(:x, GCVar.new(:x))))
puts GCLe::wellScoped(GCProgram.new([:x], GCAssign.new(:x, GCVar.new(:y))))
puts GCLe::wellScoped(GCProgram.new([], GCLocal.new(:y, GCAssign.new(:x, GCVar.new(:y)))))