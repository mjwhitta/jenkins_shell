Gem::Specification.new do |s|
    s.name = "jenkins_shell"
    s.version = "0.1.2"
    s.date = Time.new.strftime("%Y-%m-%d")
    s.summary = "Simulate a Linux/Windows prompt using Jenkins."
    s.description = [
        "This gem will use the scripting functionality of Jenkins to",
        "simulate a Linux shell or Windows cmd prompt."
    ].join(" ")
    s.authors = ["Miles Whittaker"]
    s.email = "mj@whitta.dev"
    s.executables = Dir.chdir("bin") do
        Dir["*"]
    end
    s.files = Dir["lib/**/*.rb"]
    s.homepage = "https://gitlab.com/mjwhitta/jenkins_shell"
    s.license = "GPL-3.0"
    s.add_development_dependency("rake", "~> 13.0", ">= 13.0.0")
    s.add_runtime_dependency("djinni", "~> 2.2", ">= 2.2.5")
    s.add_runtime_dependency("hilighter", "~> 1.3", ">= 1.3.0")
end
