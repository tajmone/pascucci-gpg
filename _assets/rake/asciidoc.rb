=begin "asciidoc.rb" v0.3.2-mod | 2023/09/12 | by Tristano Ajmone | MIT License
================================================================================
Some custom Rake helper methods for automating common Asciidoctor operations
that we use across different documentation projects.

NOTE: This is a modified version of the original module from ALAN-i18n:
        https://github.com/alan-if/alan-i18n/blob/main/_assets/rake/asciidoc.rb
      The optional 'dest_dir' and 'out_file' parameters were added to specify
      the output folder and filename.
================================================================================
=end

require 'asciidoctor' # needed for Rouge!
require 'open3'

def AsciidoctorConvert(source_file, adoc_opts = "", dest_dir = nil, out_file = nil)
  # ----------------------------------------------------------------------------
  TaskHeader("Converting to HTML: #{source_file}")
  src_dir = source_file.pathmap("%d")
  src_file = source_file.pathmap("%f")
  if out_file
    adoc_opts = adoc_opts.chomp + " --out-file #{out_file}"
  else
    out_file = src_file.ext('.html')
  end
  adoc_opts = adoc_opts.chomp + " --destination-dir #{dest_dir}" unless !dest_dir
  adoc_opts = adoc_opts.chomp + " #{src_file}"
  cd "#{$repo_root}/#{src_dir}"
  begin
    stdout, stderr, status = Open3.capture3("asciidoctor #{adoc_opts}")
    puts stderr if status.success? # Even success is logged to STDERR!
    raise unless status.success?
  rescue
    rake_msg = our_msg = "Asciidoctor conversion failed: #{source_file}"
    if File.file?(out_file)
      our_msg = "Asciidoctor reported some problems during conversion.\n" \
        "The generated HTML file should not be considered safe to deploy."

      # Since we're invoking Asciidoctor with failure-level WARN, if the HTML
      # file was created we must set its modification time to 00:00:00 to trick
      # Rake into seeing it as an outdated target. (we're not 100% sure whether
      # it was re-created or it's the HTML from a previous run, but we're 100%
      # sure that it's outdated.)
      SetFileTimeToZero(out_file)
    end
    PrintTaskFailureMessage(our_msg, stderr)
    # Abort Rake execution with error description:
    raise rake_msg
  ensure
    cd $repo_root, verbose: false
  end
end

=begin
================================================================================
MIT License

Copyright (c) 2021-2023 Tristano Ajmone

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
================================================================================
=end
