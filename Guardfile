guard :shell do
  watch(//) {|modified_files|
  modified_files } 
end

guard :minitest do
#guard :minitest, cli: "--verbose" do
  # with Minitest::Unit
  watch(%r{^test/(.*)\/?test_(.*)\.rb$}) { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^(.+).rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$}) { 'test' }

  # with Minitest::Spec
  watch(%r{^spec/(.*)_spec\.rb$})
  watch(%r{^/(.+)\.rb$})         { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/spec_helper\.rb$}) { 'spec' }
end

# yield plugin info
# Example 1: Run a single command whenever a file is added

notifier = proc do |title, _, changes|
  Guard::Notifier.notify(changes * ",", title: title )
end

guard :yield, { run_on_additions: notifier, object: "Add missing specs!" } do
  watch(/^(.*)\.rb$/) { |m| "spec/#{m}_spec.rb" }
end

# Example 2: log all kinds of changes

require 'logger'
yield_options = {
  object: ::Logger.new(STDERR), # passed to every other call

  start: proc { |logger| logger.level = Logger::INFO },
  stop: proc { |logger| logger.info "Guard::Yield - Done!" },

  run_on_modifications: proc { |log, _, files| log.info "!! #{files * ','}" },
  run_on_additions: proc { |log, _, files| log.warn "++ #{files * ','}" },
  run_on_removals: proc { |log, _, files| log.error "xx #{files * ','}" },
}

guard :yield, yield_options do
  watch(/^(.*)\.css$/)
  watch(/^(.*)\.jpg$/)
  watch(/^(.*)\.png$/)
end

# ----------------------------
# original comments from the top, in case I want them later

# omg, this:
# https://www.stefanwille.com/2015/07/guard-tutorial-run-command-on-file-change
# is so so much more usable (for me - AH) than:
# https://github.com/guard/guard#readme

# Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

