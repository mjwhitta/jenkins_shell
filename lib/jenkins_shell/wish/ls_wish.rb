require "djinni"

class LSWish < Djinni::Wish
    def aliases
        return ["ls", "dir"]
    end

    def description
        return "List directory contents"
    end

    def execute(args, djinni_env = Hash.new)
        jsh = djinni_env["jsh"]

        case djinni_env["os"]
        when JenkinsShell::OS.LINUX
            puts jsh.command("ls #{args}")
            djinni_env["djinni_prompt"] = "#{jsh.cwd}$ ".light_white
        when JenkinsShell::OS.WINDOWS
            puts jsh.command("dir #{args}")
            djinni_env["djinni_prompt"] = "#{jsh.cwd}> ".light_white
        end
    end

    def usage
        puts "#{aliases.join(", ")} [directory]"
        puts "    #{description}."
    end
end
