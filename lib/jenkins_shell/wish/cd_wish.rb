require "djinni"
require "hilighter"

class CDWish < Djinni::Wish
    def aliases
        return ["cd"]
    end

    def description
        return "Change to new directory"
    end

    def execute(args, djinni_env = Hash.new)
        usage if (args.empty?)

        jsh = djinni_env["jsh"]
        if (!jsh.cd(args))
            puts "Directory not found"
            return
        end

        djinni_env["djinni_prompt"] = "#{jsh.cwd}> ".light_white
    end

    def usage
        puts "#{aliases.join(", ")} <directory>"
        puts "    #{description}."
    end
end
