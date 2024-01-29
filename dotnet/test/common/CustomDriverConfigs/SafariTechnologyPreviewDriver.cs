// <copyright file="SafariTechnologyPreviewDriver.cs" company="Selenium Committers">
// Licensed to the Software Freedom Conservancy (SFC) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The SFC licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
// </copyright>

namespace OpenQA.Selenium.Safari
{
    // This is a simple wrapper class to create a SafariDriver that
    // uses the technology preview implementation and has no parameters in the
    // constructor.
    public class SafariTechnologyPreviewDriver : SafariDriver
    {
        public SafariTechnologyPreviewDriver()
            : base(DefaultOptions)
        {
        }

        // Required for dynamic setting with `EnvironmentManager.Instance.CreateDriverInstance(options)`
        public SafariTechnologyPreviewDriver(SafariOptions options)
            : base(options)
        {
        }

        public SafariTechnologyPreviewDriver(SafariDriverService service, SafariOptions options)
            : base(service, options)
        {
        }

        public static SafariOptions DefaultOptions
        {
            get
            {
                SafariOptions options = new SafariOptions();
                options.UseTechnologyPreview();
                return options;
            }
        }
    }
}
