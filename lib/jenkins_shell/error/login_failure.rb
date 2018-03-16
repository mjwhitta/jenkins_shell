class JenkinsShell::Error::LoginFailure < JenkinsShell::Error
    def initialize
        super("Failure to login")
    end
end
