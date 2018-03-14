require "djinni"

class PwdWish < Djinni::Wish
    def aliases
        return ["pwd"]
    end

    def description
        return "Show path of current path"
    end

    def execute(args, djinni_env = Hash.new)
        usage if (!args.empty?)

        jsh = djinni_env["jsh"]
        puts jsh.cwd if (args.empty?)
        djinni_env["djinni_prompt"] = "#{jsh.cwd}> ".light_white
    end

    def usage
        puts aliases.join(", ")
        puts "    #{description}."
    end
end
