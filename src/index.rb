require_relative("./character.rb")
require "tty-prompt"
require "faker"
require "yaml"

$prompt = TTY::Prompt.new
$player = ""


#Shows and returns selection from the main menu
def main_menu
    main_selection = $prompt.select("Waz iz youz doinz, choom?") do |menu|
        menu.choice "Battlin' Orkz!"
        menu.choice "New Ork"
        menu.choice "Save Ork"
        menu.choice "Load Ork"
        menu.choice "Exit"
    end
    return main_selection
end

def yesno
    yesno = $prompt.select("", %w(No Yes))
    return yesno
end

def list_saves
    File.open("./saves.yml") do |file_iter|
        YAML.load_stream(file_iter) do |line|
            puts line.file_show
        end
    end
end

def battle(atkr)
    puts "YOU WISH TO ENTAH DA RING?" # KATY SAYS: Don't let people fight themselves.
    list_saves                        # Maybe do?
    load_file = gets.chomp
    if load_file != ""
        File.open("./saves.yml") do |file_iter|
            YAML.load_stream(file_iter) do |line|
                if line.to_s == load_file
                    $player = line
                end
            end
        end
    else
        system("clear")
        puts ("Datz no Ork I ever herdz of.")
        main_menu
    end
    atkr.hp = atkr.max
    dfndr.hp = dfndr.max
    puts "#{atkr.name} enterz da ring."
    puts "#{dfndr.name} rises to the challenge."
    puts ""
    3.times {
        print "."
    }
    puts "BWONNNGGGG! FIGHT!"
    
    if rand(1..6) + 2 >= 4
        atkr.attack(atkr,dfndr)
    else
    end
    while atkr.hp > 0 && dfndr.hp > 0
        dfndr.attack(dfndr, atkr)
        atkr.attack(atkr, dfndr)
    end
    if $player.xp.remainder(5) == 0
        $player.improve
    else 
    end
end


def quick_stats(arr)
    puts "Strongth\t| #{arr[0]}"
    puts "Quickz\t\t| #{arr[1]}"
    puts "Smartz\t\t| #{arr[2]}"
    puts "Wackness\t| #{arr[3]}"
    puts "Hurtpoints\t| #{arr[4]}"
end

def create_character(manual, named)
    if manual == -1
    #Manually make the character.

        system("clear")

        #Use the name in parameter if relevant, otherwise ask for one.
        if named != ""
            name = named
        else
            puts "What is your name?"
            name = gets.chomp
        end

        #Roll stats until player accepts them
        confirm_stat = ""
        while confirm_stat != "Yes"
            system("clear")
            puts "#{name}'s Stats:"
            stats = [rand(1..6), rand(1..6), rand(1..6), rand(1..6), rand(1..8)+2]
            quick_stats(stats)
            confirm_stat = $prompt.select("Are you happy with these stats?", %w(No Yes))
        end
        system("clear")
        #Let player pick a starting weapon and apply it's stats to their character
        weapon = ""
        while weapon == ""
            weapon = $prompt.select("Pick your startin weapon:") do |menu|
                menu.choice "Zword    | 1d8   | Strength"
                menu.choice "Zpear    | 1d8   | Dexterity"
                menu.choice "Ax'em    | 1d6+1 | Strength"
                menu.choice "Stabber  | 1d6+1 | Dexterity"
            end
            case weapon 
            when "Zword    | 1d8   | Strength"
                attack = ["rand(1..8)","str"]
            when "Zpear    | 1d8   | Dexterity"
                attack = ["rand(1..8)","dex"]
            when "Ax'em    | 1d6+1 | Strength"
                attack = ["rand(1..6)+1","str"]
            when "Stabber  | 1d6+1 | Dexterity"
                attack = ["rand(1..6)+1","dex"]
            end
        end
        $player = Character.new(name, stats[0], stats[1], stats[2], stats[3], stats[4], 11, 11, attack[0], attack[1], 1, 0, 20, stats[4])
        puts $player.to_s
    elsif manual == 0
    #Quickly autogenerate a character

        #Arrays used for weapon selection
        a = ["rand(1..6)+1","rand(1..8)"]
        b = ["str", "dex"]

        #Use name from parameter if provided, otherwise get a random one.
        if named != ""
            name = named
        else
            name = Faker::Games::ElderScrolls.name
        end

        hp = rand(1..8) + 2

        $player = Character.new(
            name,
            rand(1..6),
            rand(1..6),
            rand(1..6),
            rand(1..6),
            hp,
            11,
            11,
            a.sample,
            b.sample,
            1,
            2,
            0,
            hp,
            
        )
    else
    end
end

#Check for parameters, if file is named, automatically load, otherwise list all and ask
def load_game(load_file)
    if load_file != ""
        File.open("./saves.yml") do |file_iter|
            YAML.load_stream(file_iter) do |line|
                if line.to_s == load_file
                    $player = line
                    puts ("#{$player} waz loaded.")
                end
            end
        end
    else
        list_saves
        puts "Oi! Which Orkz iz you?"
        lf = gets.chomp
        if lf.length > 0 
            load_game(lf)
            system("clear")
        else
            system("clear")
            puts "Dun wayztin my time denz!"
        end
    end
end

#Accept arguments from command line
cmd1 = ARGV[0]
cmd2 = ARGV[1]
ARGV.clear
if cmd1 != nil
    if cmd1 == "load"
        if cmd2 != nil
            load_game(cmd2)
        else
            load_game("")
        end
    elsif cmd1 == "new"
        if cmd2 != nil
            create_character(-1, cmd2)
        else
            create_character(-1, "")
        end
    elsif cmd1 == "quick"
        if cmd2 != nil
            create_character(0, cmd2)
        else
            create_character(0, "")
        end
    else
        puts "Woopzie!"
    end
end



#Running the application
main_option = ""
system "clear"
puts "Welcome to Battle Orkz!"
while main_option != "Exit"
    #Call the main menu and get a selection
    main_option = main_menu
    case main_option
    when "Battlin' Orkz!"
        if $player != nil && $player != ""

        else
            system("clear")
            puts "You can't battle Orkz unless you'ze an Ork youzelf. Kapizh?"
        end
        #battle
    when "New Ork"
        create_character(-1, "")
        system "clear"
        puts "#{$player.to_s} created."
    when "Save Ork"
        if $player != nil && $player != ""
            $player.save_game
            system("clear")
            puts "#{$player.to_s} waz zaved."
        else
            system("clear")
            puts "What Ork? You ain't no Ork. Try again, Pal."
        end
    when "Load Ork"
        load_game("")
    else
        puts "Thanks for playing!"
        next
    end
end