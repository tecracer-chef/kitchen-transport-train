require_relative "../../kitchen-transport-train/version"

require "forwardable" unless defined?(Forwardable)
require "kitchen/errors"
require "kitchen/transport/base"
require "train"

module Kitchen
  module Transport
    class ConnectionFailed < TransportFailed; end

    class Train < Kitchen::Transport::Base

      kitchen_transport_api_version 1

      plugin_version KitchenTransportTrain::VERSION

      def connection(state, &block)
        options = connection_options(config.to_hash.merge(state))
        options = adjust_options(options)

        Kitchen::Transport::Train::Connection.new(options, &block)
      end

      class Connection < Kitchen::Transport::Base::Connection
        extend Forwardable
        def_delegators :@connection, :close, :upload, :download, :wait_until_ready

        attr_reader :logger

        def initialize(options = {})
          @options = options
          @logger = Kitchen.logger

          @backend = ::Train.create(options[:backend], options)
          @connection = @backend.connection

          yield self if block_given?
        end

        def execute(command)
          return if command.nil?

          logger.debug("[Train/#{options[:backend]}] Execute (#{command})")

          result = @connection.run_command(command)

          if result.exit_status == 0
            logger.info(result.stdout)
          else
            logger.error(result.stderr)

            raise Transport::ConnectionFailed.new(
              "Train/#{options[:backend]} exited (#{result.exit_status}) for command: [#{command}]",
              result.exit_status
            )
          end
        end

        def login_command
          raise ::Kitchen::UserError, "Interactive shells are not possible with the Train transport"
        end
      end

      private

      # Builds the hash of options needed by the Connection object on construction.
      #
      # @param data [Hash] merged configuration and mutable state data
      # @return [Hash] hash of connection options
      # @api private
      def connection_options(data)
        defaults = {
          backend: windows_os? ? "winrm" : "ssh"
        }

        overrides = {
          instance_name: instance.name,
          kitchen_root: Dir.pwd,

          # Kitchen to Train
          host: data[:hostname],
          user: data[:username],
        }

        defaults.merge(data).merge(overrides)
      end

      def adjust_options(data)
        # Map Kitchen SSH transport to Train SSH transport options
        if data[:backend] == "ssh"
          data[:key_files] = data[:ssh_key]
          data.delete(:ssh_key)
        end

        data
      end
    end
  end
end

