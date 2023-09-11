=begin "globals.rb" v0.2.1 | 2021/10/25 | by Tristano Ajmone | MIT License
================================================================================
Some custom Rake helpers required by our custom Ruby modules and which are used
in most of our Rakefiles.
================================================================================
=end

$repo_root = pwd

# Define OS-specific name of Null device, for redirection
case RUBY_PLATFORM
when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
  $devnull = "NUL"
else
  $devnull = "/dev/null"
end

def TaskHeader(text)
  hstr = "## #{text}"
  puts "\n#{hstr}"
  puts '#' * hstr.length
end

def PrintTaskFailureMessage(our_msg, app_msg)
    err_head = "\n*** TASK FAILED! "
    STDERR.puts err_head << '*' * (73 - err_head.length) << "\n\n"
    if our_msg != ''
      STDERR.puts our_msg
      STDERR.puts '-' * 72
    end
    STDERR.puts app_msg
    STDERR.puts '*' * 72
end

def SetFileTimeToZero(file)
  # ----------------------------------------------------------------------------
  # Set the last accessed and modified dates of 'file' to Epoch 00:00:00.
  # Sometimes we need to trick Rake into seeing a generated file as outdated,
  # e.g. because we're aborting the build when a tool raises warnings which
  # didn't prevent generating the target file, but we'd rather keep the file
  # for manual inspection -- since we're not sure whether it's malformed or not.
  # ----------------------------------------------------------------------------
  ts = Time.at 0
  File.utime(ts, ts, file)
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
