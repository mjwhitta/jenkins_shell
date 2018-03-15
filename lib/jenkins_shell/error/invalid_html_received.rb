class JenkinsShell::Error::InvalidHTMLReceived < JenkinsShell::Error
    def initialize
        super("Invalid HTML received")
    end
end
