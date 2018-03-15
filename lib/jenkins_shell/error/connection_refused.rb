class JenkinsShell::Error::ConnectionRefused < JenkinsShell::Error
    def initialize(host, port)
        super("Connection to #{host}:#{port} refused")
    end
end
