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
        puts jsh.pwd if (args.empty?)

        case djinni_env["os"]
        when JenkinsShell::OS.LINUX
            djinni_env["djinni_prompt"] = "#{jsh.cwd}$ ".light_white
        when JenkinsShell::OS.WINDOWS
            djinni_env["djinni_prompt"] = "#{jsh.cwd}> ".light_white
        end
    end

    def usage
        puts aliases.join(", ")
        puts "    #{description}."
    end
end
