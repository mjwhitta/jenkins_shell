require "djinni"

class CmdWish < Djinni::Wish
    def aliases
        return ["cmd"]
    end

    def description
        return "Run command as if in cmd (default behavior)"
    end

    def execute(args, djinni_env = Hash.new)
        usage if (args.empty?)

        jsh = djinni_env["jsh"]
        puts jsh.command(args)
        djinni_env["djinni_prompt"] = "#{jsh.cwd}> ".light_white
    end

    def usage
        puts "#{aliases.join(", ")} <commands>"
        puts "    #{description}."
    end
end
