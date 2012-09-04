require "guard"
require "guard/guard"
require "colorize"
require "popen4"

module Guard
  class Cloudformation < Guard

    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
      super
      @results = {}
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
      Dir.glob("#{@options[:templates_path]}/*.json")
    end

    def run!(paths)
      if validate(paths)
        Notifier.notify "Cloud formation templates are valid", :image => :success if @options[:notification]
      else
        Notifier.notify "Cloud formation templates are invalid", :image => :failed if @options[:notification]
        throw :task_has_failed
      end
    end

    # Returns true if all templates are valid
    # Returns false if just one template is invalid
    def validate(paths)
      UI.info "Validating Templates..." #.green
      @results = {}
      paths.each_slice(2) do |slice|
        puts "slice #{slice.inspect}"
        threads = []
        slice.each do |path|
          thread_id = (0...8).map{65.+(rand(25)).chr}.join
          @results[thread_id] = {}
          threads << Thread.new do
            output,success = command(path)
            @results[thread_id][:path] = path
            @results[thread_id][:success] = success
            @results[thread_id][:output] = output
          end
        end
        threads.collect {|t| t.join}
      end

      @results.each do |thread_id,data|
        if data[:success]
          puts "Template #{data[:path]} is valid".green
        else
          puts "Template #{data[:path]} is invalid".red
        end
        puts data[:output]
      end

      all_success = true
      @results.each do |thread_id,data|
        if !data[:success]
          all_success = false
          break
        end
      end
      all_success
    end

    def command(path)
      cmd = "cfn-validate-template --template-file #{path}"
      out = "#{cmd}\n"
      status = POpen4::popen4(cmd) do |stdout, stderr, stdin, pid|
        out << stdout.read
        out << stderr.read.red
        # puts "stderr: #{stderr.inspect}"
      end
      [out, status.success?]
    end

  end
end
