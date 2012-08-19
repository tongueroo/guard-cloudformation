require "guard"
require "guard/guard"
require "colorize"

module Guard
  class Cloudformation < Guard

    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
      super
      @options = {
        :all_on_start => true,
        :templates_path => "templates",
        :notification => true,
      }.merge(@options)
    end

    # Call once when Guard starts. Please override initialize method to init stuff.
    # @raise [:task_has_failed] when start has failed
    def start
      run_all if @options[:all_on_start]
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
      paths = all_paths
      run!(paths)
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_change(paths)
      run!(paths)
    end

    private

    def all_paths
      Dir.glob("#{@options[:templates_path]}/*")
    end

    def run!(paths)
      if validate(paths)
        Notifier.notify "Cloud formation templates are valid", :image => :success if @options[:notification]
      else
        Notifier.notify "Cloud formation templates are invalid", :image => :failed if @options[:notification]
        throw :task_has_failed
      end
    end

    def validate(paths)
      UI.info "Validating: #{paths.join(' ')}".green
      all_success = true
      paths.each do |path|
        puts "Validating #{path}...".green
        success = command(path)
        if !success
          puts "FAILED: #{path}".red
          all_success = false
        end
      end
      all_success
    end

    def command(path)
      system "cfn-validate-template --template-file #{path}"
    end
  end
end
