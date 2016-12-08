require 'passenger_with_gun/version'
require 'logger'

module PassengerWithGun
    module Rails
        class Engine < ::Rails::Engine
            DEFAULT_MEMORY_LIMIT = 150
            DEFAULT_LOG_FILE = 'passenger_monitoring.log'.freeze
            WAIT_TIME = 10

            def self.run(params = {})
                new(params).check
            end


            def initialize(params = {})
                @memory_limit = params[:memory_limit] || DEFAULT_MEMORY_LIMIT
                @log_file = params[:log_file] || DEFAULT_LOG_FILE
                @logger = Logger.new(@log_file)
            end


            def check
                @logger.info 'Checking for bloated Passenger workers'
                `passenger-memory-stats`.each_line do |line|
                    next unless line =~ /RackApp: / || line =~ /Rails: /
                    pid, memory_usage = extract_stats(line)
                    next unless bloated?(pid, memory_usage)
                    kill(pid)
                    wait
                    kill!(pid) if process_running?(pid)
                 end
                @logger.info 'Finished checking for bloated Passenger workers'
            end

            private


            def process_running?(pid)
                Process.getpgid(pid) != -1
            rescue Errno::ESRCH
                false
            end


            def wait
                @logger.error 'Waiting for worker to shutdown...'
                sleep(WAIT_TIME)
            end


            def kill(pid)
                @logger.error "Trying to kill #{pid} gracefully..."
                Process.kill('SIGUSR1', pid)
            end


            def kill!(pid)
                @logger.fatal "Force kill: #{pid}"
                Process.kill('TERM', pid)
            end


            def extract_stats(line)
                stats = line.split
                [stats[0].to_i, stats[3].to_f]
            end

            def bloated?(pid, size)
                bloated = size > @memory_limit
                @logger.error "Found bloated worker: #{pid} - #{size}MB" if bloated
                bloated
            end
        end
    end
end
