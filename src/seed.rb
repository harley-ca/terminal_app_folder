require_relative("./index.rb")
require_relative("./character.rb")

monster_list = []
i = 0
while i < 21
    monster1 = create_character(rand(1..45))
    monster_list.push(monster1)
    i += 1
end

puts $monster_list
gets