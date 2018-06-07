require "net/http"
require "rexml/document"
require "uri"

class JenkinsShell
    attr_reader :cookie
    attr_reader :crumb
    attr_reader :cwd
    attr_reader :host
    attr_reader :password
    attr_reader :port
    attr_reader :username

    def cd(dir = nil)
        return true if (dir.nil? || dir.empty?)

        new_cwd = pwd("#{@int_cwd}/#{dir}")

        return false if (new_cwd.empty? || (new_cwd == @cwd))

        @cwd = new_cwd
        @int_cwd = "#{@int_cwd}/#{dir}".gsub(%r{[^/]+/\.\.}, "")

        return true
    end

    def command(cmd, dir = @int_cwd)
        login if (@username && (@cookie.nil? || @crumb.nil?))
        if (@username && (@cookie.nil? || @crumb.nil?))
            raise JenkinsShell::Error::LoginFailure.new
        end

        # Create Groovy script
        gs = [
            "println(\"",
            "#{
                case @os
                when JenkinsShell::OS.LINUX
                    # FIXME
                    # "cd #{dir} && #{cmd}"
                    cmd
                when JenkinsShell::OS.WINDOWS
                    "cmd /c cd #{dir.gsub(/\\/, "\\\\\\")} && #{cmd}"
                end
            }",
            "\".execute().text",
            ")"
        ].join

        # Make POST request and return command output
        xml = post("/script", "script=#{encode(gs)}")[1]
        output = xml.get_elements("html/body/div/div/pre")[1]
        return "" if (output.nil?)
        return output.text.strip
    end

    def encode(str)
        # TODO what other chars need encoded?
        return URI::encode(URI::encode(str), "@&()/").gsub("%20", "+")
    end
    private :encode

    def get(path)
        begin
            # Establish connection
            http = Net::HTTP.new(@host, @port)
            http.use_ssl = @ssl

            # Create request
            req = Net::HTTP::Get.new("#{@path}#{path}")
            req["Cookie"] = @cookie if (@cookie)

            # Send request and get response
            res = http.request(req)

            # Parse HTML body
            xml = REXML::Document.new(res.body)

            # Store needed values
            store_state(res, xml)

            # Return headers and xml body
            return res, xml
        rescue Errno::ECONNREFUSED
            raise JenkinsShell::Error::ConnectionRefused.new(
                @host,
                @port
            )
        rescue REXML::ParseException
            raise JenkinsShell::Error::InvalidHTMLReceived.new
        end
    end
    private :get

    def initialize(params)
        @cookie = nil
        @crumb = nil
        @int_cwd = "."

        creds = "(([^:]+)(:(.+))?@)?"
        host = "([^:/]+)"
        path = "(/(.+))?"
        port = "(:([0-9]+))?"
        prot = "(https?)://"

        params["host"].match(
            /^#{prot}#{creds}#{host}#{port}#{path}/
        ) do |m|
            @host = m[6]
            @password = m[5]
            @path = m[10]
            @port = m[8]
            case m[1]
            when "http"
                @ssl = false
            when "https"
                @ssl = true
            end
            @username = m[3]
        end

        @os = params["os"]
        @password ||= params["password"]
        @path ||= params["path"]
        @path = "/#{@path}" if (@path)
        @port ||= params["port"] || 8080
        @ssl ||= params["ssl"] || false
        @username ||= params["username"]

        # Initialize @cwd
        @cwd = pwd
    end

    def login
        get("/login")
        post(
            "/j_acegi_security_check",
            [
                "j_username=#{encode(@username)}",
                "j_password=#{encode(@password)}",
                "Submit=log+in"
            ].join("&")
        )
        get("/")
    end

    def post(path, data)
        body = Array.new
        body.push("Jenkins-Crumb=#{@crumb}") if (@crumb)
        body.push(data)

        begin
            # Establish connection
            http = Net::HTTP.new(@host, @port)
            http.use_ssl = @ssl

            # Create request
            req = Net::HTTP::Post.new("#{@path}#{path}")
            req.body = body.join("&")
            req["Cookie"] = @cookie if (@cookie)

            # Send request and get response
            res = http.request(req)

            # Parse HTML response
            xml = REXML::Document.new(res.body)

            # Store needed values
            store_state(res, xml)

            # Return headers and xml body
            return res, xml
        rescue Errno::ECONNREFUSED
            raise JenkinsShell::Error::ConnectionRefused.new(
                @host,
                @port
            )
        rescue REXML::ParseException
            raise JenkinsShell::Error::InvalidHTMLReceived.new
        end
    end
    private :post

    def pwd(dir = @int_cwd)
        case @os
        when JenkinsShell::OS.LINUX
            return command("pwd", dir)
        when JenkinsShell::OS.WINDOWS
            command("dir", dir).match(/^\s+Directory of (.+)/) do |m|
                return m[1]
            end
        end
        return ""
    end

    def store_state(headers, xml)
        # Store crumb if it exists
        crumb = xml.get_elements("html/head/script").join
        crumb.match(/"Jenkins-Crumb", "([A-Fa-f0-9]+)"/) do |m|
            @crumb = m[1]
        end

        # Store cookie if there is one
        new_cookie = headers["Set-Cookie"]
        @cookie = new_cookie if (new_cookie)
    end
    private :store_state
end

require "jenkins_shell/error"
require "jenkins_shell/os"
