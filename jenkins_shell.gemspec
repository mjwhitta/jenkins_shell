Gem::Specification.new do |s|
    s.name = "jenkins_shell"
    s.version = "0.1.0"
    s.date = Time.new.strftime("%Y-%m-%d")
    s.summary = "Simulate a Linux/Windows prompt using Jenkins."
    s.description = [
        "This gem will use the scripting functionality of Jenkins to",
        "simulate a Linux shell or Windows cmd prompt."
    ].join(" ")
    s.authors = ["Miles Whittaker"]
    s.email = "mjwhitta@gmail.com"
    s.executables = Dir.chdir("bin") do
        Dir["*"]
    end
    s.files = Dir["lib/**/*.rb"]
    s.homepage = "https://gitlab.com/mjwhitta/jenkins_shell"
    s.license = "GPL-3.0"
    s.add_development_dependency("rake", "~> 12.3", ">= 12.3.1")
    s.add_runtime_dependency("djinni", "~> 2.2", ">= 2.2.1")
    s.add_runtime_dependency("hilighter", "~> 1.2", ">= 1.2.3")
end
