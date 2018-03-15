class JenkinsShell::Error < RuntimeError
end

require "jenkins_shell/error/connection_refused"
require "jenkins_shell/error/invalid_html_received"
