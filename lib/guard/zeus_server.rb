require 'guard'
require 'guard/plugin'
require 'timeout'

module Guard
  # A Guard plugin that runs a Zeus server, and nothing else.
  class ZeusServer < Plugin
    DEFAULT_OPTIONS = {
      start_cmd: %w(zeus start),
      boot_timeout: 10.0
    }

    def initialize(options = {})
      super(DEFAULT_OPTIONS.merge(options))
    end

    def start
      stop

      UI.debug "Forking and running Zeus: #{options[:start_cmd].inspect}"
      reader, writer = IO.pipe
      @pid = Process.fork do
        $stdout.reopen(writer)
        $stderr.reopen(writer)
        exec(*options[:start_cmd])
      end

      block_on_initial_output(reader)
      UI.info "#{self.class} is running"
    end

    def block_on_initial_output(reader)
      timeout(options[:boot_timeout]) do
        loop do
          readers, _writers, _timeout = IO.select([reader], [], [], 1)
          break unless readers
          UI.debug readers[0].readline.strip
        end
      end
    rescue Timeout::Error
      UI.debug 'Timed out waiting for Zeus; letting it start in the background.'
    end

    def reload
      UI.info "#{self.class} is reloading"
      stop
      start
    end

    def stop
      File.unlink '.zeus.sock' if File.exist? '.zeus.sock'
      return unless @pid
      UI.debug "Stopping Zeus (PID #{@pid})"
      Process.kill(:INT, @pid)
      Process.waitpid(@pid, Process::WNOHANG)
      @pid = nil
      UI.debug 'Zeus stopped'
    end

    def run_on_modifications(_paths)
      reload
    end
  end
end
