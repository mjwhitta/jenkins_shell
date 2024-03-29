Gem::Specification.new do |s|
    s.add_development_dependency("rake", "~> 13.0", ">= 13.0.0")
    s.add_runtime_dependency("djinni", "~> 2.2", ">= 2.2.5")
    s.add_runtime_dependency("hilighter", "~> 1.5", ">= 1.5.1")
    s.authors = ["Miles Whittaker"]
    s.date = Time.new.strftime("%Y-%m-%d")
    s.description = [
        "This gem will use the scripting functionality of Jenkins to",
        "simulate a Linux shell or Windows cmd prompt."
    ].join(" ")
    s.email = "mj@whitta.dev"
    s.executables = Dir.chdir("bin") do
        Dir["*"]
    end
    s.files = Dir["lib/**/*.rb"]
    s.homepage = "https://github.com/mjwhitta/jenkins_shell"
    s.license = "GPL-3.0"
    s.metadata = {"source_code_uri" => s.homepage}
    s.name = "jenkins_shell"
    s.summary = "Simulate a Linux/Windows prompt using Jenkins."
    s.version = "0.1.3"
end
