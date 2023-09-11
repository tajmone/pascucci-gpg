=begin "Rakefile" v0.0.1 | 2023/09/13 | by Tristano Ajmone
================================================================================
* Beware that CDing to a directory is a persistent action affecting all future
  'sh' commands -- always remember to 'cd $repo_root' before issuing shell
  commands from Rake, or manipulating task paths (working dir is affected!).
================================================================================
=end

# Custom helpers borrowed from ALAN-i18n repo ...

require './_assets/rake/globals.rb'
require './_assets/rake/asciidoc.rb'

# ==============================================================================
# --------------------{  P R O J E C T   S E T T I N G S  }---------------------
# ==============================================================================

DOCS_OUT_DIR = "#{$repo_root}/docs/"

ADOC_OPTS = <<~HEREDOC
  --failure-level WARN \
  --verbose \
  --timings \
  --safe-mode unsafe \
  -a docinfo@=shared-head \
  -a data-uri
HEREDOC

# ==============================================================================
# -------------------------------{  T A S K S  }--------------------------------
# ==============================================================================

task :default => [:html, :docinfo]

## Clean & Clobber
##################
require 'rake/clean'
CLEAN.include('**/*.html').exclude('**/docinfo.html')
CLOBBER.include('**/*.html')
CLOBBER.include('**/*.css')


## Docinfo File
###############
DOCINFO_FILE = 'docs_src/docinfo.html'
CSS_FILE = '_assets/sass/custom.css'
SCSS_SRC = '_assets/sass/custom.scss'
SCSS_DEPS = FileList['_assets/sass/_*.scss'].exclude('**/___*.scss')

desc "Create docinfo file"
task :docinfo => DOCINFO_FILE

file DOCINFO_FILE => CSS_FILE do |t|
  TaskHeader("Creating docinfo file from CSS")
  puts "CSS source:  #{CSS_FILE}"
  puts "HTML output: #{DOCINFO_FILE}"
  begin
    css_file = File.open("#{CSS_FILE}", "rt").read
    File.open("#{t.name}", "w") do |docinfo_file|
      docinfo_file.puts "<style>"
      docinfo_file.puts css_file
      docinfo_file.puts "</style>"
    end
  rescue
    PrintTaskFailureMessage("Unable to create docinfo file: #{DOCINFO_FILE}", nil)
    raise "Docinfo creation task failed."
  ensure
    cd $repo_root, verbose: false
  end
end

file CSS_FILE => [SCSS_SRC, *SCSS_DEPS] do |t|
  TaskHeader("Converting Sass to CSS: #{t.source}")
  cd "#{t.source.pathmap("%d")}"
  sh "sass #{t.name.pathmap("%n")}.scss #{t.name.pathmap("%n")}.css"
  cd $repo_root, verbose: false
end

## Mario Pascucci GnuPG Guide
#############################
SRC_DIR = 'docs_src'
HTML_FILE = 'docs/index.html'
ADOC_SRC = "#{SRC_DIR}/GnuPG-Pascucci.asciidoc"
ADOC_DEPS = FileList[ADOC_SRC, "#{SRC_DIR}/*.adoc", DOCINFO_FILE]

desc "Build HTML doc"
task :html => HTML_FILE

file HTML_FILE => ADOC_DEPS do |t|
  AsciidoctorConvert(
    ADOC_SRC,
    ADOC_OPTS,
    "#{$repo_root}/#{t.name.pathmap("%d")}",
    t.name.pathmap("%f")
  )
end
