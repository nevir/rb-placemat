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

      check_booted(reader)
      UI.info "#{self.class} is running"
    end

    def check_booted(reader)
      lines = consume_output(reader)
      check_boot_output(lines)
    rescue Timeout::Error
      UI.debug 'Timed out waiting for Zeus; letting it start in the background.'
    end

    def consume_output(reader)
      lines = []
      loop do
        readers, _writers, _timeout = IO.select([reader], [], [], 1)
        break unless readers
        line = readers[0].readline
        lines << line
        UI.debug(line.strip)
      end
      lines
    end

    def check_boot_output(lines)
      lines.each do |line|
        fail lines.join if line.include? 'exit status'
      end
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
