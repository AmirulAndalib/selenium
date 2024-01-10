# frozen_string_literal: true

# Licensed to the Software Freedom Conservancy (SFC) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The SFC licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Selenium
  module WebDriver
    class DriverFinder
      def initialize(options, service)
        @options = options
        @service = service
      end

      def browser_path
        paths[:browser_path]
      end

      def driver_path
        paths[:driver_path]
      end

      def browser_path?
        !browser_path.nil? && !browser_path.empty?
      end

      private

      def paths
        @paths ||= begin
          path = @service.class.driver_path
          path = path.call if path.is_a?(Proc)
          exe = @service.class::EXECUTABLE
          if path
            WebDriver.logger.debug("Skipping Selenium Manager; path to #{exe} specified in service class: #{path}")
            Platform.assert_executable(path)
            {driver_path: path}
          else
            output = SeleniumManager.binary_paths(*to_args(@options))
            formatted = {driver_path: Platform.cygwin_path(output['driver_path'], only_cygwin: true),
                         browser_path: Platform.cygwin_path(output['browser_path'], only_cygwin: true)}
            Platform.assert_executable(formatted[:driver_path])
            Platform.assert_executable(formatted[:browser_path])
            formatted
          end
        rescue StandardError => e
          WebDriver.logger.error("Exception occurred: #{e.message}")
          WebDriver.logger.error("Backtrace:\n\t#{e.backtrace&.join("\n\t")}")
          raise Error::NoSuchDriverError, "Unable to obtain #{exe}"
        end
      end

      def to_args(options)
        args = ['--browser', options.browser_name]
        if options.browser_version
          args << '--browser-version'
          args << options.browser_version
        end
        if options.respond_to?(:binary) && !options.binary.nil?
          args << '--browser-path'
          args << options.binary.gsub('\\', '\\\\\\')
        end
        if options.proxy
          args << '--proxy'
          args << (options.proxy.ssl || options.proxy.http)
        end
        args
      end
    end
  end
end
